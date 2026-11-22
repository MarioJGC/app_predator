import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/generated/app_localizations.dart';
import '../captures/data/captures_repository.dart';
import '../captures/domain/capture.dart';
import '../captures/presentation/capture_detail_screen.dart';
import '../captures/presentation/capture_form_screen.dart';

/// Hunt day. For now: the user's captures. Group hunts need the backend.
class HuntTab extends ConsumerWidget {
  const HuntTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final captures = ref.watch(capturesProvider).value ?? const <Capture>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabHunt)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.groups, size: 40, color: theme.colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${l10n.liveHunt} · ${l10n.comingSoon}',
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(l10n.huntComingSoon),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(l10n.myCaptures, style: theme.textTheme.titleLarge),
          ),
          if (captures.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l10n.capturesEmpty),
            ),
          for (final capture in captures)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: _CaptureThumbnail(capture: capture),
              title: Text(captureTitle(l10n, capture)),
              subtitle: Text(captureDate(l10n, capture)),
              trailing: const Icon(Icons.chevron_right, size: 32),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => CaptureDetailScreen(captureId: capture.id),
              )),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'newCapture',
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const CaptureFormScreen(),
        )),
        icon: const Icon(Icons.add_a_photo),
        label: Text(l10n.newCapture),
      ),
    );
  }
}

class _CaptureThumbnail extends StatelessWidget {
  const _CaptureThumbnail({required this.capture});

  final Capture capture;

  @override
  Widget build(BuildContext context) {
    const size = 56.0;
    final path = capture.photoPath;
    final placeholder = CircleAvatar(radius: size / 2, child: const Icon(Icons.pets));
    if (path == null) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(path),
        width: size,
        height: size,
        fit: BoxFit.cover,
        cacheWidth: 168,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}
