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
}
