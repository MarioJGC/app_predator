import 'package:material_ui/material_ui.dart';

/// Coloured strip with a short instruction, shown above a map.
class InstructionBanner extends StatelessWidget {
  const InstructionBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: scheme.secondaryContainer,
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: scheme.onSecondaryContainer),
      ),
    );
  }
}
