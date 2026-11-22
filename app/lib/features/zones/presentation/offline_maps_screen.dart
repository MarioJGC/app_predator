import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/map/offline_maps.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/info_view.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/zones_repository.dart';
import 'zone_labels.dart';

/// Every downloaded map with its size, to free space (PRD RF-22).
class OfflineMapsScreen extends ConsumerWidget {
  const OfflineMapsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final maps = ref.watch(offlineMapsProvider);
    final zones = ref.watch(zonesProvider).value ?? const [];

    final ready = [
      for (final zone in zones)
        if (maps[zone.id] case OfflineMapReady(:final bytes)) (zone: zone, bytes: bytes),
    ];
    final total = ready.fold<int>(0, (sum, item) => sum + item.bytes);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.offlineMaps)),
      body: ready.isEmpty
          ? InfoView(
              icon: Icons.download_for_offline,
              title: l10n.offlineMapsEmpty,
              message: l10n.offlineMapsHint,
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.offlineMapsTotal(l10n.formatBytes(total)),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                for (final item in ready)
                  ListTile(
                    leading: const Icon(Icons.offline_pin, size: 36),
                    title: Text(item.zone.name),
                    subtitle: Text(l10n.formatBytes(item.bytes)),
                    trailing: IconButton(
                      tooltip: l10n.deleteMap,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final confirmed = await showConfirmDialog(
                          context,
                          title: l10n.deleteMapQuestion(item.zone.name),
                          destructive: true,
                        );
                        if (confirmed) {
                          await ref.read(offlineMapsProvider.notifier).delete(item.zone.id);
                        }
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}
