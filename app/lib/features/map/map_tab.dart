import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/location/location_service.dart';
import '../../core/map/map_layers.dart';
import '../../l10n/generated/app_localizations.dart';

/// Default camera: centre of the Iberian Peninsula.
const _spainCamera = CameraPosition(target: LatLng(40.0, -3.7), zoom: 5.5);

/// Main map: base layer switch and "my location".
class MapTab extends ConsumerStatefulWidget {
  const MapTab({super.key});

  @override
  ConsumerState<MapTab> createState() => _MapTabState();
}

class _MapTabState extends ConsumerState<MapTab> {
  MapLibreMapController? _controller;
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final granted = await ref.read(locationServiceProvider).ensurePermission();
    if (!mounted) return;
    setState(() => _hasLocationPermission = granted);
  }

  Future<void> _goToMyLocation() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final service = ref.read(locationServiceProvider);
    final result = await service.currentPosition();
    if (!mounted) return;

    switch (result) {
      case LocationFound(:final position):
        setState(() => _hasLocationPermission = true);
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
    final nextLayerName = layer == MapLayer.orthophoto
        ? l10n.layerTopographic
        : l10n.layerOrthophoto;

    return Scaffold(
      body: MapLibreMap(
        styleString: layer.styleAsset,
        initialCameraPosition: _spainCamera,
        onMapCreated: (controller) => _controller = controller,
        myLocationEnabled: _hasLocationPermission,
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
