import 'package:app/data/local/app_database.dart';
import 'package:app/features/zones/data/zones_repository.dart';
import 'package:app/features/zones/domain/zone.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  late AppDatabase db;
  late ZonesRepository repo;

  const triangle = [
    LatLng(39.55, -4.35),
    LatLng(39.55, -4.34),
    LatLng(39.56, -4.34),
  ];

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ZonesRepository(db);
  });

  tearDown(() => db.close());

  test('created zone is listed with its data', () async {
    await repo.createZone(
      name: '  Coto Los Robles ',
      kind: ZoneKind.area,
      geometry: triangle,
      species: ['wild_boar', 'red_deer'],
      modality: 'monteria',
      description: '   ',
    );

    final zones = await repo.watchZones().first;
    expect(zones, hasLength(1));
    expect(zones.single.name, 'Coto Los Robles');
    expect(zones.single.description, isNull);
    expect(zones.single.species, ['wild_boar', 'red_deer']);
    expect(zones.single.geometry, triangle);
  });

  test('deleting a zone hides it and its points', () async {
    final id = await repo.createZone(
      name: 'Zona',
      kind: ZoneKind.area,
      geometry: triangle,
    );
    await repo.addPoint(
      zoneId: id,
      kind: PointKind.stand,
      position: triangle.first,
      name: '7',
    );

    await repo.deleteZone(id);

    expect(await repo.watchZones().first, isEmpty);
    expect(await repo.watchPoints().first, isEmpty);
  });

  test('every change is added to the sync queue', () async {
    final id = await repo.createZone(
      name: 'Zona',
      kind: ZoneKind.route,
      geometry: triangle,
    );
    await repo.addPoint(zoneId: id, kind: PointKind.parking, position: triangle.first);
    await repo.deleteZone(id);

    final queue = await db.select(db.syncQueue).get();
    expect(
      queue.map((row) => '${row.entity}:${row.operation}'),
      ['zones:upsert', 'zone_points:upsert', 'zones:delete'],
    );
  });
}
