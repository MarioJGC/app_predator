import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Local SQLite database. The app always reads and writes here first,
/// never waiting for the network (offline-first, ARQUITECTURA.md §5).

/// Hunting areas (polygons) and routes (lines).
@DataClassName('ZoneRow')
class Zones extends Table {
  /// UUID generated on the phone, so no network is needed to create it.
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  /// 'area' or 'route'.
  TextColumn get kind => text()();

  /// JSON list of [longitude, latitude] pairs.
  TextColumn get geometry => text()();

  /// Comma-separated species keys, e.g. "wild_boar,red_deer".
  TextColumn get species => text().withDefault(const Constant(''))();
  TextColumn get modality => text().nullable()();

  /// Zone that contains this one (subzone). Null for top-level zones.
  /// Any depth is allowed: zone → subzone → sub-subzone...
  TextColumn get parentId => text().nullable().references(Zones, #id)();

  /// JSON with what is in the zone: animals, food & water, danger,
  /// bedding & paths. See `ZoneFeatures`.
  TextColumn get features => text().withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete, so the deletion can be synced to other phones.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Points of interest inside a zone (stand, parking, feeder...).
@DataClassName('ZonePointRow')
class ZonePoints extends Table {
  TextColumn get id => text()();
  TextColumn get zoneId => text().references(Zones, #id)();

  /// 'stand', 'parking', 'feeder', 'danger' or 'other'.
  TextColumn get kind => text()();
  TextColumn get name => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Game taken by the user (PRD RF-60).
@DataClassName('CaptureRow')
class Captures extends Table {
  TextColumn get id => text()();

  /// Species key, e.g. 'wild_boar'.
  TextColumn get species => text()();
  IntColumn get count => integer().withDefault(const Constant(1))();

  /// Local file path of the compressed photo (no EXIF).
  TextColumn get photoPath => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get takenAt => dateTime()();

  /// Live hunt it belongs to. Filled when hunts exist (backend).
  TextColumn get huntId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Outbox: local changes waiting to be uploaded when there is network.
/// Filled now; read by the sync engine when the backend exists.
@DataClassName('SyncQueueRow')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Table name, e.g. 'zones'.
  TextColumn get entity => text()();
  TextColumn get entityId => text()();

  /// 'upsert' or 'delete'.
  TextColumn get operation => text()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Zones, ZonePoints, Captures, SyncQueue])
class AppDatabase extends _$AppDatabase {
  /// [executor] is only passed in tests (in-memory database).
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'app_cazador'));

  /// v1: zones, points, sync queue. v2: captures. v3: subzones + features.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.createTable(captures);
          if (from < 3) {
            await m.addColumn(zones, zones.parentId);
            await m.addColumn(zones, zones.features);
          }
        },
      );
}
