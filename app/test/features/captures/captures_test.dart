import 'package:app/data/local/app_database.dart';
import 'package:app/features/captures/data/captures_repository.dart';
import 'package:app/features/captures/data/photo_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  group('CapturesRepository', () {
    late AppDatabase db;
    late CapturesRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = CapturesRepository(db);
    });
    tearDown(() => db.close());

    test('created capture is listed, newest first', () async {
      await repo.createCapture(species: 'red_deer', count: 1);
      await repo.createCapture(
        species: 'wild_boar',
        count: 2,
        position: const LatLng(39.55, -4.35),
        notes: '  ',
      );

      final captures = await repo.watchCaptures().first;
      expect(captures.map((c) => c.species), ['wild_boar', 'red_deer']);
      expect(captures.first.count, 2);
      expect(captures.first.position, const LatLng(39.55, -4.35));
      expect(captures.first.notes, isNull);
    });

    test('deleted capture is hidden and queued for sync', () async {
      final id = await repo.createCapture(species: 'hare', count: 3);
      await repo.deleteCapture(id);

      expect(await repo.watchCaptures().first, isEmpty);
      final queue = await db.select(db.syncQueue).get();
      expect(queue.map((r) => '${r.entity}:${r.operation}'),
          ['captures:upsert', 'captures:delete']);
    });
  });

  group('compressPhoto', () {
    test('shrinks big photos and removes EXIF', () {
      final photo = img.Image(width: 4000, height: 3000);
      photo.exif.gpsIfd['GPSLatitude'] = img.IfdValueAscii('39.55');
      photo.exif.imageIfd['Model'] = img.IfdValueAscii('Test phone');
      final original = img.encodeJpg(photo);
      expect(img.decodeJpg(original)!.exif.isEmpty, isFalse);

      final result = img.decodeJpg(compressPhoto(original))!;

      expect(result.width, maxPhotoSide);
      expect(result.height, 1200);
      expect(result.exif.isEmpty, isTrue);
    });
  });
}
