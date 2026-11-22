import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/app_keys.dart';
import '../../../core/backend/backend_config.dart';
import '../../../core/widgets/instruction_banner.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/auth_repository.dart';
import '../data/phone_number.dart';
import 'auth_messages.dart';
import 'name_screen.dart';

/// Sign in with the phone number: step 1 the number, step 2 the SMS code.
/// No passwords (PRD RF-01).
class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  static const _resendSeconds = 60;

  final _prefix = TextEditingController(text: '+34');
  final _number = TextEditingController();
  final _code = TextEditingController();

  /// Normalized number once the code was sent; null while on step 1.
  String? _phone;
  String? _error;
  bool _busy = false;
  int _resendIn = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _prefix.dispose();
    _number.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final l10n = AppLocalizations.of(context);
    final phone = normalizePhone(prefix: _prefix.text, number: _number.text);
    if (phone == null) {
      setState(() => _error = l10n.phoneInvalid);
      return;
    }
    await _run(() => ref.read(authRepositoryProvider).sendCode(phone), onDone: () {
      _phone = phone;
      _code.clear();
      _startResendTimer();
    });
  }

  Future<void> _verify() async {
    final phone = _phone!;
    final code = _code.text.trim();
    if (code.length != 6) return;
    final repo = ref.read(authRepositoryProvider);
    final navigator = Navigator.of(context);
    final l10n = AppLocalizations.of(context);
    await _run(() => repo.verifyCode(phone: phone, code: code), onDone: () {
      final name = repo.displayName;
      if (name == null) {
        // First time: ask for the name shown to the group.
        navigator.pushReplacement(MaterialPageRoute<void>(builder: (_) => const NameScreen()));
      } else {
        navigator.pop();
        showAppMessage(l10n.signedInAs(name));
      }
    });
  }

  /// Runs a network step with a spinner and a clear error message.
  Future<void> _run(Future<void> Function() action, {required VoidCallback onDone}) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (!mounted) return;
      setState(onDone);
    } on AuthFailureException catch (e) {
      if (mounted) setState(() => _error = l10n.authFailure(e.reason));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _startResendTimer() {
    _timer?.cancel();
    _resendIn = _resendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _resendIn--);
      if (_resendIn <= 0) timer.cancel();
    });
  }

  void _changeNumber() {
    _timer?.cancel();
    setState(() {
      _phone = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onCodeStep = _phone != null;

    return Scaffold(
      appBar: AppBar(title: Text(onCodeStep ? l10n.codeTitle : l10n.phoneTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          if (BackendConfig.showTestLoginHint) ...[
            InstructionBanner(text: l10n.testLoginHint),
            const SizedBox(height: 16),
          ],
          if (!onCodeStep) ..._phoneStep(l10n) else ..._codeStep(l10n),
          if (_busy) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  /// Error right below the field the user is typing in, so the keyboard
  /// never hides it.
  List<Widget> _errorText() => [
        if (_error != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ];

  List<Widget> _phoneStep(AppLocalizations l10n) => [
        Text(l10n.phoneExplanation),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: TextField(
                controller: _prefix,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+0-9]'))],
                decoration: InputDecoration(labelText: l10n.countryCode),
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _number,
                autofocus: true,
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.telephoneNumberNational],
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]'))],
                decoration: InputDecoration(labelText: l10n.phoneNumber),
                style: const TextStyle(fontSize: 22, letterSpacing: 1),
                onSubmitted: (_) => _sendCode(),
              ),
            ),
          ],
        ),
        ..._errorText(),
        const SizedBox(height: 24),
        LargeButton(icon: Icons.sms, label: l10n.sendCode, onPressed: _busy ? null : _sendCode),
      ];

  List<Widget> _codeStep(AppLocalizations l10n) => [
        Text(l10n.codeSentTo(formatPhone(_phone!))),
        const SizedBox(height: 24),
        TextField(
          controller: _code,
          autofocus: true,
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 32, letterSpacing: 12, fontWeight: FontWeight.w700),
          decoration: InputDecoration(labelText: l10n.code, counterText: ''),
          onChanged: (value) {
            setState(() => _error = null);
            if (value.length == 6) _verify(); // Sign in as soon as it's complete.
          },
        ),
        ..._errorText(),
        const SizedBox(height: 24),
        LargeButton(
          icon: Icons.login,
          label: l10n.signIn,
          onPressed: _busy || _code.text.length != 6 ? null : _verify,
        ),
        const SizedBox(height: 12),
        LargeButton(
          icon: Icons.refresh,
          label: _resendIn > 0 ? l10n.resendIn(_resendIn) : l10n.resendCode,
          primary: false,
          onPressed: _busy || _resendIn > 0 ? null : _sendCode,
        ),
        const SizedBox(height: 12),
        LargeButton(
          icon: Icons.edit,
          label: l10n.changeNumber,
          primary: false,
          onPressed: _busy ? null : _changeNumber,
        ),
      ];
}
