import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';

/// Disk cache for map tiles already seen. IGN servers are slow, so
/// areas the user has visited load instantly the next time.
const _mapCacheBytes = 300 * 1024 * 1024;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await setMaximumAmbientCacheSize(_mapCacheBytes);
  } catch (_) {
    // Not critical: the map still works with the default 50 MB cache.
  }
  runApp(const ProviderScope(child: HunterApp()));
}
