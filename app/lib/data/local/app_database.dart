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

@DriftDatabase(tables: [Zones, ZonePoints, SyncQueue])
class AppDatabase extends _$AppDatabase {
  /// [executor] is only passed in tests (in-memory database).
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'app_cazador'));

  @override
  int get schemaVersion => 1;
}
