// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'App Cazador';

  @override
  String get tabMap => 'Mapa';

  @override
  String get tabZones => 'Mis zonas';

  @override
  String get tabGroups => 'Grupos';

  @override
  String get tabHunt => 'Jornada';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get layerOrthophoto => 'Satélite';

  @override
  String get layerTopographic => 'Topográfico';

  @override
  String get changeMap => 'Cambiar mapa';

  @override
  String get myLocation => 'Mi ubicación';

  @override
  String get locationDenied =>
      'Sin permiso de ubicación. Actívalo en los ajustes del móvil para ver dónde estás.';

  @override
  String get locationUnavailable =>
      'No se puede obtener tu ubicación. Comprueba que el GPS está activado.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get groupsComingSoon =>
      'Aquí podrás crear tu cuadrilla e invitar a otros cazadores. Llegará con las cuentas de usuario.';

  @override
  String get huntComingSoon =>
      'Aquí podrás organizar jornadas, asignar puestos y ver a tu grupo en el mapa. Llegará con las cuentas de usuario.';

  @override
  String get zonesEmpty => 'Todavía no tienes zonas.';

  @override
  String get newZone => 'Nueva zona';

  @override
  String get newZoneQuestion => '¿Qué quieres crear?';

  @override
  String get drawArea => 'Dibujar un área';

  @override
  String get drawAreaHint => 'Para marcar una finca o un coto en el mapa.';

  @override
  String get recordRoute => 'Grabar una ruta';

  @override
  String get recordRouteHint => 'Camina y la app guarda el camino con el GPS.';

  @override
  String get drawAreaInstructions =>
      'Toca el mapa para marcar las esquinas, siguiendo el borde de la zona en orden. Puedes poner todas las que necesites.';

  @override
  String get undo => 'Deshacer';

  @override
  String get next => 'Siguiente';

  @override
  String get startRecording => 'Empezar a grabar';

  @override
  String get stopRecording => 'Parar';

  @override
  String get recordRouteInstructions =>
      'Pulsa «Empezar a grabar» y camina por la ruta.';

  @override
  String get recordingInfo =>
      'Grabando… Mantén la app abierta y la pantalla encendida.';

  @override
  String distance(String distance) {
    return 'Distancia: $distance';
  }

  @override
  String get zoneName => 'Nombre';

  @override
  String get zoneNameHint => 'Ej.: Coto Los Robles';

  @override
  String get zoneNameRequired => 'Escribe un nombre';

  @override
  String get zoneDescription => 'Descripción (opcional)';

  @override
  String get species => 'Especies';

  @override
  String get modality => 'Modalidad';

  @override
  String get zoneDetails => 'Datos de la zona';

  @override
  String get editZone => 'Editar datos';

  @override
  String get deleteZone => 'Borrar zona';

  @override
  String deleteZoneQuestion(String name) {
    return '¿Borrar la zona «$name»?';
  }

  @override
  String get deleteZoneMessage => 'También se borrarán sus puntos.';

  @override
  String get addPoint => 'Añadir punto';

  @override
  String get addPointInstructions =>
      'Mueve el mapa hasta que la cruz quede sobre el lugar.';

  @override
  String get pointType => 'Tipo de punto';

  @override
  String get pointName => 'Nombre o número (opcional)';

  @override
  String get pointNameHint => 'Ej.: 7';

  @override
  String get savePointHere => 'Guardar punto aquí';

  @override
  String pointsTitle(int count) {
    return 'Puntos ($count)';
  }

  @override
  String get noPoints => 'Esta zona todavía no tiene puntos.';

  @override
  String get deletePointQuestion => '¿Borrar este punto?';

  @override
  String get directions => 'Cómo llegar';

  @override
  String get directionsError => 'No se pudo abrir la app de mapas.';

  @override
  String get zoneKindArea => 'Área';

  @override
  String get zoneKindRoute => 'Ruta';

  @override
  String get pointStand => 'Puesto';

  @override
  String get pointParking => 'Coche';

  @override
  String get pointFeeder => 'Comedero';

  @override
  String get pointDanger => 'Peligro';

  @override
  String get pointOther => 'Otro';

  @override
  String get speciesWildBoar => 'Jabalí';

  @override
  String get speciesRedDeer => 'Ciervo';

  @override
  String get speciesRoeDeer => 'Corzo';

  @override
  String get speciesFallowDeer => 'Gamo';

  @override
  String get speciesMouflon => 'Muflón';

  @override
  String get speciesIbex => 'Cabra montés';

  @override
  String get speciesPartridge => 'Perdiz';

  @override
  String get speciesRabbit => 'Conejo';

  @override
  String get speciesHare => 'Liebre';

  @override
  String get speciesQuail => 'Codorniz';

  @override
  String get speciesPigeon => 'Paloma';

  @override
  String get speciesFox => 'Zorro';

  @override
  String get modalityMonteria => 'Montería';

  @override
  String get modalityBatida => 'Batida';

  @override
  String get modalityStalking => 'Rececho';

  @override
  String get modalityWaiting => 'Espera';

  @override
  String get modalitySmallGame => 'Caza menor';

  @override
  String get modalityOther => 'Otra';

  @override
  String get zoneSaved => 'Zona guardada';

  @override
  String get zoneNotFound => 'Esta zona ya no existe.';

  @override
  String downloadMap(String size) {
    return 'Descargar mapa ($size)';
  }

  @override
  String get downloadMapHint => 'Para verlo sin cobertura en el monte.';

  @override
  String downloadingMap(int percent) {
    return 'Descargando mapa… $percent %';
  }

  @override
  String mapDownloaded(String size) {
    return 'Mapa descargado ($size)';
  }

  @override
  String get mapDownloadFailed =>
      'No se pudo descargar el mapa. Comprueba la conexión.';

  @override
  String get retry => 'Reintentar';

  @override
  String get deleteMap => 'Borrar mapa descargado';

  @override
  String deleteMapQuestion(String name) {
    return '¿Borrar el mapa descargado de «$name»?';
  }

  @override
  String get offlineMaps => 'Mapas descargados';

  @override
  String get offlineMapsEmpty => 'No tienes mapas descargados.';

  @override
  String get offlineMapsHint => 'Descarga el mapa desde la ficha de cada zona.';

  @override
  String offlineMapsTotal(String size) {
    return 'Espacio usado: $size';
  }

  @override
  String get liveHunt => 'Jornada en grupo';

  @override
  String get myCaptures => 'Mis capturas';

  @override
  String get newCapture => 'Registrar captura';

  @override
  String get capturesEmpty => 'Todavía no has registrado capturas.';

  @override
  String get captureSpecies => '¿Qué especie?';

  @override
  String get captureCount => 'Cantidad';

  @override
  String get less => 'Menos';

  @override
  String get more => 'Más';

  @override
  String get takePhoto => 'Hacer foto (opcional)';

  @override
  String get retakePhoto => 'Repetir foto';

  @override
  String get removePhoto => 'Quitar foto';

  @override
  String get captureNotes => 'Notas (opcional)';

  @override
  String get gettingLocation => 'Buscando tu ubicación…';

  @override
  String get locationSaved => 'Se guardará el lugar donde estás ahora.';

  @override
  String get locationNotAvailable => 'Sin ubicación: no se pudo usar el GPS.';

  @override
  String get captureSaved => 'Captura guardada';

  @override
  String captureTitle(String species, int count) {
    return '$species × $count';
  }

  @override
  String get deleteCapture => 'Borrar captura';

  @override
  String get deleteCaptureQuestion => '¿Borrar esta captura?';

  @override
  String get captureNotFound => 'Esta captura ya no existe.';

  @override
  String get photoError => 'No se pudo guardar la foto.';

  @override
  String get labelType => 'Tipo';

  @override
  String get labelSize => 'Tamaño';

  @override
  String get labelDescription => 'Descripción';

  @override
  String get labelDate => 'Fecha';

  @override
  String get labelLocation => 'Ubicación';

  @override
  String get labelNotes => 'Notas';

  @override
  String get view => 'Ver';

  @override
  String mapReadyNotice(String name) {
    return 'Mapa de «$name» descargado. Ya puedes verlo sin cobertura.';
  }

  @override
  String mapFailedNotice(String name) {
    return 'No se pudo descargar el mapa de «$name».';
  }

  @override
  String get crossingNotAllowed =>
      'Ese punto haría que las líneas se crucen. Toca en otro sitio, siguiendo el borde en orden.';

  @override
  String get routeSaveQuestion => '¿Cómo quieres guardar el recorrido?';

  @override
  String get saveAsRoute => 'Guardar como ruta';

  @override
  String get saveAsRouteHint => 'Un camino, sin cerrar.';

  @override
  String get closeAsArea => 'Cerrar como área';

  @override
  String get closeAsAreaHint =>
      'La app une el final con el principio y crea una zona.';

  @override
  String convertToAreaQuestion(String name) {
    return '¿Cerrar la ruta «$name» y convertirla en un área?';
  }

  @override
  String get convertToAreaMessage =>
      'Se unirá el final del camino con el principio.';

  @override
  String subzonesTitle(int count) {
    return 'Subzonas ($count)';
  }

  @override
  String get addSubzone => 'Añadir subzona';

  @override
  String get noSubzones => 'Esta zona no tiene subzonas.';

  @override
  String get drawSubzone => 'Dibujar subzona';

  @override
  String subzoneInstructions(String name) {
    return 'Marca las esquinas de la subzona dentro de «$name», siguiendo el borde en orden.';
  }

  @override
  String subzoneOutside(String name) {
    return 'Toca dentro de «$name»: una subzona tiene que estar dentro de su zona.';
  }

  @override
  String get insideOf => 'Está en';

  @override
  String subzonesCount(int count) {
    return '$count subzonas';
  }

  @override
  String get featuresTitle => 'Características';

  @override
  String get editFeatures => 'Editar características';

  @override
  String get noFeatures => 'Todavía no has anotado nada en esta zona.';

  @override
  String get featuresSaved => 'Características guardadas';

  @override
  String get featAnimals => 'Animales vistos';

  @override
  String get featFoodWater => 'Comida y agua';

  @override
  String get featDanger => 'Peligro';

  @override
  String get featDangerLevel => 'Nivel de peligro';

  @override
  String get featDangerTypes => 'Qué peligro hay';

  @override
  String get featSigns => 'Encame y pasos';

  @override
  String get dangerNone => 'Ninguno';

  @override
  String get dangerLow => 'Bajo';

  @override
  String get dangerMedium => 'Medio';

  @override
  String get dangerHigh => 'Alto';

  @override
  String get foodFeeder => 'Comedero';

  @override
  String get foodWaterTrough => 'Bebedero';

  @override
  String get foodNaturalWater => 'Agua natural';

  @override
  String get foodCrops => 'Cultivos';

  @override
  String get foodAcorns => 'Bellota';

  @override
  String get foodFruit => 'Frutales';

  @override
  String get dangerCliff => 'Barranco';

  @override
  String get dangerRoad => 'Carretera';

  @override
  String get dangerHouses => 'Casas cerca';

  @override
  String get dangerNoHunting => 'Zona prohibida';

  @override
  String get dangerLivestock => 'Ganado';

  @override
  String get dangerOther => 'Otro';

  @override
  String get signBedding => 'Encame';

  @override
  String get signCrossing => 'Paso habitual';

  @override
  String get signWallow => 'Revolcadero';

  @override
  String get signRub => 'Rascadero';

  @override
  String get signTracks => 'Rastros';

  @override
  String get account => 'Tu cuenta';

  @override
  String get noAccountTitle => 'Todavía no has entrado';

  @override
  String get noAccountMessage =>
      'Entra con tu número de teléfono para compartir zonas y hacer jornadas en grupo. Sin cuenta, la app sigue funcionando en este móvil.';

  @override
  String get signInWithPhone => 'Entrar con mi teléfono';

  @override
  String get accountsUnavailable =>
      'Las cuentas no están disponibles en esta versión de la app.';

  @override
  String get phoneTitle => 'Tu número de teléfono';

  @override
  String get phoneExplanation =>
      'Te enviaremos un SMS con un código. No hace falta contraseña.';

  @override
  String get countryCode => 'Prefijo';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get sendCode => 'Enviar código';

  @override
  String get phoneInvalid => 'Escribe un número de teléfono válido.';

  @override
  String get codeTitle => 'Escribe el código';

  @override
  String codeSentTo(String phone) {
    return 'Te hemos enviado un SMS con un código de 6 cifras al $phone.';
  }

  @override
  String get code => 'Código';

  @override
  String get signIn => 'Entrar';

  @override
  String get changeNumber => 'Cambiar número';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String resendIn(int seconds) {
    return 'Podrás reenviar el código en $seconds s';
  }

  @override
  String get codeInvalid => 'El código no es correcto o ha caducado.';

  @override
  String get noConnection => 'Sin conexión. Inténtalo cuando tengas cobertura.';

  @override
  String get tooManyAttempts => 'Demasiados intentos. Espera unos minutos.';

  @override
  String get authError => 'No se pudo entrar. Inténtalo de nuevo.';

  @override
  String get testLoginHint =>
      'Modo pruebas: usa el prefijo +34, el número 600 000 001 y el código 123456.';

  @override
  String get nameTitle => '¿Cómo te llamas?';

  @override
  String get nameExplanation => 'Así te verán los demás cazadores de tu grupo.';

  @override
  String get yourName => 'Tu nombre';

  @override
  String get nameRequired => 'Escribe tu nombre';

  @override
  String signedInAs(String name) {
    return 'Has entrado como $name';
  }

  @override
  String get noName => 'Sin nombre';

  @override
  String get changeName => 'Cambiar nombre';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signOutQuestion => '¿Cerrar sesión?';

  @override
  String get signOutMessage => 'Tus zonas y capturas se quedan en este móvil.';

  @override
  String get phoneLabel => 'Teléfono';

  @override
  String get nameLabel => 'Nombre';
}
