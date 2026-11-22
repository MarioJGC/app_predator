import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/location/location_service.dart';
import '../../../core/map/map_layers.dart';
import '../../../core/widgets/instruction_banner.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/zone.dart';
import 'zone_form_screen.dart';
import 'zone_map_layer.dart';

/// Step 1 of creating an area: tap the map to place the corners.
class DrawAreaScreen extends ConsumerStatefulWidget {
  const DrawAreaScreen({super.key, required this.initialCamera});

  final CameraPosition initialCamera;

  @override
  ConsumerState<DrawAreaScreen> createState() => _DrawAreaScreenState();
}

class _DrawAreaScreenState extends ConsumerState<DrawAreaScreen> {
  MapLibreMapController? _controller;
  final List<LatLng> _corners = [];

  void _addCorner(Point<double> _, LatLng position) {
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
    await drawDraft(controller, _corners, closed: true);
  }

  void _next() {
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => ZoneFormScreen.create(
        kind: ZoneKind.area,
        geometry: List.of(_corners),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layer = ref.watch(mapLayerProvider);
    final hasLocation = ref.watch(locationPermissionProvider).value ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.drawArea)),
      body: Column(
        children: [
          InstructionBanner(text: l10n.drawAreaInstructions),
          Expanded(
            child: MapLibreMap(
              styleString: layer.styleAsset,
              initialCameraPosition: widget.initialCamera,
              onMapCreated: (c) => _controller = c,
              onStyleLoadedCallback: _redraw,
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
