---
name: bloc-patterns
description: BLoC state management patterns for Flutter — emit.forEach streams, compound state with metadata, BLoC layer agnosticism. Reference patterns for correct and incorrect implementations.
---

# BLoC Patterns

## Stream Handling — emit.forEach (MANDATORY)

**ALWAYS use `emit.forEach` in BLoC event handlers. Manual `.listen()` is an anti-pattern.**

### Correct Pattern

```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  final WatchDataUseCase _watchDataUseCase;

  MyBloc(this._watchDataUseCase) : super(const MyState.initial()) {
    on<Started>(_onStarted);
  }

  Future<void> _onStarted(Started event, Emitter<MyState> emit) async {
    emit(const MyState.loading());

    await emit.forEach(
      _watchDataUseCase(),
      onData: (result) => result.fold(
        (failure) {
          debugPrint('[MyBloc] Stream error: ${failure.toDebugMessage()}');
          return MyState.error(failure: failure);
        },
        (data) {
          debugPrint('[MyBloc] Received data: $data');
          return MyState.loaded(data: data);
        },
      ),
      onError: (error, stackTrace) {
        debugPrint('[MyBloc] Stream error: $error');
        if (error is MyFailure) return MyState.error(failure: error);
        return MyState.error(failure: MyFailure.unknown());
      },
    );
  }
  // No close() override needed! No StreamSubscription instance variable!
}
```

### Wrong Pattern (ANTI-PATTERN)

```dart
// ❌ NEVER do this
class MyBloc extends Bloc<MyEvent, MyState> {
  StreamSubscription? _subscription;  // ❌ Instance variable

  Future<void> _onStarted(Started event, Emitter<MyState> emit) async {
    await _subscription?.cancel();  // ❌ Manual cancellation
    _subscription = _watchDataUseCase().listen(  // ❌ .listen()
      (result) {
        if (!isClosed) { ... }  // ❌ Manual isClosed guard
      },
    );
  }

  @override  // ❌ Manual close() override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

### Key Differences

| Aspect | emit.forEach | Manual .listen() |
|--------|-------------|-----------------|
| Instance variables | None | StreamSubscription |
| Lifecycle | Automatic | Manual (cancel, close) |
| Event handler | Returns state | Calls emit() |
| Cancellation | Auto on new event/close | Manual in multiple places |
| isClosed guards | Not needed | Required |
| close() override | Not needed | Required |
| Memory leaks | Impossible | Easy to introduce |

### Best Practices

1. **Return states, don't emit**: `return MyState.loaded(data)` not `emit(MyState.loaded(data))`
2. **Handle typed errors**: Check `error is MyFailure` in onError
3. **Cancellation by re-emission**: To stop stream, just add the same event again (auto-cancels previous)
4. **Exception**: Constructor-level subscriptions for global state (AuthBloc) can use `.listen()` to dispatch events

### Testing

```dart
test('should handle stream updates', () async {
  final mockStream = Stream.fromIterable([Right(data1), Left(failure)]);
  when(() => useCase()).thenAnswer((_) => mockStream);

  bloc.add(const Started());

  await expectLater(bloc.stream, emitsInOrder([
    const MyState.loading(),
    MyState.loaded(data: data1),
    MyState.error(failure: failure),
  ]));
});
```

---

## Compound State with Metadata

**NEVER emit generic `loading()` that loses business data. ALWAYS use `isLoading` metadata.**

### Philosophy: State = Business Data + UI Context

### Anti-pattern: State Explosion

```dart
// ❌ N states × M actions = unmanageable
const factory RideState.activeRideLoading(RideEntity ride) = ...;
const factory RideState.activeRideCancelling(RideEntity ride) = ...;
```

### Pattern 1: Status Enum (simple apps, forms)

```dart
enum Status { initial, loading, success, failure }

@freezed
class RideState with _$RideState {
  const factory RideState({
    @Default(Status.initial) Status status,
    RideEntity? ride,
    RideFailure? error,
  }) = _RideState;
}

emit(state.copyWith(status: Status.loading));  // Preserves ride
```

### Pattern 2: Union + Metadata (RECOMMENDED for complex apps)

```dart
@freezed
class RideState with _$RideState {
  const factory RideState.activeRideFound(
    RideEntity ride, {
    @Default(false) bool isLoading,
    RideFailure? error,
  }) = _ActiveRideFound;

  const factory RideState.requestPending({
    required String requestId,
    required String driverId,
    required DateTime expiresAt,
    @Default(false) bool isLoading,
    RideFailure? error,
  }) = _RequestPending;
}
```

### Before/After Example

```dart
// ❌ BEFORE — context loss
emit(const RideState.loading());  // Loses ride data!

// ✅ AFTER — context preserved
state.maybeWhen(
  activeRideFound: (ride, _, __) {
    emit(RideState.activeRideFound(ride, isLoading: true));  // Keep ride
  },
  orElse: () => emit(const RideState.loading()),
);
```

### UI with Metadata

```dart
state.when(
  activeRideFound: (ride, isLoading, error) => Stack(
    children: [
      RideDetailsCard(ride: ride),  // Always visible
      if (isLoading)
        Container(color: Colors.black38, child: Center(child: CircularProgressIndicator())),
      if (error != null)
        ErrorBanner(message: error.toUserMessage(context)),
    ],
  ),
);
```

### Decision: Which Pattern?

- **Status Enum**: Simple forms, single-entity CRUD, team prefers simplicity
- **Union + Metadata**: Multiple distinct states, Freezed unions, complex async workflows, type safety needed

### Golden Rules

1. One State = Business Data + Metadata
2. isLoading preserves data — no generic loading() that erases everything
3. Always check `isClosed` after `await` in event handlers

---

## BLoC Layer Agnosticism

**BLoCs MUST NOT convert Failure objects to String messages. UI layer handles translation.**

### Correct

```dart
@freezed
class MyState with _$MyState {
  const factory MyState.error(Failure failure) = _Error;  // Typed Failure
}

// BLoC passes typed Failure
emit(MyState.error(failure));  // ✅

// UI extension handles conversion
extension MyFailureDisplay on MyFailure {
  String toDisplayMessage(AppLocalizations l10n) => when(
    notFound: (_) => l10n.error_notFound,
    network: () => l10n.common_error_network,
    unknown: () => l10n.common_error_unknown,
  );
}
```

### Wrong

```dart
// ❌ String message in state — loses type information
const factory MyState.error(String message) = _Error;

// ❌ BLoC converts to String
emit(MyState.error(_getErrorMessage(failure)));  // Loses type info
```

### Benefits

- **Separation of concerns**: BLoC = logic, UI = presentation
- **Type safety**: UI can pattern match on Failure types (retry button, navigation)
- **Testability**: BLoC tests don't need BuildContext or localization mocks
- **Maintainability**: Changing error messages doesn't require BLoC changes
