import '../../l10n/app_localizations.dart';
import 'failure.dart';

/// Maps [AppFailure] to a user-facing localized message.
extension FailureMessage on AppFailure {
  String toLocalizedMessage(AppLocalizations l10n) => switch (this) {
        UnknownFailure() => l10n.common_error_unknown,
      };
}
