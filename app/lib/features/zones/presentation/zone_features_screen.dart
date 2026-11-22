import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/app_keys.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/zones_repository.dart';
import '../domain/zone.dart';
import '../domain/zone_features.dart';
import 'zone_labels.dart';

/// Edits what is in a zone: animals, food & water, danger, bedding & paths.
class ZoneFeaturesScreen extends ConsumerStatefulWidget {
  const ZoneFeaturesScreen({super.key, required this.zone});

  final Zone zone;

  @override
  ConsumerState<ZoneFeaturesScreen> createState() => _ZoneFeaturesScreenState();
}

class _ZoneFeaturesScreenState extends ConsumerState<ZoneFeaturesScreen> {
  late final Set<String> _animals = {...widget.zone.features.animals};
  late final Set<String> _foodWater = {...widget.zone.features.foodWater};
  late final Set<String> _dangers = {...widget.zone.features.dangers};
  late final Set<String> _signs = {...widget.zone.features.wildlifeSigns};
  late DangerLevel _dangerLevel = widget.zone.features.dangerLevel;
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    await ref.read(zonesRepositoryProvider).updateFeatures(
          widget.zone.id,
          ZoneFeatures(
            animals: _animals,
            foodWater: _foodWater,
            dangerLevel: _dangerLevel,
            // Danger types only make sense with a danger level.
            dangers: _dangerLevel == DangerLevel.none ? const {} : _dangers,
            wildlifeSigns: _signs,
          ),
        );
    navigator.pop();
    showAppMessage(l10n.featuresSaved);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.zone.name)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          _Section(
            icon: Icons.pets,
            title: l10n.featAnimals,
            child: _MultiChips(
              keys: huntingSpecies,
              selected: _animals,
              label: l10n.speciesName,
              onChanged: () => setState(() {}),
            ),
          ),
          _Section(
            icon: Icons.water_drop,
            title: l10n.featFoodWater,
            child: _MultiChips(
              keys: foodWaterTypes,
              selected: _foodWater,
              label: l10n.foodWaterName,
              onChanged: () => setState(() {}),
            ),
          ),
          _Section(
            icon: Icons.warning_amber,
            title: l10n.featDanger,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.featDangerLevel),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final level in DangerLevel.values)
                      ChoiceChip(
                        avatar: CircleAvatar(backgroundColor: ZoneColors.dangerColor(level)),
                        label: Text(l10n.dangerLevelName(level)),
                        selected: _dangerLevel == level,
                        onSelected: (_) => setState(() => _dangerLevel = level),
                      ),
                  ],
                ),
                if (_dangerLevel != DangerLevel.none) ...[
                  const SizedBox(height: 16),
                  Text(l10n.featDangerTypes),
                  const SizedBox(height: 8),
                  _MultiChips(
                    keys: dangerTypes,
                    selected: _dangers,
                    label: l10n.dangerTypeName,
                    onChanged: () => setState(() {}),
                  ),
                ],
              ],
            ),
          ),
          _Section(
            icon: Icons.bedtime,
            title: l10n.featSigns,
            child: _MultiChips(
              keys: wildlifeSignTypes,
              selected: _signs,
              label: l10n.wildlifeSignName,
              onChanged: () => setState(() {}),
            ),
          ),
          const SizedBox(height: 8),
          LargeButton(
            icon: Icons.save,
            label: l10n.save,
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.title, required this.child});

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

/// Chips where several options can be on at the same time.
class _MultiChips extends StatelessWidget {
  const _MultiChips({
    required this.keys,
    required this.selected,
    required this.label,
    required this.onChanged,
  });

  final List<String> keys;
  final Set<String> selected;
  final String Function(String key) label;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final key in keys)
          FilterChip(
            label: Text(label(key)),
            selected: selected.contains(key),
            onSelected: (on) {
              on ? selected.add(key) : selected.remove(key);
              onChanged();
            },
          ),
      ],
    );
  }
}
