import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/location/location_service.dart';
import '../../core/map/map_layers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../zones/data/zones_repository.dart';
import '../zones/presentation/zone_map_layer.dart';
import '../zones/zones_tab.dart';

/// Default camera: centre of the Iberian Peninsula.
const _spainCamera = CameraPosition(target: LatLng(40.0, -3.7), zoom: 5.5);

/// Main map: every zone and point, base layer switch and "my location".
class MapTab extends ConsumerStatefulWidget {
  const MapTab({super.key});

  @override
  ConsumerState<MapTab> createState() => _MapTabState();
}

class _MapTabState extends ConsumerState<MapTab> {
  MapLibreMapController? _controller;
  bool _styleLoaded = false;

  void _onMapCreated(MapLibreMapController controller) {
    _controller = controller;
    controller.onFillTapped.add((fill) => _openTapped(fill.data));
    controller.onLineTapped.add((line) => _openTapped(line.data));
    controller.onCircleTapped.add((circle) => _openTapped(circle.data));
  }

  void _openTapped(Map<dynamic, dynamic>? data) {
    final zoneId = data?[zoneIdKey];
    if (zoneId is String) openZone(context, zoneId);
  }

  Future<void> _onStyleLoaded() async {
    _styleLoaded = true;
    await _drawZones();
  }

  Future<void> _drawZones() async {
    final controller = _controller;
    if (controller == null || !_styleLoaded) return;
    await drawZones(
      controller,
      zones: ref.read(zonesProvider).value ?? const [],
      points: ref.read(allPointsProvider).value ?? const [],
    );
  }

  Future<void> _goToMyLocation() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final service = ref.read(locationServiceProvider);
    final result = await service.currentPosition();
    if (!mounted) return;

    switch (result) {
      case LocationFound(:final position):
        ref.invalidate(locationPermissionProvider);
        await _controller?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            15,
          ),
        );
      case LocationDenied():
        messenger.showSnackBar(SnackBar(
          content: Text(l10n.locationDenied),
          action: SnackBarAction(
            label: l10n.openSettings,
            onPressed: service.openSettings,
          ),
        ));
      case LocationUnavailable():
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.locationUnavailable)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layer = ref.watch(mapLayerProvider);
    final hasLocation = ref.watch(locationPermissionProvider).value ?? false;
    final nextLayerName = layer == MapLayer.orthophoto
        ? l10n.layerTopographic
        : l10n.layerOrthophoto;

    // Redraw when zones or points change.
    ref.listen(zonesProvider, (_, _) => _drawZones());
    ref.listen(allPointsProvider, (_, _) => _drawZones());

    return Scaffold(
      body: MapLibreMap(
        styleString: layer.styleAsset,
        initialCameraPosition: _spainCamera,
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoaded,
        myLocationEnabled: hasLocation,
        compassEnabled: true,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'layer',
            tooltip: l10n.changeMap,
            onPressed: ref.read(mapLayerProvider.notifier).toggle,
            icon: const Icon(Icons.layers),
            label: Text(nextLayerName),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'myLocation',
            onPressed: _goToMyLocation,
            icon: const Icon(Icons.my_location),
            label: Text(l10n.myLocation),
          ),
        ],
      ),
    );
  }
}
