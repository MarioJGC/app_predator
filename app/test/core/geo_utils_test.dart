import 'package:app/core/geo/geo_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  // A square of about 1 km x 1 km near Toledo.
  const sw = LatLng(39.5500, -4.3500);
  const se = LatLng(39.5500, -4.33835);
  const ne = LatLng(39.5590, -4.33835);
  const nw = LatLng(39.5590, -4.3500);
  const square = [sw, se, ne, nw];

  test('encode and decode keep the same coordinates', () {
    final decoded = GeoUtils.decode(GeoUtils.encode(square));
    expect(decoded, square);
  });

  test('distance of 0.009 degrees of latitude is about 1 km', () {
    expect(GeoUtils.distanceMeters(sw, nw), closeTo(1000, 5));
  });

  test('area of a 1 km square is about 100 ha', () {
    final hectares = GeoUtils.areaSquareMeters(square) / 10000;
    expect(hectares, closeTo(100, 1));
  });

  test('length of a route sums every segment', () {
    expect(GeoUtils.lengthMeters([sw, nw, ne]), closeTo(2000, 10));
  });

  test('bounds contain every point', () {
    final b = GeoUtils.bounds(square);
    expect(b.southwest, sw);
    expect(b.northeast, ne);
  });

  test('expand adds the margin on every side', () {
    final b = GeoUtils.expand(GeoUtils.bounds(square), 1000);
    expect(GeoUtils.distanceMeters(b.southwest, LatLng(sw.latitude, b.southwest.longitude)),
        closeTo(1000, 5));
  });
}
