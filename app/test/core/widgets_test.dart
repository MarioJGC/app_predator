import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/core/widgets/large_button.dart';
import 'package:app/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Wraps a widget with the real theme and translations.
Widget testApp(Widget child, {Locale locale = const Locale('es')}) {
  return MaterialApp(
    theme: AppTheme.light(),
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('LargeButton is at least 56 px high', (tester) async {
    await tester.pumpWidget(testApp(
      LargeButton(icon: Icons.add, label: 'Test', onPressed: () {}),
    ));

    final size = tester.getSize(find.byType(FilledButton));
    expect(size.height, greaterThanOrEqualTo(AppTheme.minTouchSize));
  });

  testWidgets('Confirm dialog returns true on "Sí"', (tester) async {
    bool? answer;
    await tester.pumpWidget(testApp(Builder(
      builder: (context) => TextButton(
        onPressed: () async {
          answer = await showConfirmDialog(context, title: '¿Borrar?');
        },
        child: const Text('open'),
      ),
    )));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sí'));
    await tester.pumpAndSettle();

    expect(answer, isTrue);
  });

  testWidgets('Confirm dialog shows English labels', (tester) async {
    await tester.pumpWidget(testApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showConfirmDialog(context, title: 'Delete?'),
          child: const Text('open'),
        ),
      ),
      locale: const Locale('en'),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
  });
}
