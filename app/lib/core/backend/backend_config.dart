/// Supabase settings, passed at build time:
///   flutter run --dart-define-from-file=config/dev.env
/// (see config/dev.env.example). Without them the app still works,
/// offline-only and without accounts.
abstract final class BackendConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');

  /// Publishable (anon) key: safe inside the app; RLS protects the data.
  static const publishableKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  /// Dev only: shows the test phone number and code on the login screen.
  static const showTestLoginHint = bool.fromEnvironment('SHOW_TEST_LOGIN_HINT');

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}
