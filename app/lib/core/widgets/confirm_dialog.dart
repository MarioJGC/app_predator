import 'package:material_ui/material_ui.dart';

import '../../l10n/generated/app_localizations.dart';
import 'large_button.dart';

/// Asks a yes/no question with two big buttons (PRD RNF-03).
/// Returns true only if the user taps "Yes".
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  bool destructive = false,
}) async {
  final l10n = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actionsOverflowDirection: VerticalDirection.up,
      actions: [
        LargeButton(
          icon: Icons.check,
          label: l10n.yes,
          destructive: destructive,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        const SizedBox(height: 12),
        LargeButton(
          icon: Icons.close,
          label: l10n.no,
          primary: false,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    ),
  );
  return result ?? false;
}
