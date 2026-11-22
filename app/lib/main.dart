import 'package:material_ui/material_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// Style file bundled with the app (Flutter asset).
const styleAsset = 'assets/map/pnoa_style.json';

/// Same style, served over HTTP. The native offline manager can only
/// download styles from http(s) URLs, not from app assets.
/// Tiles have the same URLs in both styles, so downloaded tiles are reused.
/// Emulator test: `python -m http.server 8765` in assets/map (10.0.2.2 = PC).
/// Real phone: use the raw GitHub URL of this file (see README of the spike).
const styleDownloadUrl = String.fromEnvironment(
  'STYLE_URL',
  defaultValue: 'http://10.0.2.2:8765/pnoa_style.json',
);

/// Zoom levels to download: 12 (whole area) to 16 (paths and trees).
const offlineMinZoom = 12.0;
const offlineMaxZoom = 16.0;

void main() => runApp(const MaterialApp(home: MapScreen()));

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapLibreMapController? _controller;
  bool _hasLocationPermission = false;
  String _status = 'Sin descargas';
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _refreshRegionCount();
  }

  /// Shows the Android dialog "Allow access to location?" if needed.
  Future<void> _requestLocationPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (!mounted) return;
    setState(() {
      _hasLocationPermission = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    });
  }

  Future<void> _refreshRegionCount() async {
    final regions = await getListOfRegions();
    if (!mounted) return;
    setState(() => _status = 'Zonas descargadas: ${regions.length}');
  }

  /// Downloads the area that is visible on the screen.
  Future<void> _downloadVisibleArea() async {
    final controller = _controller;
    if (controller == null || _isDownloading) return;
    final bounds = await controller.getVisibleRegion();

    setState(() {
      _isDownloading = true;
      _status = 'Descargando… 0 %';
    });

    await downloadOfflineRegion(
      OfflineRegionDefinition(
        bounds: bounds,
        mapStyleUrl: styleDownloadUrl,
        minZoom: offlineMinZoom,
        maxZoom: offlineMaxZoom,
      ),
      metadata: {'name': 'Spike ${DateTime.now().toIso8601String()}'},
      onEvent: (event) {
        if (!mounted) return;
        setState(() {
          if (event is InProgress) {
            final mb = event.completedResourceSize / (1024 * 1024);
            _status = 'Descargando… ${event.progress.toStringAsFixed(0)} % '
                '(${mb.toStringAsFixed(1)} MB)';
          } else if (event is Success) {
            _isDownloading = false;
            _status = 'Descarga terminada';
          } else if (event is Error) {
            _isDownloading = false;
            _status = 'Error: ${event.cause.code}';
          }
        });
        if (event is Success) _refreshRegionCount();
      },
    );
  }

  /// Deletes every downloaded area and the browsing cache (to test offline).
  Future<void> _deleteAll() async {
    for (final region in await getListOfRegions()) {
      await deleteOfflineRegion(region.id);
    }
    await clearAmbientCache();
    await _refreshRegionCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Spike only: hardcoded text. Real features use ARB translations.
      appBar: AppBar(
        title: const Text('Prueba: mapa IGN'),
        actions: [
          IconButton(
            tooltip: 'Borrar descargas',
            icon: const Icon(Icons.delete_outline),
            onPressed: _isDownloading ? null : _deleteAll,
          ),
        ],
      ),
      body: Stack(
        children: [
          MapLibreMap(
            styleString: styleAsset,
            // Test area: Montes de Toledo.
            initialCameraPosition: const CameraPosition(
              target: LatLng(39.55, -4.35),
              zoom: 14,
            ),
            onMapCreated: (controller) => _controller = controller,
            myLocationEnabled: _hasLocationPermission,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_status, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: _isDownloading ? null : _downloadVisibleArea,
                        icon: const Icon(Icons.download),
                        label: const Text('Descargar esta zona',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
