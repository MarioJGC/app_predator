import 'package:material_ui/material_ui.dart';

import '../../core/widgets/info_view.dart';
import '../../l10n/generated/app_localizations.dart';

/// Live hunt day. Needs the backend (user accounts, realtime).
class HuntTab extends StatelessWidget {
  const HuntTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabHunt)),
      body: InfoView(
        icon: Icons.flag,
        title: l10n.comingSoon,
        message: l10n.huntComingSoon,
      ),
    );
  }
}
