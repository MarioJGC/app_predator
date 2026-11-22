import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/app_database.dart';
import '../../zones/data/zones_repository.dart' show databaseProvider;
import '../domain/capture.dart';

/// Reads and writes captures in the local database (+ sync queue).
class CapturesRepository {
  CapturesRepository(this._db);

  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  Stream<List<Capture>> watchCaptures() {
    final query = _db.select(_db.captures)
      ..where((c) => c.deletedAt.isNull())
      // Dates are stored in whole seconds: rowId breaks ties (newest first).
      ..orderBy([(c) => OrderingTerm.desc(c.takenAt), (c) => OrderingTerm.desc(c.rowId)]);
    return query.watch().map((rows) => rows.map(_toCapture).toList());
  }

  Stream<Capture?> watchCapture(String id) {
    final query = _db.select(_db.captures)
      ..where((c) => c.id.equals(id) & c.deletedAt.isNull());
    return query.watchSingleOrNull().map((row) => row == null ? null : _toCapture(row));
  }

  Future<String> createCapture({
    required String species,
    required int count,
    String? photoPath,
    LatLng? position,
    String? notes,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final trimmedNotes = notes?.trim();
    await _db.transaction(() async {
      await _db.into(_db.captures).insert(CapturesCompanion.insert(
            id: id,
            species: species,
            count: Value(count),
            photoPath: Value(photoPath),
            latitude: Value(position?.latitude),
            longitude: Value(position?.longitude),
            notes: Value(trimmedNotes == null || trimmedNotes.isEmpty ? null : trimmedNotes),
            takenAt: now,
            updatedAt: now,
          ));
      await _enqueue(id, 'upsert');
    });
    return id;
  }

  Future<void> deleteCapture(String id) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(_db.captures)..where((c) => c.id.equals(id))).write(
        CapturesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await _enqueue(id, 'delete');
    });
  }

  Future<void> _enqueue(String id, String operation) {
    return _db.into(_db.syncQueue).insert(SyncQueueCompanion.insert(
          entity: 'captures',
          entityId: id,
          operation: operation,
          createdAt: DateTime.now(),
        ));
  }

  static Capture _toCapture(CaptureRow row) => Capture(
        id: row.id,
        species: row.species,
        count: row.count,
        takenAt: row.takenAt,
        photoPath: row.photoPath,
        position: row.latitude == null || row.longitude == null
            ? null
            : LatLng(row.latitude!, row.longitude!),
        notes: row.notes,
      );
}

final capturesRepositoryProvider =
    Provider((ref) => CapturesRepository(ref.watch(databaseProvider)));

final capturesProvider = StreamProvider<List<Capture>>(
  (ref) => ref.watch(capturesRepositoryProvider).watchCaptures(),
);

final captureProvider = StreamProvider.family<Capture?, String>(
  (ref, id) => ref.watch(capturesRepositoryProvider).watchCapture(id),
);
