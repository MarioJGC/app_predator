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

  @override
  String get newZone => 'New area';

  @override
  String get newZoneQuestion => 'What do you want to create?';

  @override
  String get drawArea => 'Draw an area';

  @override
  String get drawAreaHint => 'To mark an estate or hunting ground on the map.';

  @override
  String get recordRoute => 'Record a route';

  @override
  String get recordRouteHint => 'Walk and the app saves the path with GPS.';

  @override
  String get drawAreaInstructions =>
      'Tap the map to mark the corners of the area.';

  @override
  String get undo => 'Undo';

  @override
  String get next => 'Next';

  @override
  String get startRecording => 'Start recording';

  @override
  String get stopRecording => 'Stop';

  @override
  String get recordRouteInstructions =>
      'Press \"Start recording\" and walk the route.';

  @override
  String get recordingInfo => 'Recording… Keep the app open and the screen on.';

  @override
  String distance(String distance) {
    return 'Distance: $distance';
  }

  @override
  String get zoneName => 'Name';

  @override
  String get zoneNameHint => 'E.g.: Los Robles estate';

  @override
  String get zoneNameRequired => 'Enter a name';

  @override
  String get zoneDescription => 'Description (optional)';

  @override
  String get species => 'Species';

  @override
  String get modality => 'Hunting type';

  @override
  String get zoneDetails => 'Area details';

  @override
  String get editZone => 'Edit details';

  @override
  String get deleteZone => 'Delete area';

  @override
  String deleteZoneQuestion(String name) {
    return 'Delete the area \"$name\"?';
  }

  @override
  String get deleteZoneMessage => 'Its points will also be deleted.';

  @override
  String get addPoint => 'Add point';

  @override
  String get addPointInstructions =>
      'Move the map until the cross is over the place.';

  @override
  String get pointType => 'Point type';

  @override
  String get pointName => 'Name or number (optional)';

  @override
  String get pointNameHint => 'E.g.: 7';

  @override
  String get savePointHere => 'Save point here';

  @override
  String pointsTitle(int count) {
    return 'Points ($count)';
  }

  @override
  String get noPoints => 'This area has no points yet.';

  @override
  String get deletePointQuestion => 'Delete this point?';

  @override
  String get directions => 'Directions';

  @override
  String get directionsError => 'Couldn\'t open the maps app.';

  @override
  String get zoneKindArea => 'Area';

  @override
  String get zoneKindRoute => 'Route';

  @override
  String get pointStand => 'Stand';

  @override
  String get pointParking => 'Parking';

  @override
  String get pointFeeder => 'Feeder';

  @override
  String get pointDanger => 'Danger';

  @override
  String get pointOther => 'Other';

  @override
  String get speciesWildBoar => 'Wild boar';

  @override
  String get speciesRedDeer => 'Red deer';

  @override
  String get speciesRoeDeer => 'Roe deer';

  @override
  String get speciesFallowDeer => 'Fallow deer';

  @override
  String get speciesMouflon => 'Mouflon';

  @override
  String get speciesIbex => 'Iberian ibex';

  @override
  String get speciesPartridge => 'Partridge';

  @override
  String get speciesRabbit => 'Rabbit';

  @override
  String get speciesHare => 'Hare';

  @override
  String get speciesQuail => 'Quail';

  @override
  String get speciesPigeon => 'Pigeon';

  @override
  String get speciesFox => 'Fox';

  @override
  String get modalityMonteria => 'Driven hunt (montería)';

  @override
  String get modalityBatida => 'Beat (batida)';

  @override
  String get modalityStalking => 'Stalking';

  @override
  String get modalityWaiting => 'Waiting hunt';

  @override
  String get modalitySmallGame => 'Small game';

  @override
  String get modalityOther => 'Other';

  @override
  String get zoneSaved => 'Area saved';

  @override
  String get zoneNotFound => 'This area no longer exists.';

  @override
  String downloadMap(String size) {
    return 'Download map ($size)';
  }

  @override
  String get downloadMapHint => 'To see it without signal in the field.';

  @override
  String downloadingMap(int percent) {
    return 'Downloading map… $percent%';
  }

  @override
  String mapDownloaded(String size) {
    return 'Map downloaded ($size)';
  }

  @override
  String get mapDownloadFailed =>
      'Couldn\'t download the map. Check your connection.';

  @override
  String get retry => 'Try again';

  @override
  String get deleteMap => 'Delete downloaded map';

  @override
  String deleteMapQuestion(String name) {
    return 'Delete the downloaded map of \"$name\"?';
  }

  @override
  String get offlineMaps => 'Downloaded maps';

  @override
  String get offlineMapsEmpty => 'You don\'t have any downloaded maps.';

  @override
  String get offlineMapsHint => 'Download the map from each area\'s page.';

  @override
  String offlineMapsTotal(String size) {
    return 'Space used: $size';
  }

  @override
  String get liveHunt => 'Group hunt';

  @override
  String get myCaptures => 'My game';

  @override
  String get newCapture => 'Log game';

  @override
  String get capturesEmpty => 'You haven\'t logged any game yet.';

  @override
  String get captureSpecies => 'Which species?';

  @override
  String get captureCount => 'How many';

  @override
  String get less => 'Less';

  @override
  String get more => 'More';

  @override
  String get takePhoto => 'Take photo (optional)';

  @override
  String get retakePhoto => 'Retake photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get captureNotes => 'Notes (optional)';

  @override
  String get gettingLocation => 'Finding your location…';

  @override
  String get locationSaved => 'The place where you are now will be saved.';

  @override
  String get locationNotAvailable => 'No location: GPS could not be used.';

  @override
  String get captureSaved => 'Game logged';

  @override
  String captureTitle(String species, int count) {
    return '$species × $count';
  }

  @override
  String get deleteCapture => 'Delete entry';

  @override
  String get deleteCaptureQuestion => 'Delete this entry?';

  @override
  String get captureNotFound => 'This entry no longer exists.';

  @override
  String get photoError => 'Couldn\'t save the photo.';

  @override
  String get labelType => 'Type';

  @override
  String get labelSize => 'Size';

  @override
  String get labelDescription => 'Description';

  @override
  String get labelDate => 'Date';

  @override
  String get labelLocation => 'Location';

  @override
  String get labelNotes => 'Notes';

  @override
  String get view => 'View';

  @override
  String mapReadyNotice(String name) {
    return 'Map of \"$name\" downloaded. You can now see it without signal.';
  }

  @override
  String mapFailedNotice(String name) {
    return 'Couldn\'t download the map of \"$name\".';
  }
}
