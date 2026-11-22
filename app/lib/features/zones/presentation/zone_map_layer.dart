import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../core/geo/geo_utils.dart';
import '../domain/zone.dart';
import 'zone_labels.dart';

/// Key used in annotation data to find the zone that was tapped.
const zoneIdKey = 'zoneId';

/// Draws zones, subzones and points on a map. Call it again whenever the data
/// or the map style changes (a new style removes every annotation).
///
/// Parents are drawn first so subzones stay on top (and get the tap).
/// Subzones are blue; zones with danger are filled yellow/orange/red.
Future<void> drawZones(
  MapLibreMapController controller, {
  required List<Zone> zones,
  required List<ZonePoint> points,
}) async {
  await controller.clearFills();
  await controller.clearLines();
  await controller.clearCircles();

  final byId = {for (final z in zones) z.id: z};
  int depth(Zone zone) {
    var d = 0;
    var parent = zone.parentId;
    while (parent != null && byId.containsKey(parent) && d < 50) {
      d++;
      parent = byId[parent]!.parentId;
    }
    return d;
  }

  final sorted = [...zones]..sort((a, b) => depth(a).compareTo(depth(b)));
  for (final zone in sorted) {
    final data = {zoneIdKey: zone.id};
    final outline = zone.isSubzone ? ZoneColors.subzone : ZoneColors.outline;
    final danger = ZoneColors.danger(zone.features.dangerLevel);
    if (zone.kind == ZoneKind.area && zone.geometry.length >= 3) {
      final ring = GeoUtils.closedRing(zone.geometry);
      await controller.addFill(
        FillOptions(
          geometry: [ring],
          fillColor: danger ?? (zone.isSubzone ? ZoneColors.subzone : ZoneColors.area),
          fillOpacity: danger != null ? 0.35 : 0.2,
        ),
        data,
      );
      await controller.addLine(
        LineOptions(geometry: ring, lineColor: outline, lineWidth: 3),
        data,
      );
    } else if (zone.geometry.length >= 2) {
      await controller.addLine(
        LineOptions(
          geometry: zone.geometry,
          lineColor: outline,
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
/// [parent]: when drawing a subzone, its zone is outlined as a guide.
Future<void> drawDraft(
  MapLibreMapController controller,
  List<LatLng> points, {
  required bool closed,
  Zone? parent,
}) async {
  await controller.clearFills();
  await controller.clearLines();
  await controller.clearCircles();

  if (parent != null && parent.geometry.length >= 3) {
    await controller.addLine(LineOptions(
      geometry: GeoUtils.closedRing(parent.geometry),
      lineColor: ZoneColors.outline,
      lineWidth: 3,
    ));
  }

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
