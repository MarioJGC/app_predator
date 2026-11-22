import 'package:maplibre_gl/maplibre_gl.dart';

/// Game taken by the user.
class Capture {
  const Capture({
    required this.id,
    required this.species,
    required this.count,
    required this.takenAt,
    this.photoPath,
    this.position,
    this.notes,
  });

  final String id;

  /// Species key, see `huntingSpecies`.
  final String species;
  final int count;
  final DateTime takenAt;
  final String? photoPath;
  final LatLng? position;
  final String? notes;
}
