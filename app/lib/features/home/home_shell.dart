import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/app_keys.dart';
import '../../core/map/offline_maps.dart';
import '../../l10n/generated/app_localizations.dart';
import '../groups/groups_tab.dart';
import '../hunt/hunt_tab.dart';
import '../map/map_tab.dart';
import '../zones/data/zones_repository.dart';
import '../zones/presentation/offline_maps_screen.dart';
import '../zones/zones_tab.dart';

/// Four fixed tabs, always visible, no hidden menus (PRD RNF-03).
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  // IndexedStack keeps every tab alive, so the map is not reloaded.
  static const _tabs = [MapTab(), ZonesTab(), GroupsTab(), HuntTab()];

  /// Tells the user when a map download ends, even on another screen.
  void _onOfflineMapsChanged(
    Map<String, OfflineMapState>? previous,
    Map<String, OfflineMapState> next,
  ) {
    final l10n = AppLocalizations.of(context);
    final zones = ref.read(zonesProvider).value ?? const [];
    for (final entry in next.entries) {
      if (previous?[entry.key] is! OfflineMapDownloading) continue;
      final name = zones.where((z) => z.id == entry.key).firstOrNull?.name ?? '';
      switch (entry.value) {
        case OfflineMapReady():
          showAppMessage(
            l10n.mapReadyNotice(name),
            actionLabel: l10n.view,
            onAction: () => openScreen(const OfflineMapsScreen()),
          );
        case OfflineMapFailed():
          showAppMessage(l10n.mapFailedNotice(name));
        case OfflineMapDownloading():
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen(offlineMapsProvider, _onOfflineMapsChanged);

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
