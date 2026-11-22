import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../domain/zone.dart';

/// Translated names, icons and colors for zone data.
extension ZoneLabels on AppLocalizations {
  String zoneKind(ZoneKind kind) => switch (kind) {
        ZoneKind.area => zoneKindArea,
        ZoneKind.route => zoneKindRoute,
      };

  String pointKind(PointKind kind) => switch (kind) {
        PointKind.stand => pointStand,
        PointKind.parking => pointParking,
        PointKind.feeder => pointFeeder,
        PointKind.danger => pointDanger,
        PointKind.other => pointOther,
      };

  String speciesName(String key) => switch (key) {
        'wild_boar' => speciesWildBoar,
        'red_deer' => speciesRedDeer,
        'roe_deer' => speciesRoeDeer,
        'fallow_deer' => speciesFallowDeer,
        'mouflon' => speciesMouflon,
        'ibex' => speciesIbex,
        'partridge' => speciesPartridge,
        'rabbit' => speciesRabbit,
        'hare' => speciesHare,
        'quail' => speciesQuail,
        'pigeon' => speciesPigeon,
        'fox' => speciesFox,
        _ => key,
      };

  String modalityName(String key) => switch (key) {
        'monteria' => modalityMonteria,
        'batida' => modalityBatida,
        'stalking' => modalityStalking,
        'waiting' => modalityWaiting,
        'small_game' => modalitySmallGame,
        'other' => modalityOther,
        _ => key,
      };

  /// "12,5 ha" for areas, "2,3 km" for routes, in the user's language.
  String zoneSize(Zone zone) {
    final format = NumberFormat('#,##0.0', localeName);
    return zone.kind == ZoneKind.area
        ? '${format.format(zone.size / 10000)} ha'
        : formatDistance(zone.size);
  }

  /// "850 KB", "12,3 MB".
  String formatBytes(int bytes) {
    const mb = 1024 * 1024;
    if (bytes < mb) return '${(bytes / 1024).ceil()} KB';
    return '${NumberFormat('#,##0.0', localeName).format(bytes / mb)} MB';
  }

  String formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${NumberFormat('#,##0.0', localeName).format(meters / 1000)} km';
  }
}

IconData zoneKindIcon(ZoneKind kind) => switch (kind) {
      ZoneKind.area => Icons.crop_square,
      ZoneKind.route => Icons.timeline,
    };

IconData pointKindIcon(PointKind kind) => switch (kind) {
      PointKind.stand => Icons.person_pin_circle,
      PointKind.parking => Icons.directions_car,
      PointKind.feeder => Icons.grass,
      PointKind.danger => Icons.warning_amber,
      PointKind.other => Icons.place,
    };

/// Colors that stand out on both satellite and topographic maps.
abstract final class ZoneColors {
  static const area = '#FFB300';
  static const outline = '#FF6F00';
  static const draft = '#00E5FF';

  static String point(PointKind kind) => switch (kind) {
        PointKind.stand => '#D32F2F',
        PointKind.parking => '#1565C0',
        PointKind.feeder => '#2E7D32',
        PointKind.danger => '#FFD600',
        PointKind.other => '#6A1B9A',
      };

  static Color pointColor(PointKind kind) =>
      Color(int.parse('FF${point(kind).substring(1)}', radix: 16));
}
