import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/location/location_service.dart';
import '../../core/widgets/info_view.dart';
import '../../core/widgets/large_button.dart';
import '../../l10n/generated/app_localizations.dart';
import 'data/zones_repository.dart';
import 'domain/zone.dart';
import 'presentation/draw_area_screen.dart';
import 'presentation/record_route_screen.dart';
import 'presentation/zone_detail_screen.dart';
import 'presentation/zone_labels.dart';

/// List of the user's areas and routes.
class ZonesTab extends ConsumerWidget {
  const ZonesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final zones = ref.watch(zonesProvider).value ?? const <Zone>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabZones)),
      body: zones.isEmpty
          ? InfoView(
              icon: Icons.terrain,
              title: l10n.zonesEmpty,
              action: LargeButton(
                icon: Icons.add,
                label: l10n.newZone,
                onPressed: () => showNewZoneSheet(context, ref),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: zones.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final zone = zones[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Icon(zoneKindIcon(zone.kind), size: 36),
                  title: Text(zone.name),
                  subtitle: Text(
                    '${l10n.zoneKind(zone.kind)} · ${l10n.zoneSize(zone)}',
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 32),
                  onTap: () => openZone(context, zone.id),
                );
              },
            ),
      floatingActionButton: zones.isEmpty
          ? null
          : FloatingActionButton.extended(
              heroTag: 'newZone',
              onPressed: () => showNewZoneSheet(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.newZone),
            ),
    );
  }
}

void openZone(BuildContext context, String zoneId) {
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => ZoneDetailScreen(zoneId: zoneId),
  ));
}

/// Asks "area or route?" and opens the matching screen.
Future<void> showNewZoneSheet(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final navigator = Navigator.of(context);

  final kind = await showModalBottomSheet<ZoneKind>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.newZoneQuestion, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            LargeButton(
              icon: Icons.crop_square,
              label: l10n.drawArea,
              onPressed: () => Navigator.of(context).pop(ZoneKind.area),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              child: Text(l10n.drawAreaHint, textAlign: TextAlign.center),
            ),
            LargeButton(
              icon: Icons.timeline,
              label: l10n.recordRoute,
              primary: false,
              onPressed: () => Navigator.of(context).pop(ZoneKind.route),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(l10n.recordRouteHint, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    ),
  );
  if (kind == null) return;

  final camera = await _startCamera(ref);
  navigator.push(MaterialPageRoute<void>(
    builder: (_) => kind == ZoneKind.area
        ? DrawAreaScreen(initialCamera: camera)
        : RecordRouteScreen(initialCamera: camera),
  ));
}

/// Starts where the user is, or shows the whole of Spain.
Future<CameraPosition> _startCamera(WidgetRef ref) async {
  final position = await ref.read(locationServiceProvider).lastKnownPosition();
  if (position == null) {
    return const CameraPosition(target: LatLng(40.0, -3.7), zoom: 5.5);
  }
  return CameraPosition(
    target: LatLng(position.latitude, position.longitude),
    zoom: 15,
  );
}
