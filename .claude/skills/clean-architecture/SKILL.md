---
name: clean-architecture
description: Clean Architecture patterns for Flutter — data models with primitives-only rule, mapper pattern, use case variants, dependency injection scoping, environment configuration, Firebase data conversion.
---

# Clean Architecture Patterns

## Data Models — Primitives Only

**Data models MUST use ONLY primitive types: String, int, double, bool, DateTime, List/Map of primitives.**
**NEVER use enums, custom classes, or complex objects in @freezed + json_serializable models.**

```dart
// ❌ WRONG
@freezed
class UserModel with _$UserModel {
  factory UserModel({required UserRole role}) = _UserModel;  // enum in model
}

// ✅ CORRECT
@freezed
class UserModel with _$UserModel {
  factory UserModel({required String role}) = _UserModel;  // primitive
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

// ✅ Domain entity uses rich types
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({required UserRole role}) = _UserEntity;
}
```

## Mandatory Mapper Pattern

**Dedicated mappers convert between data models (primitives) and domain entities (rich types).**

Location: `features/[feature]/data/mappers/[entity]_mapper.dart`

```dart
class UserMapper {
  static UserEntity toEntity(UserModel model) => UserEntity(
    role: UserRole.values.firstWhere(
      (e) => e.name == model.role,
      orElse: () => UserRole.unknown,
    ),
  );

  static UserModel toModel(UserEntity entity) => UserModel(
    role: entity.role.name,
  );
}
```

### Enum Serialization Strategies

```dart
// String-based (recommended): role: entity.role.name → "admin"
// Custom values:
extension UserRoleExtension on UserRole {
  String toJson() => {UserRole.admin: 'ADMIN', UserRole.user: 'USER'}[this]!;
  static UserRole fromJson(String value) =>
      {  'ADMIN': UserRole.admin, 'USER': UserRole.user}[value] ?? UserRole.unknown;
}
```

## Firebase Data Conversion

**ALWAYS use `FirebaseDataConverter.deepConvertMap()` for Firebase RTDB and Cloud Functions data.**

```dart
// ❌ WRONG — fails on nested objects
final data = Map<String, dynamic>.from(entry.value as Map);

// ✅ CORRECT — recursive conversion
final data = FirebaseDataConverter.deepConvertMap(entry.value);
final model = RideRequestModel.fromJson(data);
```

**When to use:** Firebase RTDB `.onValue`, Cloud Functions responses, any nested Maps.
**NOT needed for:** Firestore (already returns proper types).

Location: `core/utils/firebase_data_converter.dart`

---

## Use Case Patterns

**ONE public method: `call()`. ONE responsibility. Always `@injectable`.**

### Variant 1: Future with Either (most common)

```dart
@injectable
class CreateRideRequestUseCase {
  final RideRepository _repository;
  CreateRideRequestUseCase(this._repository);

  Future<Either<RideFailure, RideRequestEntity>> call(
    CreateRideRequestParams params,
  ) => _repository.createRideRequest(params);
}
```

### Variant 2: Stream (real-time data)

```dart
@injectable
class WatchActiveRideUseCase {
  final RideRepository _repository;
  WatchActiveRideUseCase(this._repository);

  Stream<Either<RideFailure, RideEntity?>> call() =>
      _repository.watchActiveRide();
}
```

### Variant 3: No params

```dart
@injectable
class GetCurrentUserUseCase {
  final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  Future<Either<AuthFailure, UserEntity>> call() =>
      _repository.getCurrentUser();
}
```

### Params Pattern (when >2 parameters)

```dart
@freezed
class CreateRideRequestParams with _$CreateRideRequestParams {
  const factory CreateRideRequestParams({
    required String rideId,
    required LocationEntity pickup,
    required LocationEntity dropoff,
    String? promoCode,
  }) = _CreateRideRequestParams;
}
```

### Rules

- Location: `features/[feature]/domain/usecases/[use_case_name].dart`
- Return type: `Future<Either<Failure, T>>` or `Stream<Either<Failure, T>>`
- Parameters via Params class (>2 args) or direct arguments

---

## Dependency Injection Scoping (get_it + injectable)

| Annotation | Lifecycle | When to Use |
|-----------|-----------|-------------|
| `@lazySingleton` | Single instance, first use | Services, repositories, data sources |
| `@singleton` | Single instance, startup | Core services needed immediately |
| `@preResolve` | Async, resolved before app | SharedPreferences, database init |
| `@injectable` | New instance each time | BLoCs, Cubits |
| `@module` | Groups registrations | Firebase instances, third-party SDKs |

```dart
// ✅ Repository: @lazySingleton
@lazySingleton
class AuthRepositoryImpl implements AuthRepository { ... }

// ✅ BLoC: @injectable (new instance per screen)
@injectable
class RideBloc extends Bloc<RideEvent, RideState> { ... }

// ✅ Third-party: @module
@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}
```

### Anti-patterns

```dart
@lazySingleton  // ❌ BLoC as singleton — shared state across screens
class RideBloc extends Bloc<RideEvent, RideState> { ... }

@injectable  // ❌ Repository as injectable — recreated on each injection
class AuthRepositoryImpl implements AuthRepository { ... }
```

### Registration Order

1. `@module` (Firebase, SharedPreferences, SDKs)
2. `@lazySingleton` data sources → repositories → use cases
3. `@injectable` BLoCs/Cubits

---

## Environment Configuration

```dart
class EnvConfig {
  EnvConfig._();

  static String get apiBaseUrl => _require('API_BASE_URL');
  static String get mapboxToken => _require('MAPBOX_PUBLIC_TOKEN');

  static bool get debugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  static Future<void> load({String fileName = '.env'}) async {
    await dotenv.load(fileName: fileName);
    _validateRequiredKeys();
  }

  static void _validateRequiredKeys() {
    final missing = _requiredKeys
        .where((key) => dotenv.env[key]?.isEmpty ?? true)
        .toList();
    if (missing.isNotEmpty) {
      throw StateError('Missing env variables: ${missing.join(', ')}');
    }
  }

  static String _require(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) throw StateError('Missing: $key');
    return value;
  }

  static const _requiredKeys = ['API_BASE_URL', 'MAPBOX_PUBLIC_TOKEN'];
}
```

### File Structure

```
project_root/
├── .env              # Gitignored
├── .env.example      # Committed (template)
└── lib/core/config/
    └── env_config.dart
```

### Rules

- `.env` ALWAYS in `.gitignore`, `.env.example` ALWAYS committed
- Validate ALL required keys at startup (fail fast)
- Use typed getters, not raw `dotenv.env[]`
- Load in `main()` before `runApp()`

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();
  await configureDependencies();
  runApp(const MyApp());
}
```

---

## Folder Structure

```
lib/
├── core/
│   ├── config/          # EnvConfig
│   ├── theme/           # AppSpacing, AppColors, AppAssets...
│   ├── utils/           # FirebaseDataConverter, extensions
│   └── error/           # Base Failure class
├── features/
│   └── [feature]/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/       # @freezed + json_serializable (primitives only)
│       │   ├── mappers/      # Model ↔ Entity conversion
│       │   └── repositories/ # Implementation
│       ├── domain/
│       │   ├── entities/     # @freezed (rich types)
│       │   ├── repositories/ # Abstract contracts
│       │   └── usecases/     # Business logic
│       └── presentation/
│           ├── bloc/         # BLoC + events + states
│           ├── pages/
│           ├── widgets/
│           └── extensions/   # Failure display extensions
└── injection.dart            # DI configuration
```
