import 'package:material_ui/material_ui.dart';

import '../../core/widgets/info_view.dart';
import '../../l10n/generated/app_localizations.dart';

/// List of the user's areas. Filled in feature/zonas.
class ZonesTab extends StatelessWidget {
  const ZonesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabZones)),
      body: InfoView(icon: Icons.terrain, title: l10n.zonesEmpty),
    );
  }
}
