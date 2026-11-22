import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'zone_map_layer.dart';

/// Step 1 of creating an area: tap the map to place the corners.
/// With [parent], draws a subzone that must stay inside that zone.
class DrawAreaScreen extends ConsumerStatefulWidget {
  const DrawAreaScreen({super.key, required this.initialCamera, this.parent});

  final CameraPosition initialCamera;
  final Zone? parent;

  @override
  ConsumerState<DrawAreaScreen> createState() => _DrawAreaScreenState();
}

class _DrawAreaScreenState extends ConsumerState<DrawAreaScreen> {
  MapLibreMapController? _controller;
  final List<LatLng> _corners = [];

  void _warn(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _addCorner(Point<double> _, LatLng position) {
    final l10n = AppLocalizations.of(context);
    final parent = widget.parent;
    if (parent != null && !GeoUtils.contains(parent.geometry, position)) {
      _warn(l10n.subzoneOutside(parent.name));
      return;
    }
    // No limit of corners, but sides must not cross (no "bow ties").
    if (GeoUtils.wouldCross(_corners, position)) {
      _warn(l10n.crossingNotAllowed);
      return;
    }
    setState(() => _corners.add(position));
    _redraw();
  }

  void _undo() {
    if (_corners.isEmpty) return;
    setState(() => _corners.removeLast());
    _redraw();
  }

  Future<void> _redraw() async {
    final controller = _controller;
    if (controller == null) return;
    await drawDraft(controller, _corners, closed: true, parent: widget.parent);
  }

  Future<void> _onStyleLoaded() async {
    final parent = widget.parent;
    if (parent != null) await fitZone(_controller!, parent);
    await _redraw();
  }

  void _next() {
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => ZoneFormScreen.create(
        kind: ZoneKind.area,
        geometry: List.of(_corners),
        parentId: widget.parent?.id,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layer = ref.watch(mapLayerProvider);
    final hasLocation = ref.watch(locationPermissionProvider).value ?? false;
    final parent = widget.parent;

    return Scaffold(
      appBar: AppBar(title: Text(parent == null ? l10n.drawArea : l10n.drawSubzone)),
      body: Column(
        children: [
          InstructionBanner(
            text: parent == null
                ? l10n.drawAreaInstructions
                : l10n.subzoneInstructions(parent.name),
          ),
          Expanded(
            child: MapLibreMap(
              styleString: layer.styleAsset,
              initialCameraPosition: widget.initialCamera,
              onMapCreated: (c) => _controller = c,
              onStyleLoadedCallback: _onStyleLoaded,
              onMapClick: _addCorner,
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
                    child: LargeButton(
                      icon: Icons.undo,
                      label: l10n.undo,
                      primary: false,
                      onPressed: _corners.isEmpty ? null : _undo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LargeButton(
                      icon: Icons.arrow_forward,
                      label: l10n.next,
                      onPressed: _corners.length >= 3 ? _next : null,
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
