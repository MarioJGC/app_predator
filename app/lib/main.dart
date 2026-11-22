import 'package:material_ui/material_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// Map style: only the PNOA orthophoto from IGN (satellite imagery).
const pnoaStyle = '''
{
  "version": 8,
  "sources": {
    "pnoa": {
      "type": "raster",
      "tiles": ["https://www.ign.es/wmts/pnoa-ma?request=GetTile&service=WMTS&VERSION=1.0.0&Layer=OI.OrthoimageCoverage&Style=default&Format=image/jpeg&TileMatrixSet=GoogleMapsCompatible&TileMatrix={z}&TileRow={y}&TileCol={x}"],
      "tileSize": 256,
      "attribution": "PNOA cedido por © Instituto Geográfico Nacional de España"
    }
  },
  "layers": [{ "id": "pnoa", "type": "raster", "source": "pnoa" }]
}
''';

void main() => runApp(const MaterialApp(home: MapScreen()));

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Spike only: hardcoded text. Real features use ARB translations.
      appBar: AppBar(title: const Text('Prueba: mapa IGN')),
      body: MapLibreMap(
        styleString: pnoaStyle,
        // Test area: Montes de Toledo.
        initialCameraPosition: const CameraPosition(
          target: LatLng(39.55, -4.35),
          zoom: 14,
        ),
        myLocationEnabled: _hasLocationPermission,
        // Move the camera with the user's position.
        myLocationTrackingMode: _hasLocationPermission
            ? MyLocationTrackingMode.tracking
            : MyLocationTrackingMode.none,
      ),
    );
  }
}
