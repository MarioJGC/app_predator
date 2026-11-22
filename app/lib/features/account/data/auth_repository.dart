import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/backend/backend_config.dart';

/// Why a login step failed, so the UI can show a clear message.
enum AuthFailure { invalidCode, noConnection, tooManyAttempts, unknown }

class AuthFailureException implements Exception {
  const AuthFailureException(this.reason);
  final AuthFailure reason;
}

/// Phone login (one-time code by SMS) and the user's profile.
/// The session is stored on the phone and kept open (PRD RF-03).
class AuthRepository {
  AuthRepository(this._client);

  /// Null when the app was built without backend settings.
  final SupabaseClient? _client;

  bool get isAvailable => _client != null;

  Session? get session => _client?.auth.currentSession;

  /// Emits the current session right away, then every change.
  Stream<Session?> watchSession() {
    final client = _client;
    if (client == null) return Stream.value(null);
    return client.auth.onAuthStateChange.map((state) => state.session);
  }

  /// Saved in the user's metadata too, so it is available offline.
  String? get displayName {
    final name = session?.user.userMetadata?['display_name'];
    return name is String && name.trim().isNotEmpty ? name : null;
  }

  String? get phone {
    final phone = session?.user.phone;
    return phone == null || phone.isEmpty ? null : '+${phone.replaceAll('+', '')}';
  }

  Future<void> sendCode(String phone) => _guard(
        () => _client!.auth.signInWithOtp(phone: phone, shouldCreateUser: true),
      );

  Future<void> verifyCode({required String phone, required String code}) => _guard(
        () => _client!.auth.verifyOTP(type: OtpType.sms, phone: phone, token: code),
      );

  /// Name shown to other hunters in the group.
  Future<void> saveName(String name) => _guard(() async {
        final client = _client!;
        final trimmed = name.trim();
        await client
            .from('profiles')
            .update({'display_name': trimmed}).eq('id', client.auth.currentUser!.id);
        return client.auth.updateUser(UserAttributes(data: {'display_name': trimmed}));
      });

  Future<void> signOut() async => _client?.auth.signOut();

  /// Turns network and auth errors into an [AuthFailure].
  Future<void> _guard(Future<Object?> Function() action) async {
    try {
      await action();
    } on AuthRetryableFetchException {
      throw const AuthFailureException(AuthFailure.noConnection);
    } on SocketException {
      throw const AuthFailureException(AuthFailure.noConnection);
    } on TimeoutException {
      throw const AuthFailureException(AuthFailure.noConnection);
    } on AuthException catch (e) {
      final code = e.code ?? '';
      if (e.statusCode == '429' || code.contains('rate_limit')) {
        throw const AuthFailureException(AuthFailure.tooManyAttempts);
      }
      if (code == 'otp_expired' || code.contains('otp') || e.statusCode == '403') {
        throw const AuthFailureException(AuthFailure.invalidCode);
      }
      throw const AuthFailureException(AuthFailure.unknown);
    } on PostgrestException {
      throw const AuthFailureException(AuthFailure.unknown);
    }
  }
}

// ---------- Providers ----------

final supabaseClientProvider = Provider<SupabaseClient?>(
  (ref) => BackendConfig.isConfigured ? Supabase.instance.client : null,
);

final authRepositoryProvider =
    Provider((ref) => AuthRepository(ref.watch(supabaseClientProvider)));

/// Current session (null = not signed in). Rebuilds the UI on login/logout.
final sessionProvider = StreamProvider<Session?>(
  (ref) => ref.watch(authRepositoryProvider).watchSession(),
);
