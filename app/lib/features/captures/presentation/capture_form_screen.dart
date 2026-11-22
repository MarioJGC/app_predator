import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/app_keys.dart';
import '../../../core/location/location_service.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../zones/domain/zone.dart' show huntingSpecies;
import '../../zones/presentation/zone_labels.dart';
import '../data/captures_repository.dart';
import '../data/photo_storage.dart';
import 'capture_detail_screen.dart';

/// Logs a capture: species, how many, optional photo. Position is automatic.
class CaptureFormScreen extends ConsumerStatefulWidget {
  const CaptureFormScreen({super.key});

  @override
  ConsumerState<CaptureFormScreen> createState() => _CaptureFormScreenState();
}

class _CaptureFormScreenState extends ConsumerState<CaptureFormScreen> {
  final _notes = TextEditingController();
  String? _species;
  int _count = 1;
  String? _photoPath;
  LatLng? _position;
  bool _locating = true;
  bool _saving = false;
  bool _saved = false;

  /// Kept here because `ref` can't be used in dispose().
  late final PhotoStorage _storage;

  @override
  void initState() {
    super.initState();
    _storage = ref.read(photoStorageProvider);
    _locate();
  }

  Future<void> _locate() async {
    final result = await ref.read(locationServiceProvider).currentPosition();
    if (!mounted) return;
    setState(() {
      _locating = false;
      if (result case LocationFound(:final position)) {
        _position = LatLng(position.latitude, position.longitude);
      }
    });
  }

  Future<void> _takePhoto() async {
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).photoError;
    try {
      final path = await _storage.takePhoto();
      if (path == null || !mounted) return;
      await _storage.delete(_photoPath); // Replace the previous one.
      setState(() => _photoPath = path);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _removePhoto() async {
    await _storage.delete(_photoPath);
    setState(() => _photoPath = null);
  }

  Future<void> _save() async {
    final species = _species;
    if (species == null) return;
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final l10n = AppLocalizations.of(context);

    final id = await ref.read(capturesRepositoryProvider).createCapture(
          species: species,
          count: _count,
          photoPath: _photoPath,
          position: _position,
          notes: _notes.text,
        );
    _saved = true;
    navigator.pop();
    showAppMessage(
      l10n.captureSaved,
      actionLabel: l10n.view,
      onAction: () => openScreen(CaptureDetailScreen(captureId: id)),
    );
  }

  @override
  void dispose() {
    // Leaving without saving: don't keep an orphan photo.
    if (!_saved) _storage.delete(_photoPath);
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.newCapture)),
      body: ListView(
        // Extra bottom space: Android's navigation bar covers the screen edge.
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          Text(l10n.captureSpecies, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final key in huntingSpecies)
                ChoiceChip(
                  label: Text(l10n.speciesName(key)),
                  selected: _species == key,
                  onSelected: (_) => setState(() => _species = key),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.captureCount, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: l10n.less,
                iconSize: 32,
                onPressed: _count > 1 ? () => setState(() => _count--) : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  '$_count',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium,
                ),
              ),
              IconButton.filledTonal(
                tooltip: l10n.more,
                iconSize: 32,
                onPressed: () => setState(() => _count++),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_photoPath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(_photoPath!), height: 220, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LargeButton(
                    icon: Icons.photo_camera,
                    label: l10n.retakePhoto,
                    primary: false,
                    onPressed: _takePhoto,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LargeButton(
                    icon: Icons.delete_outline,
                    label: l10n.removePhoto,
                    primary: false,
                    destructive: true,
                    onPressed: _removePhoto,
                  ),
                ),
              ],
            ),
          ] else
            LargeButton(
              icon: Icons.photo_camera,
              label: l10n.takePhoto,
              primary: false,
              onPressed: _takePhoto,
            ),
          const SizedBox(height: 24),
          TextField(
            controller: _notes,
            textCapitalization: TextCapitalization.sentences,
            minLines: 1,
            maxLines: 4,
            decoration: InputDecoration(labelText: l10n.captureNotes),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(_position != null ? Icons.location_on : Icons.location_off),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _locating
                      ? l10n.gettingLocation
                      : _position != null
                          ? l10n.locationSaved
                          : l10n.locationNotAvailable,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LargeButton(
            icon: Icons.save,
            label: l10n.save,
            onPressed: _species == null || _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}
