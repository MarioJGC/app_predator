import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/location/location_service.dart';
import '../../../core/map/map_layers.dart';
import '../../../core/widgets/instruction_banner.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/zones_repository.dart';
import '../domain/zone.dart';
import 'zone_labels.dart';
import 'zone_map_layer.dart';

/// Adds a point by moving the map under a fixed cross.
/// Easier than tapping an exact spot with big fingers or gloves.
class AddPointScreen extends ConsumerStatefulWidget {
  const AddPointScreen({super.key, required this.zone});

  final Zone zone;

  @override
  ConsumerState<AddPointScreen> createState() => _AddPointScreenState();
}

class _AddPointScreenState extends ConsumerState<AddPointScreen> {
  MapLibreMapController? _controller;
  final _name = TextEditingController();
  PointKind _kind = PointKind.stand;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _onStyleLoaded() async {
    final controller = _controller!;
    await fitZone(controller, widget.zone);
    final points = ref.read(zonePointsProvider(widget.zone.id)).value ?? const [];
    await drawZones(controller, zones: [widget.zone], points: points);
  }

  Future<void> _save() async {
    final target = _controller?.cameraPosition?.target;
    if (target == null) return;
    setState(() => _saving = true);
    await ref.read(zonesRepositoryProvider).addPoint(
          zoneId: widget.zone.id,
          kind: _kind,
          position: target,
          name: _name.text,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layer = ref.watch(mapLayerProvider);
    final hasLocation = ref.watch(locationPermissionProvider).value ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addPoint)),
      body: Column(
        children: [
          InstructionBanner(text: l10n.addPointInstructions),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                MapLibreMap(
                  styleString: layer.styleAsset,
                  initialCameraPosition:
                      CameraPosition(target: widget.zone.center, zoom: 15),
                  onMapCreated: (c) => _controller = c,
                  onStyleLoadedCallback: _onStyleLoaded,
                  trackCameraPosition: true,
                  myLocationEnabled: hasLocation,
                ),
                // Fixed cross in the centre: the point goes here.
                IgnorePointer(
                  child: Icon(
                    Icons.add,
                    size: 64,
                    color: ZoneColors.pointColor(_kind),
                    shadows: const [Shadow(color: Colors.white, blurRadius: 6)],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final kind in PointKind.values)
                        ChoiceChip(
                          avatar: Icon(pointKindIcon(kind)),
                          label: Text(l10n.pointKind(kind)),
                          selected: _kind == kind,
                          onSelected: (_) => setState(() => _kind = kind),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: l10n.pointName,
                      hintText: l10n.pointNameHint,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LargeButton(
                    icon: Icons.check,
                    label: l10n.savePointHere,
                    onPressed: _saving ? null : _save,
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
