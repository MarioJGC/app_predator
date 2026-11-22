import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/zones_repository.dart';
import '../domain/zone.dart';
import 'zone_detail_screen.dart';
import 'zone_labels.dart';

/// Name, species, modality and description of a zone.
/// Used for new zones (after drawing) and for editing existing ones.
class ZoneFormScreen extends ConsumerStatefulWidget {
  /// New zone: saves it and opens its detail screen.
  const ZoneFormScreen.create({
    super.key,
    required ZoneKind this.kind,
    required List<LatLng> this.geometry,
    this.parentId,
  }) : existing = null;

  /// Existing zone: saves the changes and goes back.
  const ZoneFormScreen.edit({super.key, required Zone this.existing})
      : kind = null,
        geometry = null,
        parentId = null;

  final ZoneKind? kind;

  /// Set when creating a subzone.
  final String? parentId;
  final List<LatLng>? geometry;
  final Zone? existing;

  @override
  ConsumerState<ZoneFormScreen> createState() => _ZoneFormScreenState();
}

class _ZoneFormScreenState extends ConsumerState<ZoneFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final Set<String> _species;
  String? _modality;
  bool _saving = false;

  bool get _isSubzone => widget.parentId != null || (widget.existing?.isSubzone ?? false);

  @override
  void initState() {
    super.initState();
    final zone = widget.existing;
    _name = TextEditingController(text: zone?.name);
    _description = TextEditingController(text: zone?.description);
    _species = {...?zone?.species};
    _modality = zone?.modality;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final repo = ref.read(zonesRepositoryProvider);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final species = huntingSpecies.where(_species.contains).toList();

    final existing = widget.existing;
    if (existing != null) {
      await repo.updateZoneDetails(
        existing.id,
        name: _name.text,
        description: _description.text,
        species: species,
        modality: _modality,
      );
      navigator.pop();
    } else {
      final id = await repo.createZone(
        name: _name.text,
        kind: widget.kind!,
        geometry: widget.geometry!,
        description: _description.text,
        species: species,
        modality: _modality,
        parentId: widget.parentId,
      );
      navigator.pushReplacement(MaterialPageRoute<void>(
        builder: (_) => ZoneDetailScreen(zoneId: id),
      ));
    }
    messenger.showSnackBar(SnackBar(content: Text(l10n.zoneSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.zoneDetails)),
      body: Form(
        key: _formKey,
        child: ListView(
          // Extra bottom space: Android's navigation bar covers the screen edge.
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.viewPaddingOf(context).bottom),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.zoneName,
                hintText: l10n.zoneNameHint,
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? l10n.zoneNameRequired : null,
            ),
            // Subzones note animals in "What's here", not here.
            if (!_isSubzone) ...[
            const SizedBox(height: 24),
            Text(l10n.species, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final key in huntingSpecies)
                  FilterChip(
                    label: Text(l10n.speciesName(key)),
                    selected: _species.contains(key),
                    onSelected: (selected) => setState(() {
                      selected ? _species.add(key) : _species.remove(key);
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(l10n.modality, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final key in huntingModalities)
                  ChoiceChip(
                    label: Text(l10n.modalityName(key)),
                    selected: _modality == key,
                    onSelected: (selected) =>
                        setState(() => _modality = selected ? key : null),
                  ),
              ],
            ),
            ],
            const SizedBox(height: 24),
            TextFormField(
              controller: _description,
              textCapitalization: TextCapitalization.sentences,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(labelText: l10n.zoneDescription),
            ),
            const SizedBox(height: 32),
            LargeButton(
              icon: Icons.save,
              label: l10n.save,
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
