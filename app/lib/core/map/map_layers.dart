import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base maps from IGN (Spanish National Geographic Institute).
enum MapLayer {
  /// PNOA orthophoto (satellite imagery).
  orthophoto('assets/map/pnoa_style.json'),

  /// MTN topographic map.
  topographic('assets/map/mtn_style.json');

  const MapLayer(this.styleAsset);

  /// Style file bundled with the app. Works without network.
  final String styleAsset;
}

/// Base map chosen by the user. Shared by every map in the app.
class MapLayerNotifier extends Notifier<MapLayer> {
  @override
  MapLayer build() => MapLayer.orthophoto;

  void toggle() {
    state = state == MapLayer.orthophoto
        ? MapLayer.topographic
        : MapLayer.orthophoto;
  }
}

final mapLayerProvider =
    NotifierProvider<MapLayerNotifier, MapLayer>(MapLayerNotifier.new);
