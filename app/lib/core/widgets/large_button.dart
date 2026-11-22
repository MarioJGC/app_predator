import 'package:material_ui/material_ui.dart';

/// Full-width button with icon and text, at least 56 px high.
/// The main building block of the UI: no icon-only actions for main tasks.
class LargeButton extends StatelessWidget {
  const LargeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.primary = true,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  /// Filled (true) or outlined (false) style.
  final bool primary;

  /// Red colors, for delete actions.
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final iconWidget = Icon(icon, size: 28);
    final labelWidget = Text(label, textAlign: TextAlign.center);

    final Widget button;
    if (primary) {
      button = FilledButton.icon(
        onPressed: onPressed,
        icon: iconWidget,
        label: labelWidget,
        style: destructive
            ? FilledButton.styleFrom(
                backgroundColor: scheme.error,
                foregroundColor: scheme.onError,
              )
            : null,
      );
    } else {
      button = OutlinedButton.icon(
        onPressed: onPressed,
        icon: iconWidget,
        label: labelWidget,
        style: destructive
            ? OutlinedButton.styleFrom(
                foregroundColor: scheme.error,
                side: BorderSide(color: scheme.error, width: 2),
              )
            : null,
      );
    }
    return SizedBox(width: double.infinity, child: button);
  }
}
