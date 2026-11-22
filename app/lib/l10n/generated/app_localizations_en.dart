// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hunter App';

  @override
  String get tabMap => 'Map';

  @override
  String get tabZones => 'My areas';

  @override
  String get tabGroups => 'Groups';

  @override
  String get tabHunt => 'Hunt';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get layerOrthophoto => 'Satellite';

  @override
  String get layerTopographic => 'Topographic';

  @override
  String get changeMap => 'Change map';

  @override
  String get myLocation => 'My location';

  @override
  String get locationDenied =>
      'No location permission. Turn it on in the phone settings to see where you are.';

  @override
  String get locationUnavailable =>
      'Can\'t get your location. Check that GPS is on.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get groupsComingSoon =>
      'Here you will create your hunting group and invite other hunters. Available with user accounts.';

  @override
  String get huntComingSoon =>
      'Here you will organise hunts, assign stands and see your group on the map. Available with user accounts.';

  @override
  String get zonesEmpty => 'You don\'t have any areas yet.';
}
