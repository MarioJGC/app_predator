import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/info_row.dart';
import '../../../core/widgets/info_view.dart';
import '../../../core/widgets/large_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../zones/presentation/zone_labels.dart';
import '../data/captures_repository.dart';
import '../data/photo_storage.dart';
import '../domain/capture.dart';

/// "Jabalí × 2", in the user's language.
String captureTitle(AppLocalizations l10n, Capture capture) =>
    l10n.captureTitle(l10n.speciesName(capture.species), capture.count);

/// "22 de noviembre de 2026, 14:20".
String captureDate(AppLocalizations l10n, Capture capture) =>
    DateFormat.yMMMMd(l10n.localeName).add_Hm().format(capture.takenAt);

class CaptureDetailScreen extends ConsumerWidget {
  const CaptureDetailScreen({super.key, required this.captureId});

  final String captureId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final capture = ref.watch(captureProvider(captureId)).value;

    if (capture == null) {
      return Scaffold(
        appBar: AppBar(),
        body: InfoView(icon: Icons.search_off, title: l10n.captureNotFound),
      );
    }

    final position = capture.position;
    return Scaffold(
      appBar: AppBar(title: Text(captureTitle(l10n, capture))),
      body: ListView(
        // Extra bottom space: Android's navigation bar covers the screen edge.
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          if (capture.photoPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(capture.photoPath!),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          const SizedBox(height: 16),
          InfoRow(icon: Icons.event, label: l10n.labelDate, value: captureDate(l10n, capture)),
          InfoRow(
            icon: position != null ? Icons.location_on : Icons.location_off,
            label: l10n.labelLocation,
            value: position != null
                ? '${position.latitude.toStringAsFixed(5)}, '
                    '${position.longitude.toStringAsFixed(5)}'
                : l10n.locationNotAvailable,
          ),
          if (capture.notes != null)
            InfoRow(icon: Icons.notes, label: l10n.labelNotes, value: capture.notes!),
          const SizedBox(height: 24),
          LargeButton(
            icon: Icons.delete_outline,
            label: l10n.deleteCapture,
            primary: false,
            destructive: true,
            onPressed: () async {
              final navigator = Navigator.of(context);
              final confirmed = await showConfirmDialog(
                context,
                title: l10n.deleteCaptureQuestion,
                destructive: true,
              );
              if (!confirmed) return;
              await ref.read(capturesRepositoryProvider).deleteCapture(capture.id);
              await ref.read(photoStorageProvider).delete(capture.photoPath);
              navigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
