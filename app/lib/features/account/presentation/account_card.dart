import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/info_row.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/auth_repository.dart';
import '../data/phone_number.dart';
import 'name_screen.dart';
import 'phone_login_screen.dart';

/// "Your account": sign in, or see who you are and sign out.
class AccountCard extends ConsumerWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final repo = ref.watch(authRepositoryProvider);
    final session = ref.watch(sessionProvider).value ?? repo.session;

    void push(Widget screen) =>
        Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));

    final List<Widget> content;
    if (!repo.isAvailable) {
      content = [Text(l10n.accountsUnavailable)];
    } else if (session == null) {
      content = [
        Text(l10n.noAccountTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(l10n.noAccountMessage),
        const SizedBox(height: 16),
        LargeButton(
          icon: Icons.phone_android,
          label: l10n.signInWithPhone,
          onPressed: () => push(const PhoneLoginScreen()),
        ),
      ];
    } else {
      final phone = repo.phone;
      content = [
        InfoRow(icon: Icons.person, label: l10n.nameLabel, value: repo.displayName ?? l10n.noName),
        if (phone != null)
          InfoRow(icon: Icons.phone, label: l10n.phoneLabel, value: formatPhone(phone)),
        const SizedBox(height: 12),
        LargeButton(
          icon: Icons.edit,
          label: l10n.changeName,
          primary: false,
          onPressed: () => push(const NameScreen()),
        ),
        const SizedBox(height: 12),
        LargeButton(
          icon: Icons.logout,
          label: l10n.signOut,
          primary: false,
          onPressed: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: l10n.signOutQuestion,
              message: l10n.signOutMessage,
            );
            if (confirmed) await repo.signOut();
          },
        ),
      ];
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, size: 36, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(l10n.account, style: theme.textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            ...content,
          ],
        ),
      ),
    );
  }
}
