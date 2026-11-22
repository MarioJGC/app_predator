import 'package:material_ui/material_ui.dart';

import '../../l10n/generated/app_localizations.dart';
import '../groups/groups_tab.dart';
import '../hunt/hunt_tab.dart';
import '../map/map_tab.dart';
import '../zones/zones_tab.dart';

/// Four fixed tabs, always visible, no hidden menus (PRD RNF-03).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  // IndexedStack keeps every tab alive, so the map is not reloaded.
  static const _tabs = [MapTab(), ZonesTab(), GroupsTab(), HuntTab()];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: l10n.tabMap,
          ),
          NavigationDestination(
            icon: const Icon(Icons.terrain_outlined),
            selectedIcon: const Icon(Icons.terrain),
            label: l10n.tabZones,
          ),
          NavigationDestination(
            icon: const Icon(Icons.groups_outlined),
            selectedIcon: const Icon(Icons.groups),
            label: l10n.tabGroups,
          ),
          NavigationDestination(
            icon: const Icon(Icons.flag_outlined),
            selectedIcon: const Icon(Icons.flag),
            label: l10n.tabHunt,
          ),
        ],
      ),
    );
  }
}
