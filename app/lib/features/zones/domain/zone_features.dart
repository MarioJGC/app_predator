import 'dart:convert';

/// How dangerous a zone is.
enum DangerLevel { none, low, medium, high }

/// What a hunter has noted inside a zone or subzone.
/// Stored as JSON in `zones.features`. All values are keys; labels come
/// from translations.
class ZoneFeatures {
  const ZoneFeatures({
    this.animals = const {},
    this.foodWater = const {},
    this.dangerLevel = DangerLevel.none,
    this.dangers = const {},
    this.wildlifeSigns = const {},
  });

  /// Species seen here (keys from `huntingSpecies`).
  final Set<String> animals;

  /// Keys from [foodWaterTypes].
  final Set<String> foodWater;
  final DangerLevel dangerLevel;

  /// Keys from [dangerTypes].
  final Set<String> dangers;

  /// Bedding and paths: keys from [wildlifeSignTypes].
  final Set<String> wildlifeSigns;

  bool get isEmpty =>
      animals.isEmpty &&
      foodWater.isEmpty &&
      dangerLevel == DangerLevel.none &&
      dangers.isEmpty &&
      wildlifeSigns.isEmpty;

  ZoneFeatures copyWith({
    Set<String>? animals,
    Set<String>? foodWater,
    DangerLevel? dangerLevel,
    Set<String>? dangers,
    Set<String>? wildlifeSigns,
  }) {
    return ZoneFeatures(
      animals: animals ?? this.animals,
      foodWater: foodWater ?? this.foodWater,
      dangerLevel: dangerLevel ?? this.dangerLevel,
      dangers: dangers ?? this.dangers,
      wildlifeSigns: wildlifeSigns ?? this.wildlifeSigns,
    );
  }

  String toJson() => jsonEncode({
        'animals': animals.toList()..sort(),
        'foodWater': foodWater.toList()..sort(),
        'dangerLevel': dangerLevel.name,
        'dangers': dangers.toList()..sort(),
        'wildlifeSigns': wildlifeSigns.toList()..sort(),
      });

  /// Tolerant: unknown or missing fields become empty (older app versions).
  factory ZoneFeatures.fromJson(String json) {
    final map = (jsonDecode(json) as Map?)?.cast<String, dynamic>() ?? const {};
    Set<String> keys(String field) =>
        {...?(map[field] as List?)?.whereType<String>()};
    return ZoneFeatures(
      animals: keys('animals'),
      foodWater: keys('foodWater'),
      dangerLevel: DangerLevel.values.asNameMap()[map['dangerLevel']] ?? DangerLevel.none,
      dangers: keys('dangers'),
      wildlifeSigns: keys('wildlifeSigns'),
    );
  }
}

const foodWaterTypes = ['feeder', 'water_trough', 'natural_water', 'crops', 'acorns', 'fruit'];

const dangerTypes = ['cliff', 'road', 'houses', 'no_hunting', 'livestock', 'other'];

const wildlifeSignTypes = ['bedding', 'crossing', 'wallow', 'rub', 'tracks'];
