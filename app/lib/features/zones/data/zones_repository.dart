import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/geo/geo_utils.dart';
import '../../../data/local/app_database.dart';
import '../domain/zone.dart';

/// Reads and writes zones and points in the local database.
/// Every change is also added to the sync queue (outbox).
class ZonesRepository {
  ZonesRepository(this._db);

  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  // ---------- Reads ----------

  Stream<List<Zone>> watchZones() {
    final query = _db.select(_db.zones)
      ..where((z) => z.deletedAt.isNull())
      ..orderBy([(z) => OrderingTerm.desc(z.updatedAt)]);
    return query.watch().map((rows) => rows.map(_toZone).toList());
  }

  Stream<Zone?> watchZone(String id) {
    final query = _db.select(_db.zones)
      ..where((z) => z.id.equals(id) & z.deletedAt.isNull());
    return query.watchSingleOrNull().map((row) => row == null ? null : _toZone(row));
  }

  /// Points of one zone, or of every zone if [zoneId] is null.
  Stream<List<ZonePoint>> watchPoints({String? zoneId}) {
    final query = _db.select(_db.zonePoints)
      ..where((p) {
        final notDeleted = p.deletedAt.isNull();
        return zoneId == null ? notDeleted : notDeleted & p.zoneId.equals(zoneId);
      })
      ..orderBy([(p) => OrderingTerm.asc(p.kind), (p) => OrderingTerm.asc(p.name)]);
    return query.watch().map((rows) => rows.map(_toPoint).toList());
  }

  // ---------- Writes ----------

  Future<String> createZone({
    required String name,
    required ZoneKind kind,
    required List<LatLng> geometry,
    String? description,
    List<String> species = const [],
    String? modality,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db.into(_db.zones).insert(ZonesCompanion.insert(
            id: id,
            name: name.trim(),
            description: Value(_blankToNull(description)),
            kind: kind.name,
            geometry: GeoUtils.encode(geometry),
            species: Value(species.join(',')),
            modality: Value(modality),
            createdAt: now,
            updatedAt: now,
          ));
      await _enqueue('zones', id, 'upsert');
    });
    return id;
  }

  Future<void> updateZoneDetails(
    String id, {
    required String name,
    String? description,
    List<String> species = const [],
    String? modality,
  }) {
    return _db.transaction(() async {
      await (_db.update(_db.zones)..where((z) => z.id.equals(id))).write(
        ZonesCompanion(
          name: Value(name.trim()),
          description: Value(_blankToNull(description)),
          species: Value(species.join(',')),
          modality: Value(modality),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _enqueue('zones', id, 'upsert');
    });
  }

  /// Turns a recorded route into an area: the polygon closes itself
  /// (last point joined to the first).
  Future<void> convertRouteToArea(String id) {
    return _db.transaction(() async {
      await (_db.update(_db.zones)..where((z) => z.id.equals(id))).write(
        ZonesCompanion(
          kind: Value(ZoneKind.area.name),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _enqueue('zones', id, 'upsert');
    });
  }

  /// Soft-deletes the zone and all its points.
  Future<void> deleteZone(String id) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(_db.zones)..where((z) => z.id.equals(id))).write(
        ZonesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await (_db.update(_db.zonePoints)
            ..where((p) => p.zoneId.equals(id) & p.deletedAt.isNull()))
          .write(ZonePointsCompanion(deletedAt: Value(now), updatedAt: Value(now)));
      await _enqueue('zones', id, 'delete');
    });
  }

  Future<String> addPoint({
    required String zoneId,
    required PointKind kind,
    required LatLng position,
    String? name,
  }) async {
    final id = _uuid.v4();
    await _db.transaction(() async {
      await _db.into(_db.zonePoints).insert(ZonePointsCompanion.insert(
            id: id,
            zoneId: zoneId,
            kind: kind.name,
            name: Value(_blankToNull(name)),
            latitude: position.latitude,
            longitude: position.longitude,
            updatedAt: DateTime.now(),
          ));
      await _enqueue('zone_points', id, 'upsert');
    });
    return id;
  }

  Future<void> deletePoint(String id) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(_db.zonePoints)..where((p) => p.id.equals(id))).write(
        ZonePointsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await _enqueue('zone_points', id, 'delete');
    });
  }

  // ---------- Helpers ----------

  Future<void> _enqueue(String entity, String id, String operation) {
    return _db.into(_db.syncQueue).insert(SyncQueueCompanion.insert(
          entity: entity,
          entityId: id,
          operation: operation,
          createdAt: DateTime.now(),
        ));
  }

  static String? _blankToNull(String? text) {
    final trimmed = text?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  static Zone _toZone(ZoneRow row) => Zone(
        id: row.id,
        name: row.name,
        description: row.description,
        kind: ZoneKind.values.byName(row.kind),
        geometry: GeoUtils.decode(row.geometry),
        species: row.species.isEmpty ? const [] : row.species.split(','),
        modality: row.modality,
      );

  static ZonePoint _toPoint(ZonePointRow row) => ZonePoint(
        id: row.id,
        zoneId: row.zoneId,
        kind: PointKind.values.byName(row.kind),
        position: LatLng(row.latitude, row.longitude),
        name: row.name,
      );
}

// ---------- Providers ----------

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final zonesRepositoryProvider =
    Provider((ref) => ZonesRepository(ref.watch(databaseProvider)));

final zonesProvider = StreamProvider<List<Zone>>(
  (ref) => ref.watch(zonesRepositoryProvider).watchZones(),
);

final zoneProvider = StreamProvider.family<Zone?, String>(
  (ref, id) => ref.watch(zonesRepositoryProvider).watchZone(id),
);

final zonePointsProvider = StreamProvider.family<List<ZonePoint>, String>(
  (ref, zoneId) => ref.watch(zonesRepositoryProvider).watchPoints(zoneId: zoneId),
);

final allPointsProvider = StreamProvider<List<ZonePoint>>(
  (ref) => ref.watch(zonesRepositoryProvider).watchPoints(),
);
