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
  /// **'Toca el mapa para marcar las esquinas, siguiendo el borde de la zona en orden. Puedes poner todas las que necesites.'**
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

  /// No description provided for @labelType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get labelType;

  /// No description provided for @labelSize.
  ///
  /// In es, this message translates to:
  /// **'Tamaño'**
  String get labelSize;

  /// No description provided for @labelDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get labelDescription;

  /// No description provided for @labelDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get labelDate;

  /// No description provided for @labelLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get labelLocation;

  /// No description provided for @labelNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get labelNotes;

  /// No description provided for @view.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get view;

  /// No description provided for @mapReadyNotice.
  ///
  /// In es, this message translates to:
  /// **'Mapa de «{name}» descargado. Ya puedes verlo sin cobertura.'**
  String mapReadyNotice(String name);

  /// No description provided for @mapFailedNotice.
  ///
  /// In es, this message translates to:
  /// **'No se pudo descargar el mapa de «{name}».'**
  String mapFailedNotice(String name);

  /// No description provided for @crossingNotAllowed.
  ///
  /// In es, this message translates to:
  /// **'Ese punto haría que las líneas se crucen. Toca en otro sitio, siguiendo el borde en orden.'**
  String get crossingNotAllowed;

  /// No description provided for @routeSaveQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo quieres guardar el recorrido?'**
  String get routeSaveQuestion;

  /// No description provided for @saveAsRoute.
  ///
  /// In es, this message translates to:
  /// **'Guardar como ruta'**
  String get saveAsRoute;

  /// No description provided for @saveAsRouteHint.
  ///
  /// In es, this message translates to:
  /// **'Un camino, sin cerrar.'**
  String get saveAsRouteHint;

  /// No description provided for @closeAsArea.
  ///
  /// In es, this message translates to:
  /// **'Cerrar como área'**
  String get closeAsArea;

  /// No description provided for @closeAsAreaHint.
  ///
  /// In es, this message translates to:
  /// **'La app une el final con el principio y crea una zona.'**
  String get closeAsAreaHint;

  /// No description provided for @convertToAreaQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cerrar la ruta «{name}» y convertirla en un área?'**
  String convertToAreaQuestion(String name);

  /// No description provided for @convertToAreaMessage.
  ///
  /// In es, this message translates to:
  /// **'Se unirá el final del camino con el principio.'**
  String get convertToAreaMessage;

  /// No description provided for @subzonesTitle.
  ///
  /// In es, this message translates to:
  /// **'Subzonas ({count})'**
  String subzonesTitle(int count);

  /// No description provided for @addSubzone.
  ///
  /// In es, this message translates to:
  /// **'Añadir subzona'**
  String get addSubzone;

  /// No description provided for @noSubzones.
  ///
  /// In es, this message translates to:
  /// **'Esta zona no tiene subzonas.'**
  String get noSubzones;

  /// No description provided for @drawSubzone.
  ///
  /// In es, this message translates to:
  /// **'Dibujar subzona'**
  String get drawSubzone;

  /// No description provided for @subzoneInstructions.
  ///
  /// In es, this message translates to:
  /// **'Marca las esquinas de la subzona dentro de «{name}», siguiendo el borde en orden.'**
  String subzoneInstructions(String name);

  /// No description provided for @subzoneOutside.
  ///
  /// In es, this message translates to:
  /// **'Toca dentro de «{name}»: una subzona tiene que estar dentro de su zona.'**
  String subzoneOutside(String name);

  /// No description provided for @insideOf.
  ///
  /// In es, this message translates to:
  /// **'Está en'**
  String get insideOf;

  /// No description provided for @subzonesCount.
  ///
  /// In es, this message translates to:
  /// **'{count} subzonas'**
  String subzonesCount(int count);

  /// No description provided for @featuresTitle.
  ///
  /// In es, this message translates to:
  /// **'Características'**
  String get featuresTitle;

  /// No description provided for @editFeatures.
  ///
  /// In es, this message translates to:
  /// **'Editar características'**
  String get editFeatures;

  /// No description provided for @noFeatures.
  ///
  /// In es, this message translates to:
  /// **'Todavía no has anotado nada en esta zona.'**
  String get noFeatures;

  /// No description provided for @featuresSaved.
  ///
  /// In es, this message translates to:
  /// **'Características guardadas'**
  String get featuresSaved;

  /// No description provided for @featAnimals.
  ///
  /// In es, this message translates to:
  /// **'Animales vistos'**
  String get featAnimals;

  /// No description provided for @featFoodWater.
  ///
  /// In es, this message translates to:
  /// **'Comida y agua'**
  String get featFoodWater;

  /// No description provided for @featDanger.
  ///
  /// In es, this message translates to:
  /// **'Peligro'**
  String get featDanger;

  /// No description provided for @featDangerLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel de peligro'**
  String get featDangerLevel;

  /// No description provided for @featDangerTypes.
  ///
  /// In es, this message translates to:
  /// **'Qué peligro hay'**
  String get featDangerTypes;

  /// No description provided for @featSigns.
  ///
  /// In es, this message translates to:
  /// **'Encame y pasos'**
  String get featSigns;

  /// No description provided for @dangerNone.
  ///
  /// In es, this message translates to:
  /// **'Ninguno'**
  String get dangerNone;

  /// No description provided for @dangerLow.
  ///
  /// In es, this message translates to:
  /// **'Bajo'**
  String get dangerLow;

  /// No description provided for @dangerMedium.
  ///
  /// In es, this message translates to:
  /// **'Medio'**
  String get dangerMedium;

  /// No description provided for @dangerHigh.
  ///
  /// In es, this message translates to:
  /// **'Alto'**
  String get dangerHigh;

  /// No description provided for @foodFeeder.
  ///
  /// In es, this message translates to:
  /// **'Comedero'**
  String get foodFeeder;

  /// No description provided for @foodWaterTrough.
  ///
  /// In es, this message translates to:
  /// **'Bebedero'**
  String get foodWaterTrough;

  /// No description provided for @foodNaturalWater.
  ///
  /// In es, this message translates to:
  /// **'Agua natural'**
  String get foodNaturalWater;

  /// No description provided for @foodCrops.
  ///
  /// In es, this message translates to:
  /// **'Cultivos'**
  String get foodCrops;

  /// No description provided for @foodAcorns.
  ///
  /// In es, this message translates to:
  /// **'Bellota'**
  String get foodAcorns;

  /// No description provided for @foodFruit.
  ///
  /// In es, this message translates to:
  /// **'Frutales'**
  String get foodFruit;

  /// No description provided for @dangerCliff.
  ///
  /// In es, this message translates to:
  /// **'Barranco'**
  String get dangerCliff;

  /// No description provided for @dangerRoad.
  ///
  /// In es, this message translates to:
  /// **'Carretera'**
  String get dangerRoad;

  /// No description provided for @dangerHouses.
  ///
  /// In es, this message translates to:
  /// **'Casas cerca'**
  String get dangerHouses;

  /// No description provided for @dangerNoHunting.
  ///
  /// In es, this message translates to:
  /// **'Zona prohibida'**
  String get dangerNoHunting;

  /// No description provided for @dangerLivestock.
  ///
  /// In es, this message translates to:
  /// **'Ganado'**
  String get dangerLivestock;

  /// No description provided for @dangerOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get dangerOther;

  /// No description provided for @signBedding.
  ///
  /// In es, this message translates to:
  /// **'Encame'**
  String get signBedding;

  /// No description provided for @signCrossing.
  ///
  /// In es, this message translates to:
  /// **'Paso habitual'**
  String get signCrossing;

  /// No description provided for @signWallow.
  ///
  /// In es, this message translates to:
  /// **'Revolcadero'**
  String get signWallow;

  /// No description provided for @signRub.
  ///
  /// In es, this message translates to:
  /// **'Rascadero'**
  String get signRub;

  /// No description provided for @signTracks.
  ///
  /// In es, this message translates to:
  /// **'Rastros'**
  String get signTracks;

  /// No description provided for @account.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta'**
  String get account;

  /// No description provided for @noAccountTitle.
  ///
  /// In es, this message translates to:
  /// **'Todavía no has entrado'**
  String get noAccountTitle;

  /// No description provided for @noAccountMessage.
  ///
  /// In es, this message translates to:
  /// **'Entra con tu número de teléfono para compartir zonas y hacer jornadas en grupo. Sin cuenta, la app sigue funcionando en este móvil.'**
  String get noAccountMessage;

  /// No description provided for @signInWithPhone.
  ///
  /// In es, this message translates to:
  /// **'Entrar con mi teléfono'**
  String get signInWithPhone;

  /// No description provided for @accountsUnavailable.
  ///
  /// In es, this message translates to:
  /// **'Las cuentas no están disponibles en esta versión de la app.'**
  String get accountsUnavailable;

  /// No description provided for @phoneTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu número de teléfono'**
  String get phoneTitle;

  /// No description provided for @phoneExplanation.
  ///
  /// In es, this message translates to:
  /// **'Te enviaremos un SMS con un código. No hace falta contraseña.'**
  String get phoneExplanation;

  /// No description provided for @countryCode.
  ///
  /// In es, this message translates to:
  /// **'Prefijo'**
  String get countryCode;

  /// No description provided for @phoneNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de teléfono'**
  String get phoneNumber;

  /// No description provided for @sendCode.
  ///
  /// In es, this message translates to:
  /// **'Enviar código'**
  String get sendCode;

  /// No description provided for @phoneInvalid.
  ///
  /// In es, this message translates to:
  /// **'Escribe un número de teléfono válido.'**
  String get phoneInvalid;

  /// No description provided for @codeTitle.
  ///
  /// In es, this message translates to:
  /// **'Escribe el código'**
  String get codeTitle;

  /// No description provided for @codeSentTo.
  ///
  /// In es, this message translates to:
  /// **'Te hemos enviado un SMS con un código de 6 cifras al {phone}.'**
  String codeSentTo(String phone);

  /// No description provided for @code.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get code;

  /// No description provided for @signIn.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get signIn;

  /// No description provided for @changeNumber.
  ///
  /// In es, this message translates to:
  /// **'Cambiar número'**
  String get changeNumber;

  /// No description provided for @resendCode.
  ///
  /// In es, this message translates to:
  /// **'Reenviar código'**
  String get resendCode;

  /// No description provided for @resendIn.
  ///
  /// In es, this message translates to:
  /// **'Podrás reenviar el código en {seconds} s'**
  String resendIn(int seconds);

  /// No description provided for @codeInvalid.
  ///
  /// In es, this message translates to:
  /// **'El código no es correcto o ha caducado.'**
  String get codeInvalid;

  /// No description provided for @noConnection.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Inténtalo cuando tengas cobertura.'**
  String get noConnection;

  /// No description provided for @tooManyAttempts.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Espera unos minutos.'**
  String get tooManyAttempts;

  /// No description provided for @authError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo entrar. Inténtalo de nuevo.'**
  String get authError;

  /// No description provided for @testLoginHint.
  ///
  /// In es, this message translates to:
  /// **'Modo pruebas: usa el prefijo +34, el número 600 000 001 y el código 123456.'**
  String get testLoginHint;

  /// No description provided for @nameTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo te llamas?'**
  String get nameTitle;

  /// No description provided for @nameExplanation.
  ///
  /// In es, this message translates to:
  /// **'Así te verán los demás cazadores de tu grupo.'**
  String get nameExplanation;

  /// No description provided for @yourName.
  ///
  /// In es, this message translates to:
  /// **'Tu nombre'**
  String get yourName;

  /// No description provided for @nameRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu nombre'**
  String get nameRequired;

  /// No description provided for @signedInAs.
  ///
  /// In es, this message translates to:
  /// **'Has entrado como {name}'**
  String signedInAs(String name);

  /// No description provided for @noName.
  ///
  /// In es, this message translates to:
  /// **'Sin nombre'**
  String get noName;

  /// No description provided for @changeName.
  ///
  /// In es, this message translates to:
  /// **'Cambiar nombre'**
  String get changeName;

  /// No description provided for @signOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get signOut;

  /// No description provided for @signOutQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cerrar sesión?'**
  String get signOutQuestion;

  /// No description provided for @signOutMessage.
  ///
  /// In es, this message translates to:
  /// **'Tus zonas y capturas se quedan en este móvil.'**
  String get signOutMessage;

  /// No description provided for @phoneLabel.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phoneLabel;

  /// No description provided for @nameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get nameLabel;
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
