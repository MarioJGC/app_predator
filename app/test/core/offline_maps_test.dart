import 'package:app/core/geo/geo_utils.dart';
import 'package:app/core/map/offline_maps.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  test('one tile at zoom 0 covers the whole world', () {
    final world = LatLngBounds(
      southwest: const LatLng(-80, -179),
      northeast: const LatLng(80, 179),
    );
    expect(tileCount(world, 0, 0), 1);
  });

  test('tile count grows about 4 times per zoom level', () {
    final area = GeoUtils.expand(
      LatLngBounds(
        southwest: const LatLng(39.55, -4.35),
        northeast: const LatLng(39.56, -4.34),
      ),
      1000,
    );
    final z15 = tileCount(area, 15, 15);
    final z16 = tileCount(area, 16, 16);
    expect(z16 / z15, closeTo(4, 1.5));
  });

  test('a 1 km area downloads a few MB, not hundreds', () {
    final bounds = LatLngBounds(
      southwest: const LatLng(39.55, -4.35),
      northeast: const LatLng(39.559, -4.338),
    );
    final mb = estimatedDownloadBytes(bounds) / (1024 * 1024);
    expect(mb, inInclusiveRange(1, 30));
  });
}
