import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/app_keys.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/auth_repository.dart';
import 'auth_messages.dart';

/// "What's your name?": shown after the first login, or to change it.
class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  late final _name = TextEditingController(
    text: ref.read(authRepositoryProvider).displayName,
  );
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.nameRequired);
      return;
    }
    final navigator = Navigator.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).saveName(name);
      navigator.pop();
      showAppMessage(l10n.signedInAs(name));
    } on AuthFailureException catch (e) {
      if (mounted) setState(() => _error = l10n.authFailure(e.reason));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.nameTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          Text(l10n.nameExplanation),
          const SizedBox(height: 24),
          TextField(
            controller: _name,
            autofocus: true,
            maxLength: 60,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            style: const TextStyle(fontSize: 22),
            decoration: InputDecoration(labelText: l10n.yourName, errorText: _error),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          LargeButton(icon: Icons.save, label: l10n.save, onPressed: _busy ? null : _save),
          if (_busy) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
