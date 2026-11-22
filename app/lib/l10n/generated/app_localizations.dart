import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'App Cazador'**
  String get appTitle;

  /// No description provided for @tabMap.
  ///
  /// In es, this message translates to:
  /// **'Mapa'**
  String get tabMap;

  /// No description provided for @tabZones.
  ///
  /// In es, this message translates to:
  /// **'Mis zonas'**
  String get tabZones;

  /// No description provided for @tabGroups.
  ///
  /// In es, this message translates to:
  /// **'Grupos'**
  String get tabGroups;

  /// No description provided for @tabHunt.
  ///
  /// In es, this message translates to:
  /// **'Jornada'**
  String get tabHunt;

  /// No description provided for @yes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @layerOrthophoto.
  ///
  /// In es, this message translates to:
  /// **'Satélite'**
  String get layerOrthophoto;

  /// No description provided for @layerTopographic.
  ///
  /// In es, this message translates to:
  /// **'Topográfico'**
  String get layerTopographic;

  /// No description provided for @changeMap.
  ///
  /// In es, this message translates to:
  /// **'Cambiar mapa'**
  String get changeMap;

  /// No description provided for @myLocation.
  ///
  /// In es, this message translates to:
  /// **'Mi ubicación'**
  String get myLocation;

  /// No description provided for @locationDenied.
  ///
  /// In es, this message translates to:
  /// **'Sin permiso de ubicación. Actívalo en los ajustes del móvil para ver dónde estás.'**
  String get locationDenied;

  /// No description provided for @locationUnavailable.
  ///
  /// In es, this message translates to:
  /// **'No se puede obtener tu ubicación. Comprueba que el GPS está activado.'**
  String get locationUnavailable;

  /// No description provided for @openSettings.
  ///
  /// In es, this message translates to:
  /// **'Abrir ajustes'**
  String get openSettings;

  /// No description provided for @comingSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get comingSoon;

  /// No description provided for @groupsComingSoon.
  ///
  /// In es, this message translates to:
  /// **'Aquí podrás crear tu cuadrilla e invitar a otros cazadores. Llegará con las cuentas de usuario.'**
  String get groupsComingSoon;

  /// No description provided for @huntComingSoon.
  ///
  /// In es, this message translates to:
  /// **'Aquí podrás organizar jornadas, asignar puestos y ver a tu grupo en el mapa. Llegará con las cuentas de usuario.'**
  String get huntComingSoon;

  /// No description provided for @zonesEmpty.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes zonas.'**
  String get zonesEmpty;

  /// No description provided for @newZone.
  ///
  /// In es, this message translates to:
  /// **'Nueva zona'**
  String get newZone;

  /// No description provided for @newZoneQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué quieres crear?'**
  String get newZoneQuestion;

  /// No description provided for @drawArea.
  ///
  /// In es, this message translates to:
  /// **'Dibujar un área'**
  String get drawArea;

  /// No description provided for @drawAreaHint.
  ///
  /// In es, this message translates to:
  /// **'Para marcar una finca o un coto en el mapa.'**
  String get drawAreaHint;

  /// No description provided for @recordRoute.
  ///
  /// In es, this message translates to:
  /// **'Grabar una ruta'**
  String get recordRoute;

  /// No description provided for @recordRouteHint.
  ///
  /// In es, this message translates to:
  /// **'Camina y la app guarda el camino con el GPS.'**
  String get recordRouteHint;

  /// No description provided for @drawAreaInstructions.
  ///
  /// In es, this message translates to:
  /// **'Toca el mapa para marcar las esquinas de la zona.'**
  String get drawAreaInstructions;

  /// No description provided for @undo.
  ///
  /// In es, this message translates to:
  /// **'Deshacer'**
  String get undo;

  /// No description provided for @next.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// No description provided for @startRecording.
  ///
  /// In es, this message translates to:
  /// **'Empezar a grabar'**
  String get startRecording;

  /// No description provided for @stopRecording.
  ///
  /// In es, this message translates to:
  /// **'Parar'**
  String get stopRecording;

  /// No description provided for @recordRouteInstructions.
  ///
  /// In es, this message translates to:
  /// **'Pulsa «Empezar a grabar» y camina por la ruta.'**
  String get recordRouteInstructions;

  /// No description provided for @recordingInfo.
  ///
  /// In es, this message translates to:
  /// **'Grabando… Mantén la app abierta y la pantalla encendida.'**
  String get recordingInfo;

  /// No description provided for @distance.
  ///
  /// In es, this message translates to:
  /// **'Distancia: {distance}'**
  String distance(String distance);

  /// No description provided for @zoneName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get zoneName;

  /// No description provided for @zoneNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej.: Coto Los Robles'**
  String get zoneNameHint;

  /// No description provided for @zoneNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre'**
  String get zoneNameRequired;

  /// No description provided for @zoneDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get zoneDescription;

  /// No description provided for @species.
  ///
  /// In es, this message translates to:
  /// **'Especies'**
  String get species;

  /// No description provided for @modality.
  ///
  /// In es, this message translates to:
  /// **'Modalidad'**
  String get modality;

  /// No description provided for @zoneDetails.
  ///
  /// In es, this message translates to:
  /// **'Datos de la zona'**
  String get zoneDetails;

  /// No description provided for @editZone.
  ///
  /// In es, this message translates to:
  /// **'Editar datos'**
  String get editZone;

  /// No description provided for @deleteZone.
  ///
  /// In es, this message translates to:
  /// **'Borrar zona'**
  String get deleteZone;

  /// No description provided for @deleteZoneQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Borrar la zona «{name}»?'**
  String deleteZoneQuestion(String name);

  /// No description provided for @deleteZoneMessage.
  ///
  /// In es, this message translates to:
  /// **'También se borrarán sus puntos.'**
  String get deleteZoneMessage;

  /// No description provided for @addPoint.
  ///
  /// In es, this message translates to:
  /// **'Añadir punto'**
  String get addPoint;

  /// No description provided for @addPointInstructions.
  ///
  /// In es, this message translates to:
  /// **'Mueve el mapa hasta que la cruz quede sobre el lugar.'**
  String get addPointInstructions;

  /// No description provided for @pointType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de punto'**
  String get pointType;

  /// No description provided for @pointName.
  ///
  /// In es, this message translates to:
  /// **'Nombre o número (opcional)'**
  String get pointName;

  /// No description provided for @pointNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej.: 7'**
  String get pointNameHint;

  /// No description provided for @savePointHere.
  ///
  /// In es, this message translates to:
  /// **'Guardar punto aquí'**
  String get savePointHere;

  /// No description provided for @pointsTitle.
  ///
  /// In es, this message translates to:
  /// **'Puntos ({count})'**
  String pointsTitle(int count);

  /// No description provided for @noPoints.
  ///
  /// In es, this message translates to:
  /// **'Esta zona todavía no tiene puntos.'**
  String get noPoints;

  /// No description provided for @deletePointQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Borrar este punto?'**
  String get deletePointQuestion;

  /// No description provided for @directions.
  ///
  /// In es, this message translates to:
  /// **'Cómo llegar'**
  String get directions;

  /// No description provided for @directionsError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir la app de mapas.'**
  String get directionsError;

  /// No description provided for @zoneKindArea.
  ///
  /// In es, this message translates to:
  /// **'Área'**
  String get zoneKindArea;

  /// No description provided for @zoneKindRoute.
  ///
  /// In es, this message translates to:
  /// **'Ruta'**
  String get zoneKindRoute;

  /// No description provided for @pointStand.
  ///
  /// In es, this message translates to:
  /// **'Puesto'**
  String get pointStand;

  /// No description provided for @pointParking.
  ///
  /// In es, this message translates to:
  /// **'Coche'**
  String get pointParking;

  /// No description provided for @pointFeeder.
  ///
  /// In es, this message translates to:
  /// **'Comedero'**
  String get pointFeeder;

  /// No description provided for @pointDanger.
  ///
  /// In es, this message translates to:
  /// **'Peligro'**
  String get pointDanger;

  /// No description provided for @pointOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get pointOther;

  /// No description provided for @speciesWildBoar.
  ///
  /// In es, this message translates to:
  /// **'Jabalí'**
  String get speciesWildBoar;

  /// No description provided for @speciesRedDeer.
  ///
  /// In es, this message translates to:
  /// **'Ciervo'**
  String get speciesRedDeer;

  /// No description provided for @speciesRoeDeer.
  ///
  /// In es, this message translates to:
  /// **'Corzo'**
  String get speciesRoeDeer;

  /// No description provided for @speciesFallowDeer.
  ///
  /// In es, this message translates to:
  /// **'Gamo'**
  String get speciesFallowDeer;

  /// No description provided for @speciesMouflon.
  ///
  /// In es, this message translates to:
  /// **'Muflón'**
  String get speciesMouflon;

  /// No description provided for @speciesIbex.
  ///
  /// In es, this message translates to:
  /// **'Cabra montés'**
  String get speciesIbex;

  /// No description provided for @speciesPartridge.
  ///
  /// In es, this message translates to:
  /// **'Perdiz'**
  String get speciesPartridge;

  /// No description provided for @speciesRabbit.
  ///
  /// In es, this message translates to:
  /// **'Conejo'**
  String get speciesRabbit;

  /// No description provided for @speciesHare.
  ///
  /// In es, this message translates to:
  /// **'Liebre'**
  String get speciesHare;

  /// No description provided for @speciesQuail.
  ///
  /// In es, this message translates to:
  /// **'Codorniz'**
  String get speciesQuail;

  /// No description provided for @speciesPigeon.
  ///
  /// In es, this message translates to:
  /// **'Paloma'**
  String get speciesPigeon;

  /// No description provided for @speciesFox.
  ///
  /// In es, this message translates to:
  /// **'Zorro'**
  String get speciesFox;

  /// No description provided for @modalityMonteria.
  ///
  /// In es, this message translates to:
  /// **'Montería'**
  String get modalityMonteria;

  /// No description provided for @modalityBatida.
  ///
  /// In es, this message translates to:
  /// **'Batida'**
  String get modalityBatida;

  /// No description provided for @modalityStalking.
  ///
  /// In es, this message translates to:
  /// **'Rececho'**
  String get modalityStalking;

  /// No description provided for @modalityWaiting.
  ///
  /// In es, this message translates to:
  /// **'Espera'**
  String get modalityWaiting;

  /// No description provided for @modalitySmallGame.
  ///
  /// In es, this message translates to:
  /// **'Caza menor'**
  String get modalitySmallGame;

  /// No description provided for @modalityOther.
  ///
  /// In es, this message translates to:
  /// **'Otra'**
  String get modalityOther;

  /// No description provided for @zoneSaved.
  ///
  /// In es, this message translates to:
  /// **'Zona guardada'**
  String get zoneSaved;

  /// No description provided for @zoneNotFound.
  ///
  /// In es, this message translates to:
  /// **'Esta zona ya no existe.'**
  String get zoneNotFound;

  /// No description provided for @downloadMap.
  ///
  /// In es, this message translates to:
  /// **'Descargar mapa ({size})'**
  String downloadMap(String size);

  /// No description provided for @downloadMapHint.
  ///
  /// In es, this message translates to:
  /// **'Para verlo sin cobertura en el monte.'**
  String get downloadMapHint;

  /// No description provided for @downloadingMap.
  ///
  /// In es, this message translates to:
  /// **'Descargando mapa… {percent} %'**
  String downloadingMap(int percent);

  /// No description provided for @mapDownloaded.
  ///
  /// In es, this message translates to:
  /// **'Mapa descargado ({size})'**
  String mapDownloaded(String size);

  /// No description provided for @mapDownloadFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo descargar el mapa. Comprueba la conexión.'**
  String get mapDownloadFailed;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @deleteMap.
  ///
  /// In es, this message translates to:
  /// **'Borrar mapa descargado'**
  String get deleteMap;

  /// No description provided for @deleteMapQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Borrar el mapa descargado de «{name}»?'**
  String deleteMapQuestion(String name);

  /// No description provided for @offlineMaps.
  ///
  /// In es, this message translates to:
  /// **'Mapas descargados'**
  String get offlineMaps;

  /// No description provided for @offlineMapsEmpty.
  ///
  /// In es, this message translates to:
  /// **'No tienes mapas descargados.'**
  String get offlineMapsEmpty;

  /// No description provided for @offlineMapsHint.
  ///
  /// In es, this message translates to:
  /// **'Descarga el mapa desde la ficha de cada zona.'**
  String get offlineMapsHint;

  /// No description provided for @offlineMapsTotal.
  ///
  /// In es, this message translates to:
  /// **'Espacio usado: {size}'**
  String offlineMapsTotal(String size);

  /// No description provided for @liveHunt.
  ///
  /// In es, this message translates to:
  /// **'Jornada en grupo'**
  String get liveHunt;

  /// No description provided for @myCaptures.
  ///
  /// In es, this message translates to:
  /// **'Mis capturas'**
  String get myCaptures;

  /// No description provided for @newCapture.
  ///
  /// In es, this message translates to:
  /// **'Registrar captura'**
  String get newCapture;

  /// No description provided for @capturesEmpty.
  ///
  /// In es, this message translates to:
  /// **'Todavía no has registrado capturas.'**
  String get capturesEmpty;

  /// No description provided for @captureSpecies.
  ///
  /// In es, this message translates to:
  /// **'¿Qué especie?'**
  String get captureSpecies;

  /// No description provided for @captureCount.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get captureCount;

  /// No description provided for @less.
  ///
  /// In es, this message translates to:
  /// **'Menos'**
  String get less;

  /// No description provided for @more.
  ///
  /// In es, this message translates to:
  /// **'Más'**
  String get more;

  /// No description provided for @takePhoto.
  ///
  /// In es, this message translates to:
  /// **'Hacer foto (opcional)'**
  String get takePhoto;

  /// No description provided for @retakePhoto.
  ///
  /// In es, this message translates to:
  /// **'Repetir foto'**
  String get retakePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In es, this message translates to:
  /// **'Quitar foto'**
  String get removePhoto;

  /// No description provided for @captureNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas (opcional)'**
  String get captureNotes;

  /// No description provided for @gettingLocation.
  ///
  /// In es, this message translates to:
  /// **'Buscando tu ubicación…'**
  String get gettingLocation;

  /// No description provided for @locationSaved.
  ///
  /// In es, this message translates to:
  /// **'Se guardará el lugar donde estás ahora.'**
  String get locationSaved;

  /// No description provided for @locationNotAvailable.
  ///
  /// In es, this message translates to:
  /// **'Sin ubicación: no se pudo usar el GPS.'**
  String get locationNotAvailable;

  /// No description provided for @captureSaved.
  ///
  /// In es, this message translates to:
  /// **'Captura guardada'**
  String get captureSaved;

  /// No description provided for @captureTitle.
  ///
  /// In es, this message translates to:
  /// **'{species} × {count}'**
  String captureTitle(String species, int count);

  /// No description provided for @deleteCapture.
  ///
  /// In es, this message translates to:
  /// **'Borrar captura'**
  String get deleteCapture;

  /// No description provided for @deleteCaptureQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Borrar esta captura?'**
  String get deleteCaptureQuestion;

  /// No description provided for @captureNotFound.
  ///
  /// In es, this message translates to:
  /// **'Esta captura ya no existe.'**
  String get captureNotFound;

  /// No description provided for @photoError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar la foto.'**
  String get photoError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
