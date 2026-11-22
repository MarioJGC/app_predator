import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/location/location_service.dart';
import '../../../core/map/map_layers.dart';
import '../../../core/map/offline_maps.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/info_row.dart';
import '../../../core/widgets/info_view.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/zones_repository.dart';
import '../domain/zone.dart';
import '../domain/zone_features.dart';
import 'add_point_screen.dart';
import 'offline_map_panel.dart';
import 'draw_area_screen.dart';
import 'zone_features_screen.dart';
import 'zone_form_screen.dart';
import 'zone_labels.dart';
import 'zone_map_layer.dart';

/// One zone: map, details, points and actions.
class ZoneDetailScreen extends ConsumerWidget {
  const ZoneDetailScreen({super.key, required this.zoneId});

  final String zoneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final zone = ref.watch(zoneProvider(zoneId)).value;
    final points = ref.watch(zonePointsProvider(zoneId)).value ?? const [];
    final subzones = ref.watch(childZonesProvider(zoneId)).value ?? const <Zone>[];
    final allZones = ref.watch(zonesProvider).value ?? const <Zone>[];

    if (zone == null) {
      return Scaffold(
        appBar: AppBar(),
        body: InfoView(icon: Icons.search_off, title: l10n.zoneNotFound),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(zone.name)),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.35,
            child: _ZoneMap(zone: zone, subzones: subzones, points: points),
          ),
          Expanded(
            // SafeArea: keep the last buttons above Android's navigation bar.
            child: SafeArea(
              top: false,
              child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Breadcrumb(zone: zone, allZones: allZones),
                _ZoneSummary(zone: zone),
                const SizedBox(height: 16),
                // Subzones are inside their zone's download.
                if (!zone.isSubzone) ...[
                  OfflineMapPanel(zone: zone),
                  const SizedBox(height: 16),
                ],
                _FeaturesSection(zone: zone),
                const SizedBox(height: 24),
                if (zone.kind == ZoneKind.area) ...[
                  _SubzonesSection(zone: zone, subzones: subzones),
                  const SizedBox(height: 24),
                ],
                LargeButton(
                  icon: Icons.add_location_alt,
                  label: l10n.addPoint,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => AddPointScreen(zone: zone),
                  )),
                ),
                const SizedBox(height: 12),
                LargeButton(
                  icon: Icons.directions_car,
                  label: l10n.directions,
                  primary: false,
                  onPressed: () => _openDirections(context, zone, points),
                ),
                if (zone.kind == ZoneKind.route && zone.geometry.length >= 3) ...[
                  const SizedBox(height: 12),
                  LargeButton(
                    icon: Icons.crop_square,
                    label: l10n.closeAsArea,
                    primary: false,
                    onPressed: () async {
                      final confirmed = await showConfirmDialog(
                        context,
                        title: l10n.convertToAreaQuestion(zone.name),
                        message: l10n.convertToAreaMessage,
                      );
                      if (confirmed) {
                        await ref.read(zonesRepositoryProvider).convertRouteToArea(zone.id);
                      }
                    },
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  l10n.pointsTitle(points.length),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (points.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(l10n.noPoints),
                  ),
                for (final point in points) _PointTile(point: point),
                const SizedBox(height: 24),
                LargeButton(
                  icon: Icons.edit,
                  label: l10n.editZone,
                  primary: false,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => ZoneFormScreen.edit(existing: zone),
                  )),
                ),
                const SizedBox(height: 12),
                LargeButton(
                  icon: Icons.delete_outline,
                  label: l10n.deleteZone,
                  primary: false,
                  destructive: true,
                  onPressed: () => _delete(context, ref, zone),
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }

  /// Opens Google Maps / Waze with driving directions (PRD RF-15).
  /// Goes to the parking point if there is one, otherwise to the centre.
  Future<void> _openDirections(
    BuildContext context,
    Zone zone,
    List<ZonePoint> points,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).directionsError;
    final parking = points.where((p) => p.kind == PointKind.parking);
    final target = parking.isNotEmpty ? parking.first.position : zone.center;
    final uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${target.latitude},${target.longitude}',
      'travelmode': 'driving',
    });
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) messenger.showSnackBar(SnackBar(content: Text(error)));
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Zone zone) async {
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.deleteZoneQuestion(zone.name),
      message: l10n.deleteZoneMessage,
      destructive: true,
    );
    if (!confirmed) return;
    if (!zone.isSubzone) await ref.read(offlineMapsProvider.notifier).delete(zone.id);
    await ref.read(zonesRepositoryProvider).deleteZone(zone.id);
    navigator.pop();
  }
}

class _ZoneSummary extends StatelessWidget {
  const _ZoneSummary({required this.zone});

  final Zone zone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow(
          icon: zoneKindIcon(zone.kind),
          label: l10n.labelType,
          value: l10n.zoneKind(zone.kind),
        ),
        InfoRow(
          icon: Icons.straighten,
          label: l10n.labelSize,
          value: l10n.zoneSize(zone),
        ),
        if (zone.modality != null)
          InfoRow(
            icon: Icons.flag,
            label: l10n.modality,
            value: l10n.modalityName(zone.modality!),
          ),
        if (zone.species.isNotEmpty)
          InfoRow(
            icon: Icons.pets,
            label: l10n.species,
            value: zone.species.map(l10n.speciesName).join(', '),
          ),
        if (zone.description != null)
          InfoRow(
            icon: Icons.notes,
            label: l10n.labelDescription,
            value: zone.description!,
          ),
      ],
    );
  }
}

class _PointTile extends ConsumerWidget {
  const _PointTile({required this.point});

