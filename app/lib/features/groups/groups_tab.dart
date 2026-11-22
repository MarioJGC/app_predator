import 'package:material_ui/material_ui.dart';

import '../../core/widgets/info_view.dart';
import '../../l10n/generated/app_localizations.dart';
import '../account/presentation/account_card.dart';

/// Account (sign in / sign out) and, soon, hunting groups.
class GroupsTab extends StatelessWidget {
  const GroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabGroups)),
      body: ListView(
        children: [
          const AccountCard(),
          SizedBox(
            height: 320,
            child: InfoView(
              icon: Icons.groups,
              title: l10n.comingSoon,
              message: l10n.groupsComingSoon,
            ),
          ),
        ],
      ),
    );
  }
}
