import 'dart:convert';
import 'dart:math' as math;

import 'package:maplibre_gl/maplibre_gl.dart';

/// Small geometry helpers. Accurate enough for hunting areas
/// (a few km wide); not meant for country-sized shapes.
abstract final class GeoUtils {
  static const double earthRadiusMeters = 6371000;

  /// Coordinates to JSON: [[lng, lat], ...] (GeoJSON order).
  static String encode(List<LatLng> points) =>
      jsonEncode([for (final p in points) [p.longitude, p.latitude]]);

  static List<LatLng> decode(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return [
      for (final pair in list)
        LatLng(
          (pair[1] as num).toDouble(),
          (pair[0] as num).toDouble(),
        ),
    ];
  }

  /// Smallest rectangle that contains every point.
  static LatLngBounds bounds(List<LatLng> points) {
    assert(points.isNotEmpty);
    var minLat = points.first.latitude, maxLat = minLat;
    var minLng = points.first.longitude, maxLng = minLng;
    for (final p in points) {
      minLat = math.min(minLat, p.latitude);
      maxLat = math.max(maxLat, p.latitude);
      minLng = math.min(minLng, p.longitude);
      maxLng = math.max(maxLng, p.longitude);
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Grows [b] by [meters] on every side.
  static LatLngBounds expand(LatLngBounds b, double meters) {
    final dLat = _radToDeg(meters / earthRadiusMeters);
    final midLat = (b.southwest.latitude + b.northeast.latitude) / 2;
    final dLng = dLat / math.cos(_degToRad(midLat));
    return LatLngBounds(
      southwest: LatLng(b.southwest.latitude - dLat, b.southwest.longitude - dLng),
      northeast: LatLng(b.northeast.latitude + dLat, b.northeast.longitude + dLng),
    );
  }

  /// Average of the points. Good enough as a "centre" for small areas.
  static LatLng centroid(List<LatLng> points) {
    assert(points.isNotEmpty);
    var lat = 0.0, lng = 0.0;
    for (final p in points) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }

  /// Great-circle distance between two points (haversine).
  static double distanceMeters(LatLng a, LatLng b) {
    final dLat = _degToRad(b.latitude - a.latitude);
    final dLng = _degToRad(b.longitude - a.longitude);
    final h = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_degToRad(a.latitude)) *
            math.cos(_degToRad(b.latitude)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * earthRadiusMeters * math.asin(math.sqrt(h));
  }

  /// Total length of a line.
  static double lengthMeters(List<LatLng> line) {
    var total = 0.0;
    for (var i = 1; i < line.length; i++) {
      total += distanceMeters(line[i - 1], line[i]);
    }
    return total;
  }

  /// Area of a polygon (shoelace formula on a local flat projection).
  static double areaSquareMeters(List<LatLng> polygon) {
    if (polygon.length < 3) return 0;
    final origin = centroid(polygon);
    final cosLat = math.cos(_degToRad(origin.latitude));
    final xy = [
      for (final p in polygon)
        (
          x: _degToRad(p.longitude - origin.longitude) * earthRadiusMeters * cosLat,
          y: _degToRad(p.latitude - origin.latitude) * earthRadiusMeters,
        ),
    ];
    var sum = 0.0;
    for (var i = 0; i < xy.length; i++) {
      final a = xy[i];
      final b = xy[(i + 1) % xy.length];
      sum += a.x * b.y - b.x * a.y;
    }
    return sum.abs() / 2;
  }

  /// True if adding [next] to the polygon [corners] would make two of its
  /// sides cross (a "bow tie" shape). Checks the new side (last → next) and
  /// the closing side (next → first) against the sides they don't touch.
  static bool wouldCross(List<LatLng> corners, LatLng next) {
    final n = corners.length;
    if (n < 3) return false;
    final last = corners[n - 1];
    final first = corners[0];
    for (var i = 0; i < n - 1; i++) {
      final a = corners[i];
      final b = corners[i + 1];
      // New side last → next: skip the side that ends at `last`.
      if (i < n - 2 && _segmentsCross(last, next, a, b)) return true;
      // Closing side next → first: skip the side that starts at `first`.
      if (i > 0 && _segmentsCross(next, first, a, b)) return true;
    }
    return false;
  }

  /// True if the polygon has no crossing sides.
  static bool isSimplePolygon(List<LatLng> polygon) {
    for (var i = 3; i <= polygon.length; i++) {
      if (i == polygon.length) break;
      if (wouldCross(polygon.sublist(0, i), polygon[i])) return false;
    }
    return true;
  }

  /// Proper crossing of segments p1-p2 and q1-q2 (touching ends don't count).
  /// Flat lng/lat maths is fine for areas a few km wide.
  static bool _segmentsCross(LatLng p1, LatLng p2, LatLng q1, LatLng q2) {
    double cross(LatLng o, LatLng a, LatLng b) =>
        (a.longitude - o.longitude) * (b.latitude - o.latitude) -
        (a.latitude - o.latitude) * (b.longitude - o.longitude);
    final d1 = cross(q1, q2, p1);
    final d2 = cross(q1, q2, p2);
    final d3 = cross(p1, p2, q1);
    final d4 = cross(p1, p2, q2);
    return ((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) &&
        ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0));
  }

  /// Polygon ring with the first point repeated at the end.
  static List<LatLng> closedRing(List<LatLng> polygon) =>
      polygon.isEmpty ? polygon : [...polygon, polygon.first];

  static double _degToRad(double deg) => deg * math.pi / 180;
  static double _radToDeg(double rad) => rad * 180 / math.pi;
}
