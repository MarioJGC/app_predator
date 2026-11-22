import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../geo/geo_utils.dart';

/// Download style with BOTH base maps (satellite + topographic).
///
/// MapLibre's offline manager only downloads styles served over http(s)
/// (see ARQUITECTURA.md §5). The app shows the bundled asset styles; tiles
/// have the same URLs, so downloaded tiles are reused offline.
///
/// Default: the file in the public GitHub repo (main branch).
/// Override for local tests:
///   flutter run --dart-define=STYLE_URL=http://10.0.2.2:8765/offline_style.json
/// Production: serve it from our own tile cache (Cloudflare).
const offlineStyleUrl = String.fromEnvironment(
  'STYLE_URL',
  defaultValue: 'https://raw.githubusercontent.com/MarioJGC/app_predator/'
      'main/app/assets/map/offline_style.json',
);

/// Zoom 12 shows the whole area; zoom 16 shows paths and single trees.
const offlineMinZoom = 12;
const offlineMaxZoom = 16;

/// Extra margin around a zone, to see the access roads (PRD RF-20).
const offlineMarginMeters = 1000.0;

/// Base maps in the download style.
const _layersPerTile = 2;

/// Average size of one IGN JPEG tile. Calibrated on a real download
/// (Montes de Toledo, 21 ha zone: estimate 2.4 MB with 22 KB, real 4.2 MB).
const _averageTileBytes = 38 * 1024;

/// Area that is downloaded for a zone.
LatLngBounds offlineBoundsFor(LatLngBounds zoneBounds) =>
    GeoUtils.expand(zoneBounds, offlineMarginMeters);

/// Number of map tiles that cover [bounds] between two zoom levels.
int tileCount(LatLngBounds bounds, int minZoom, int maxZoom) {
  var total = 0;
  for (var z = minZoom; z <= maxZoom; z++) {
    final x0 = _lngToTileX(bounds.southwest.longitude, z);
    final x1 = _lngToTileX(bounds.northeast.longitude, z);
    final y0 = _latToTileY(bounds.northeast.latitude, z);
    final y1 = _latToTileY(bounds.southwest.latitude, z);
    total += (x1 - x0 + 1) * (y1 - y0 + 1);
  }
  return total;
}

/// Rough download size, shown before downloading.
int estimatedDownloadBytes(LatLngBounds zoneBounds) =>
    tileCount(offlineBoundsFor(zoneBounds), offlineMinZoom, offlineMaxZoom) *
    _layersPerTile *
    _averageTileBytes;

int _lngToTileX(double lng, int z) =>
    ((lng + 180) / 360 * (1 << z)).floor();

int _latToTileY(double lat, int z) {
  final rad = lat * math.pi / 180;
  final y = (1 - math.log(math.tan(rad) + 1 / math.cos(rad)) / math.pi) / 2;
  return (y * (1 << z)).floor();
}

// ---------- State ----------

/// Download state of one zone's map.
sealed class OfflineMapState {
  const OfflineMapState();
}

class OfflineMapDownloading extends OfflineMapState {
  const OfflineMapDownloading(this.progress, this.bytes);

  /// From 0 to 1.
  final double progress;
  final int bytes;
}

class OfflineMapReady extends OfflineMapState {
  const OfflineMapReady(this.regionId, this.bytes);
  final int regionId;
  final int bytes;
}

class OfflineMapFailed extends OfflineMapState {
  const OfflineMapFailed(this.code);
  final String code;
}

/// Key in the region metadata that links it to a zone.
const _zoneIdKey = 'zoneId';

/// Downloaded maps, by zone id. A zone that is not in the map has no download.
class OfflineMapsNotifier extends Notifier<Map<String, OfflineMapState>> {
  @override
  Map<String, OfflineMapState> build() {
    unawaited(_load());
    return const {};
  }

  Future<void> _load() async {
    // MapLibre's default limit (6000 tiles) is too low for big estates.
    await setOfflineTileCountLimit(50000);
    final loaded = <String, OfflineMapState>{};
    for (final region in await getListOfRegions()) {
      final zoneId = region.metadata[_zoneIdKey];
      if (zoneId is! String) {
        // Not linked to any zone (e.g. old test downloads): free the space.
        await deleteOfflineRegion(region.id);
        continue;
      }
      final status = await getOfflineRegionStatus(region.id);
      loaded[zoneId] = status.isComplete
          ? OfflineMapReady(region.id, status.completedResourceSize)
          : const OfflineMapFailed('INCOMPLETE');
    }
    state = {...loaded, ...state};
  }

  Future<void> download({
    required String zoneId,
    required String zoneName,
    required LatLngBounds zoneBounds,
  }) async {
    if (state[zoneId] is OfflineMapDownloading) return;
    await delete(zoneId); // Replace any old or broken download.
    _set(zoneId, const OfflineMapDownloading(0, 0));

    try {
      final region = await downloadOfflineRegion(
        OfflineRegionDefinition(
          bounds: offlineBoundsFor(zoneBounds),
          mapStyleUrl: offlineStyleUrl,
          minZoom: offlineMinZoom.toDouble(),
          maxZoom: offlineMaxZoom.toDouble(),
        ),
        metadata: {_zoneIdKey: zoneId, 'name': zoneName},
        onEvent: (event) => _onEvent(zoneId, event),
      );
      // Success may arrive before we know the region id: fill it in.
      final current = state[zoneId];
      if (current is OfflineMapReady && current.regionId < 0) {
        _set(zoneId, OfflineMapReady(region.id, current.bytes));
      }
    } catch (e) {
      _set(zoneId, OfflineMapFailed(e.toString()));
    }
  }

  void _onEvent(String zoneId, DownloadRegionStatus event) {
    switch (event) {
      case InProgress():
        final required = event.requiredResourceCount;
        final progress = required == 0
            ? 0.0
            : event.completedResourceCount / required;
        _set(zoneId, OfflineMapDownloading(progress, event.completedResourceSize));
      case Success():
        unawaited(_markReady(zoneId));
      case Error():
        _set(zoneId, OfflineMapFailed(event.cause.code));
    }
  }

  Future<void> _markReady(String zoneId) async {
    final region = await _regionFor(zoneId);
    if (region == null) {
      _set(zoneId, const OfflineMapReady(-1, 0));
      return;
    }
    final status = await getOfflineRegionStatus(region.id);
    _set(zoneId, OfflineMapReady(region.id, status.completedResourceSize));
  }

  /// Deletes the downloaded map of a zone, if any.
  Future<void> delete(String zoneId) async {
    final region = await _regionFor(zoneId);
    if (region != null) await deleteOfflineRegion(region.id);
    state = {...state}..remove(zoneId);
  }

  Future<OfflineRegion?> _regionFor(String zoneId) async {
    for (final region in await getListOfRegions()) {
      if (region.metadata[_zoneIdKey] == zoneId) return region;
    }
    return null;
  }

  void _set(String zoneId, OfflineMapState value) {
    state = {...state, zoneId: value};
  }
}

final offlineMapsProvider =
    NotifierProvider<OfflineMapsNotifier, Map<String, OfflineMapState>>(
  OfflineMapsNotifier.new,
);
