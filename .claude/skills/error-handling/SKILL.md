---
name: error-handling
description: Flutter error handling and i18n patterns — Type-First Translate-Last architecture, typed Failures through all layers, Failure extension pattern for UI localization, ARB file organization.
---

# Error Handling & Internationalization

## Type-First, Translate-Last Pattern

**Zero hardcoded strings in data/domain/core layers. Translation exclusively in presentation layer.**

### Layer Responsibilities

| Layer | Responsibility | Contains |
|-------|---------------|----------|
| Service | Throw exceptions with TYPE enum | `ServiceException(type: ErrorType.notFound)` |
| Repository | Map Exception → Failure (type-to-type) | `catch (e) => Left(RideFailure.notFound())` |
| Domain | Failure classes with TYPE only | `RideFailure.notFound(rideId)` |
| BLoC | Emit typed Failure in state | `emit(MyState.error(failure))` |
| UI | Translate Failure → localized message | `failure.toDisplayMessage(l10n)` |

### Exception Design

```dart
class ServiceException implements Exception {
  final ErrorType type;
  final String? debugInfo;  // For logging only, never shown to user
  const ServiceException({required this.type, this.debugInfo});
}
```

### Failure Design

```dart
@freezed
class RideFailure with _$RideFailure {
  const factory RideFailure.notFound(String rideId) = _NotFound;
  const factory RideFailure.alreadyConfirmed(String rideId) = _AlreadyConfirmed;
  const factory RideFailure.networkError() = _NetworkError;
  const factory RideFailure.serverError(int? code) = _ServerError;
  const factory RideFailure.unknown() = _Unknown;
}
```

### BLoC State Design

```dart
@freezed
class MyState with _$MyState {
  const factory MyState.error(Failure failure) = _Error;  // Typed Failure, NOT String
}
```

---

## Failure Extension Pattern — Bridge from Domain to UI

**ONE extension per Failure type. Takes `AppLocalizations`, NOT `BuildContext`.**

Location: `features/[feature]/presentation/extensions/[failure]_display.dart`

```dart
extension RideFailureDisplay on RideFailure {
  String toDisplayMessage(AppLocalizations l10n) {
    return when(
      notFound: (rideId) => l10n.ride_error_notFound,
      alreadyConfirmed: (_) => l10n.ride_error_alreadyConfirmed,
      networkError: () => l10n.common_error_network,
      serverError: (code) => l10n.common_error_server,
      unknown: () => l10n.common_error_unknown,
    );
  }
}
```

### Usage in UI

```dart
BlocListener<RideBloc, RideState>(
  listener: (context, state) {
    state.maybeWhen(
      error: (failure) {
        if (failure is RideFailure) {
          final message = failure.toDisplayMessage(AppLocalizations.of(context)!);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      orElse: () {},
    );
  },
)
```

### Rules

- Must handle ALL cases exhaustively via `when()` (compiler-enforced)
- Common failures (network, server, unknown) use `common_error_*` ARB keys
- Feature-specific failures use `{feature}_error_{errorType}` ARB keys
- Extension takes `AppLocalizations` as parameter, NOT `BuildContext`

---

## ARB File Organization

### Naming Convention

```
{feature}_error_{errorType}
```

### Structure

```json
// app_en.arb
{
  "ride_error_notFound": "Ride not found",
  "ride_error_alreadyConfirmed": "This ride has already been confirmed",
  "payment_error_cardDeclined": "Your card was declined",
  "payment_error_insufficientFunds": "Insufficient funds",
  "common_error_network": "Network error. Please check your connection.",
  "common_error_server": "Server error. Please try again later.",
  "common_error_unknown": "An unexpected error occurred"
}
```

```json
// app_fr.arb
{
  "ride_error_notFound": "Course introuvable",
  "ride_error_alreadyConfirmed": "Cette course a déjà été confirmée",
  "payment_error_cardDeclined": "Votre carte a été refusée",
  "payment_error_insufficientFunds": "Fonds insuffisants",
  "common_error_network": "Erreur réseau. Vérifiez votre connexion.",
  "common_error_server": "Erreur serveur. Veuillez réessayer plus tard.",
  "common_error_unknown": "Une erreur inattendue s'est produite"
}
```

### Rules

- Maintain parity between all ARB files (en, fr, etc.)
- Group by feature, then by error type
- ALL user-facing text must use ARB, even in prototypes
- Test ARB key existence and translation completeness
