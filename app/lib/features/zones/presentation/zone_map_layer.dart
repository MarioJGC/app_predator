import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../core/geo/geo_utils.dart';
import '../domain/zone.dart';
import 'zone_labels.dart';

/// Key used in annotation data to find the zone that was tapped.
const zoneIdKey = 'zoneId';

/// Draws zones and points on a map. Call it again whenever the data or the
/// map style changes (a new style removes every annotation).
Future<void> drawZones(
  MapLibreMapController controller, {
  required List<Zone> zones,
  required List<ZonePoint> points,
}) async {
  await controller.clearFills();
  await controller.clearLines();
  await controller.clearCircles();

  for (final zone in zones) {
    final data = {zoneIdKey: zone.id};
    if (zone.kind == ZoneKind.area && zone.geometry.length >= 3) {
      final ring = GeoUtils.closedRing(zone.geometry);
      await controller.addFill(
        FillOptions(geometry: [ring], fillColor: ZoneColors.area, fillOpacity: 0.25),
        data,
      );
      await controller.addLine(
        LineOptions(geometry: ring, lineColor: ZoneColors.outline, lineWidth: 3),
        data,
      );
    } else if (zone.geometry.length >= 2) {
      await controller.addLine(
        LineOptions(
          geometry: zone.geometry,
          lineColor: ZoneColors.outline,
          lineWidth: 5,
          lineJoin: 'round',
        ),
        data,
      );
    }
  }

  for (final point in points) {
    await controller.addCircle(
      CircleOptions(
        geometry: point.position,
        circleRadius: 9,
        circleColor: ZoneColors.point(point.kind),
        circleStrokeColor: '#FFFFFF',
        circleStrokeWidth: 3,
      ),
      {zoneIdKey: point.zoneId},
    );
  }
}

/// Draws the shape being created (draw area / record route screens).
Future<void> drawDraft(
  MapLibreMapController controller,
  List<LatLng> points, {
  required bool closed,
}) async {
  await controller.clearFills();
  await controller.clearLines();
  await controller.clearCircles();

  if (closed && points.length >= 3) {
    await controller.addFill(FillOptions(
      geometry: [GeoUtils.closedRing(points)],
      fillColor: ZoneColors.draft,
      fillOpacity: 0.25,
    ));
  }
  if (points.length >= 2) {
    await controller.addLine(LineOptions(
      geometry: closed && points.length >= 3 ? GeoUtils.closedRing(points) : points,
      lineColor: ZoneColors.draft,
      lineWidth: 4,
      lineJoin: 'round',
    ));
  }
  // Corners are only useful while drawing an area, not on a GPS track.
  if (closed) {
    for (final p in points) {
      await controller.addCircle(CircleOptions(
        geometry: p,
        circleRadius: 8,
        circleColor: ZoneColors.draft,
        circleStrokeColor: '#FFFFFF',
        circleStrokeWidth: 2,
      ));
    }
  }
}

/// Moves the camera so the whole zone is visible.
Future<void> fitZone(MapLibreMapController controller, Zone zone) {
  final bounds = GeoUtils.expand(zone.bounds, 100);
  return controller.moveCamera(
    CameraUpdate.newLatLngBounds(bounds, left: 40, right: 40, top: 40, bottom: 40),
  );
}
