import 'package:material_ui/material_ui.dart';

/// Lets background work (e.g. a finished map download) show a message and
/// open a screen, whatever screen the user is on at that moment.
final rootNavigatorKey = GlobalKey<NavigatorState>();
final rootMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Shows a message at the bottom. With [actionLabel] + [onAction] it gets a
/// button, e.g. "View" to open what was just saved.
void showAppMessage(String text, {String? actionLabel, VoidCallback? onAction}) {
  rootMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 6),
      action: actionLabel == null || onAction == null
          ? null
          : SnackBarAction(label: actionLabel, onPressed: onAction),
    ));
}

/// Opens a screen on top of the current one.
void openScreen(Widget screen) {
  rootNavigatorKey.currentState?.push(MaterialPageRoute<void>(builder: (_) => screen));
}
