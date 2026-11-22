import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Longest side of a stored photo. About 300 KB at quality 70.
const maxPhotoSide = 1600;
const photoQuality = 70;

/// Takes photos with the camera and keeps a small, private copy.
class PhotoStorage {
  final _picker = ImagePicker();

  /// Opens the camera. Returns the saved file path, or null if cancelled.
  Future<String?> takePhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );
    if (picked == null) return null;

    final original = await picked.readAsBytes();
    final compressed = await Isolate.run(() => compressPhoto(original));

    final dir = Directory(p.join((await getApplicationDocumentsDirectory()).path, 'captures'));
    await dir.create(recursive: true);
    final file = File(p.join(dir.path, '${const Uuid().v4()}.jpg'));
    await file.writeAsBytes(compressed);
    return file.path;
  }

  Future<void> delete(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}

/// Resizes, compresses and removes EXIF metadata (GPS position, phone model)
/// so photos never reveal hunting spots (PRD RNF-06).
Uint8List compressPhoto(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) throw const FormatException('Not an image');

  // Apply the EXIF rotation to the pixels before dropping EXIF.
  var image = img.bakeOrientation(decoded);
  if (image.width > maxPhotoSide || image.height > maxPhotoSide) {
    image = image.width >= image.height
        ? img.copyResize(image, width: maxPhotoSide)
        : img.copyResize(image, height: maxPhotoSide);
  }
  image.exif = img.ExifData();
  return img.encodeJpg(image, quality: photoQuality);
}

final photoStorageProvider = Provider((ref) => PhotoStorage());
