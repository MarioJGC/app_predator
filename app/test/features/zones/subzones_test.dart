import 'package:app/data/local/app_database.dart';
import 'package:app/features/zones/data/zones_repository.dart';
import 'package:app/features/zones/domain/zone.dart';
import 'package:app/features/zones/domain/zone_features.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  late AppDatabase db;
  late ZonesRepository repo;

  const shape = [
    LatLng(39.55, -4.35),
    LatLng(39.55, -4.34),
    LatLng(39.56, -4.34),
  ];

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ZonesRepository(db);
  });
  tearDown(() => db.close());

  Future<String> zone(String name, {String? parent}) => repo.createZone(
        name: name,
        kind: ZoneKind.area,
        geometry: shape,
        parentId: parent,
      );

  test('subzones are listed under their parent, any depth', () async {
    final coto = await zone('Coto');
    final umbria = await zone('Umbría', parent: coto);
    await zone('Arroyo', parent: umbria);

    expect((await repo.watchChildren(null).first).map((z) => z.name), ['Coto']);
    expect((await repo.watchChildren(coto).first).map((z) => z.name), ['Umbría']);
    expect((await repo.watchChildren(umbria).first).map((z) => z.name), ['Arroyo']);
    expect(await repo.watchZones().first, hasLength(3));
  });

  test('deleting a zone deletes all its subzones', () async {
    final coto = await zone('Coto');
    final umbria = await zone('Umbría', parent: coto);
    await zone('Arroyo', parent: umbria);
    await zone('Otro coto');

    await repo.deleteZone(coto);

    expect((await repo.watchZones().first).map((z) => z.name), ['Otro coto']);
  });

  test('features are saved and read back', () async {
    final id = await zone('Umbría');
    const features = ZoneFeatures(
      animals: {'fox', 'wild_boar'},
      foodWater: {'acorns'},
      dangerLevel: DangerLevel.high,
      dangers: {'cliff'},
      wildlifeSigns: {'bedding', 'crossing'},
    );

    await repo.updateFeatures(id, features);
    final saved = (await repo.watchZone(id).first)!.features;

    expect(saved.animals, {'fox', 'wild_boar'});
    expect(saved.dangerLevel, DangerLevel.high);
    expect(saved.wildlifeSigns, {'bedding', 'crossing'});
    expect(saved.isEmpty, isFalse);
  });

  test('broken or old features JSON is read as empty', () {
    expect(ZoneFeatures.fromJson('{}').isEmpty, isTrue);
    expect(ZoneFeatures.fromJson('{"dangerLevel": "unknown"}').dangerLevel, DangerLevel.none);
  });
}
