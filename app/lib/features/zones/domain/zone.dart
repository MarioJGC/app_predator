import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../core/geo/geo_utils.dart';

enum ZoneKind { area, route }

enum PointKind { stand, parking, feeder, danger, other }

/// A hunting area (polygon) or route (line) saved by the user.
class Zone {
  const Zone({
    required this.id,
    required this.name,
    required this.kind,
    required this.geometry,
    this.description,
    this.species = const [],
    this.modality,
  });

  final String id;
  final String name;
  final String? description;
  final ZoneKind kind;

  /// Corners of the area, or the track of the route.
  final List<LatLng> geometry;

  /// Species keys, see [huntingSpecies].
  final List<String> species;

  /// Modality key, see [huntingModalities].
  final String? modality;

  LatLngBounds get bounds => GeoUtils.bounds(geometry);
  LatLng get center => GeoUtils.centroid(geometry);

  /// Square metres for areas, metres for routes.
  double get size => kind == ZoneKind.area
      ? GeoUtils.areaSquareMeters(geometry)
      : GeoUtils.lengthMeters(geometry);
}

/// A point of interest inside a zone.
class ZonePoint {
  const ZonePoint({
    required this.id,
    required this.zoneId,
    required this.kind,
    required this.position,
    this.name,
  });

  final String id;
  final String zoneId;
  final PointKind kind;
  final LatLng position;
  final String? name;
}

/// Species keys stored in the database. Labels come from translations.
const huntingSpecies = [
  'wild_boar',
  'red_deer',
  'roe_deer',
  'fallow_deer',
  'mouflon',
  'ibex',
  'partridge',
  'rabbit',
  'hare',
  'quail',
  'pigeon',
  'fox',
];

/// Hunting modality keys stored in the database.
const huntingModalities = [
  'monteria',
  'batida',
  'stalking',
  'waiting',
  'small_game',
  'other',
];
