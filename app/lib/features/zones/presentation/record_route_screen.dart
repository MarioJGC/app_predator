import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/geo/geo_utils.dart';
import '../../../core/location/location_service.dart';
import '../../../core/map/map_layers.dart';
import '../../../core/widgets/instruction_banner.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/zone.dart';
import 'zone_form_screen.dart';
import 'zone_labels.dart';
import 'zone_map_layer.dart';

/// Step 1 of creating a route: walk while the GPS records the track.
///
/// MVP limit: recording stops if the app goes to the background. A foreground
/// service (also needed for the live hunt) will fix this later.
class RecordRouteScreen extends ConsumerStatefulWidget {
  const RecordRouteScreen({super.key, required this.initialCamera});

  final CameraPosition initialCamera;

  @override
  ConsumerState<RecordRouteScreen> createState() => _RecordRouteScreenState();
}

class _RecordRouteScreenState extends ConsumerState<RecordRouteScreen> {
  MapLibreMapController? _controller;
  StreamSubscription<Position>? _subscription;
  final List<LatLng> _track = [];

  bool get _isRecording => _subscription != null;

  Future<void> _start() async {
    final service = ref.read(locationServiceProvider);
    if (!await service.ensurePermission()) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.locationDenied),
        action: SnackBarAction(label: l10n.openSettings, onPressed: service.openSettings),
      ));
      return;
    }
    ref.invalidate(locationPermissionProvider);
    setState(() {
      _subscription = service.positionStream().listen(_onPosition);
    });
  }

  void _onPosition(Position position) {
    final point = LatLng(position.latitude, position.longitude);
    setState(() => _track.add(point));
    _controller?.animateCamera(CameraUpdate.newLatLng(point));
    _redraw();
  }

  Future<void> _stop() async {
    await _subscription?.cancel();
    setState(() => _subscription = null);
  }

  Future<void> _redraw() async {
    final controller = _controller;
    if (controller == null) return;
    await drawDraft(controller, _track, closed: false);
  }

  /// Asks "route or area?": a track that doesn't end where it started can
  /// still become an area, joining the end with the start.
  Future<void> _next() async {
    final navigator = Navigator.of(context);
    var kind = ZoneKind.route;
    if (_track.length >= 3) {
      final chosen = await showModalBottomSheet<ZoneKind>(
        context: context,
        showDragHandle: true,
        builder: (context) => _RouteOrAreaSheet(),
      );
      if (chosen == null) return;
      kind = chosen;
    }
    navigator.pushReplacement(MaterialPageRoute<void>(
      builder: (_) => ZoneFormScreen.create(kind: kind, geometry: List.of(_track)),
    ));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layer = ref.watch(mapLayerProvider);
    final hasLocation = ref.watch(locationPermissionProvider).value ?? false;
    final distance = l10n.formatDistance(GeoUtils.lengthMeters(_track));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recordRoute)),
      body: Column(
        children: [
          InstructionBanner(
            text: _isRecording
                ? '${l10n.recordingInfo}\n${l10n.distance(distance)}'
                : l10n.recordRouteInstructions,
          ),
          Expanded(
            child: MapLibreMap(
              styleString: layer.styleAsset,
              initialCameraPosition: widget.initialCamera,
              onMapCreated: (c) => _controller = c,
              onStyleLoadedCallback: _redraw,
              myLocationEnabled: hasLocation,
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _isRecording
                        ? LargeButton(
                            icon: Icons.stop,
                            label: l10n.stopRecording,
                            destructive: true,
                            onPressed: _stop,
                          )
                        : LargeButton(
                            icon: Icons.fiber_manual_record,
                            label: l10n.startRecording,
                            primary: _track.isEmpty,
                            onPressed: _start,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LargeButton(
                      icon: Icons.arrow_forward,
                      label: l10n.next,
                      onPressed: !_isRecording && _track.length >= 2 ? _next : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteOrAreaSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.routeSaveQuestion, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            LargeButton(
              icon: Icons.timeline,
              label: l10n.saveAsRoute,
              onPressed: () => Navigator.of(context).pop(ZoneKind.route),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              child: Text(l10n.saveAsRouteHint, textAlign: TextAlign.center),
            ),
            LargeButton(
              icon: Icons.crop_square,
              label: l10n.closeAsArea,
              primary: false,
              onPressed: () => Navigator.of(context).pop(ZoneKind.area),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(l10n.closeAsAreaHint, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
