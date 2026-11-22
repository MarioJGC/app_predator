import 'package:material_ui/material_ui.dart';

/// Accessible theme for older users and outdoor use (PRD RNF-02):
/// big text (18 pt base), big touch targets (56 px) and high contrast.
abstract final class AppTheme {
  /// Minimum height of any button or tappable row.
  static const double minTouchSize = 56;

  /// Maximum text scale allowed from the phone settings.
  static const double maxTextScale = 1.5;

  static const Color _seed = Color(0xFF4E6B2F); // Olive green.

  /// Designed for readers with low vision (bundled in assets/fonts).
  static const String fontFamily = 'AtkinsonHyperlegible';

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: _seed);
    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: fontFamily,
    );
    final text = base.textTheme;

    // fontFamily must be repeated: button styles don't inherit it.
    const buttonText = TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
    const buttonSize = Size(64, minTouchSize);
    const buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    return base.copyWith(
      textTheme: text.copyWith(
        headlineSmall: text.headlineSmall?.copyWith(fontSize: 26, fontWeight: FontWeight.w700),
        titleLarge: text.titleLarge?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
        titleMedium: text.titleMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
        bodyLarge: text.bodyLarge?.copyWith(fontSize: 18),
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 18),
        labelLarge: text.labelLarge?.copyWith(fontSize: 18),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          padding: buttonPadding,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          padding: buttonPadding,
          textStyle: buttonText,
          side: BorderSide(color: scheme.outline, width: 2),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonSize,
          textStyle: buttonText,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(minTouchSize, minTouchSize),
          iconSize: 28,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        sizeConstraints: BoxConstraints.tightFor(width: 64, height: 64),
        iconSize: 30,
        extendedTextStyle: buttonText,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStatePropertyAll(
          text.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        iconTheme: const WidgetStatePropertyAll(IconThemeData(size: 30)),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 12,
        // Colors must be explicit: a TextStyle without color renders white.
        titleTextStyle: text.titleMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        subtitleTextStyle: text.bodyMedium?.copyWith(
          fontSize: 16,
          color: scheme.onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(16),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(fontSize: 18),
      ),
    );
  }
}
