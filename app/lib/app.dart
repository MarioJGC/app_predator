import 'package:material_ui/material_ui.dart';

import 'core/theme/app_theme.dart';
import 'features/home/home_shell.dart';
import 'l10n/generated/app_localizations.dart';

/// Spanish is the default language (PRD RNF-09).
const fallbackLocale = Locale('es');

class HunterApp extends StatelessWidget {
  const HunterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // Phone language if we support it; Spanish otherwise.
      localeResolutionCallback: (locale, supported) => supported.firstWhere(
        (l) => l.languageCode == locale?.languageCode,
        orElse: () => fallbackLocale,
      ),
      // Respect the phone text size, up to 1.5x (PRD RNF-02).
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: AppTheme.maxTextScale,
        child: child!,
      ),
      home: const HomeShell(),
    );
  }
}
