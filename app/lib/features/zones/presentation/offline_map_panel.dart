import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/map/offline_maps.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/zone.dart';
import 'zone_labels.dart';

/// Download state of a zone's map, with the matching action (PRD RF-20).
class OfflineMapPanel extends ConsumerWidget {
  const OfflineMapPanel({super.key, required this.zone});

  final Zone zone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final state = ref.watch(offlineMapsProvider)[zone.id];
    final notifier = ref.read(offlineMapsProvider.notifier);

    void download() => notifier.download(
          zoneId: zone.id,
          zoneName: zone.name,
          zoneBounds: zone.bounds,
        );

    return switch (state) {
      null => Column(
          children: [
            LargeButton(
              icon: Icons.download,
              label: l10n.downloadMap(
                '≈ ${l10n.formatBytes(estimatedDownloadBytes(zone.bounds))}',
              ),
              onPressed: download,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(l10n.downloadMapHint, textAlign: TextAlign.center),
            ),
          ],
        ),
      OfflineMapDownloading(:final progress) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.downloadingMap((progress * 100).round())),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress, minHeight: 12),
          ],
        ),
      OfflineMapReady(:final bytes) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.offline_pin, color: scheme.primary, size: 32),
                const SizedBox(width: 12),
                Expanded(child: Text(l10n.mapDownloaded(l10n.formatBytes(bytes)))),
              ],
            ),
            const SizedBox(height: 8),
            LargeButton(
              icon: Icons.delete_outline,
              label: l10n.deleteMap,
              primary: false,
              destructive: true,
              onPressed: () async {
                final confirmed = await showConfirmDialog(
                  context,
                  title: l10n.deleteMapQuestion(zone.name),
                  destructive: true,
                );
                if (confirmed) await notifier.delete(zone.id);
              },
            ),
          ],
        ),
      OfflineMapFailed() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.mapDownloadFailed, style: TextStyle(color: scheme.error)),
            const SizedBox(height: 8),
            LargeButton(icon: Icons.refresh, label: l10n.retry, onPressed: download),
          ],
        ),
    };
  }
}