  final ZonePoint point;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kind = l10n.pointKind(point.kind);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: ZoneColors.pointColor(point.kind),
        foregroundColor: point.kind == PointKind.danger ? Colors.black : Colors.white,
        child: Icon(pointKindIcon(point.kind)),
      ),
      title: Text(point.name == null ? kind : '$kind ${point.name}'),
      trailing: IconButton(
        tooltip: l10n.deletePointQuestion,
        icon: const Icon(Icons.delete_outline),
        onPressed: () async {
          final confirmed = await showConfirmDialog(
            context,
            title: l10n.deletePointQuestion,
            destructive: true,
          );
          if (confirmed) {
            await ref.read(zonesRepositoryProvider).deletePoint(point.id);
          }
        },
      ),
    );
  }
}

/// Small map centred on the zone, redrawn when its data changes.
class _ZoneMap extends ConsumerStatefulWidget {
  const _ZoneMap({required this.zone, required this.subzones, required this.points});

  final Zone zone;
  final List<Zone> subzones;
  final List<ZonePoint> points;

  @override
  ConsumerState<_ZoneMap> createState() => _ZoneMapState();
}

class _ZoneMapState extends ConsumerState<_ZoneMap> {
  MapLibreMapController? _controller;
  bool _styleLoaded = false;

  Future<void> _onStyleLoaded() async {
    _styleLoaded = true;
    final controller = _controller!;
    await fitZone(controller, widget.zone);
    await _draw();
  }

  Future<void> _draw() async {
    if (!_styleLoaded) return;
    await drawZones(
      _controller!,
      zones: [widget.zone, ...widget.subzones],
      points: widget.points,
    );
  }

  @override
  void didUpdateWidget(covariant _ZoneMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _draw();
  }

  @override
  Widget build(BuildContext context) {
    final layer = ref.watch(mapLayerProvider);
    final hasLocation = ref.watch(locationPermissionProvider).value ?? false;
    return MapLibreMap(
      styleString: layer.styleAsset,
      initialCameraPosition: CameraPosition(target: widget.zone.center, zoom: 14),
      onMapCreated: (c) => _controller = c,
      onStyleLoadedCallback: _onStyleLoaded,
      myLocationEnabled: hasLocation,
    );
  }
}

/// "Inside: Coto › Umbría" for subzones, so the user knows where they are.
class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.zone, required this.allZones});

  final Zone zone;
  final List<Zone> allZones;

  @override
  Widget build(BuildContext context) {
    final byId = {for (final z in allZones) z.id: z};
    final path = <Zone>[];
    var parentId = zone.parentId;
    while (parentId != null && byId[parentId] != null && path.length < 50) {
      path.insert(0, byId[parentId]!);
      parentId = byId[parentId]!.parentId;
    }
    if (path.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('${l10n.insideOf}: ', style: const TextStyle(fontWeight: FontWeight.w700)),
          for (final (i, ancestor) in path.indexed) ...[
            if (i > 0) const Icon(Icons.chevron_right),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => ZoneDetailScreen(zoneId: ancestor.id),
              )),
              child: Text(ancestor.name, style: TextStyle(color: theme.colorScheme.primary)),
            ),
          ],
        ],
      ),
    );
  }
}

/// Animals, food & water, danger, bedding & paths of the zone.
class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection({required this.zone});

  final Zone zone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final f = zone.features;
    String join(Iterable<String> keys, String Function(String) name) =>
        keys.map(name).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.featuresTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (f.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l10n.noFeatures),
          ),
        if (f.animals.isNotEmpty)
          InfoRow(icon: Icons.pets, label: l10n.featAnimals, value: join(f.animals, l10n.speciesName)),
        if (f.foodWater.isNotEmpty)
          InfoRow(
            icon: Icons.water_drop,
            label: l10n.featFoodWater,
            value: join(f.foodWater, l10n.foodWaterName),
          ),
        if (f.dangerLevel != DangerLevel.none)
          InfoRow(
            icon: Icons.warning_amber,
            label: l10n.featDanger,
            value: [
              l10n.dangerLevelName(f.dangerLevel),
              if (f.dangers.isNotEmpty) join(f.dangers, l10n.dangerTypeName),
            ].join(' · '),
          ),
        if (f.wildlifeSigns.isNotEmpty)
          InfoRow(
            icon: Icons.bedtime,
            label: l10n.featSigns,
            value: join(f.wildlifeSigns, l10n.wildlifeSignName),
          ),
        const SizedBox(height: 8),
        LargeButton(
          icon: Icons.checklist,
          label: l10n.editFeatures,
          primary: false,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => ZoneFeaturesScreen(zone: zone),
          )),
        ),
      ],
    );
  }
}

/// Subzones list + "Add subzone".
class _SubzonesSection extends StatelessWidget {
  const _SubzonesSection({required this.zone, required this.subzones});

  final Zone zone;
  final List<Zone> subzones;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.subzonesTitle(subzones.length), style: Theme.of(context).textTheme.titleLarge),
        if (subzones.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l10n.noSubzones),
          ),
        for (final sub in subzones)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: sub.features.dangerLevel == DangerLevel.none
                  ? scheme.primaryContainer
                  : ZoneColors.dangerColor(sub.features.dangerLevel),
              child: Icon(
                sub.features.dangerLevel == DangerLevel.none ? Icons.layers : Icons.warning_amber,
              ),
            ),
            title: Text(sub.name),
            subtitle: Text(l10n.zoneSize(sub)),
            trailing: const Icon(Icons.chevron_right, size: 32),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => ZoneDetailScreen(zoneId: sub.id),
            )),
          ),
        const SizedBox(height: 8),
        LargeButton(
          icon: Icons.add,
          label: l10n.addSubzone,
          primary: false,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => DrawAreaScreen(
              parent: zone,
              initialCamera: CameraPosition(target: zone.center, zoom: 15),
            ),
          )),
        ),
      ],
    );
  }
}
