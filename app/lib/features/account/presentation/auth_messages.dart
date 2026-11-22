import '../../../l10n/generated/app_localizations.dart';
import '../data/auth_repository.dart';

extension AuthMessages on AppLocalizations {
  String authFailure(AuthFailure reason) => switch (reason) {
        AuthFailure.invalidCode => codeInvalid,
        AuthFailure.noConnection => noConnection,
        AuthFailure.tooManyAttempts => tooManyAttempts,
        AuthFailure.unknown => authError,
      };
}
