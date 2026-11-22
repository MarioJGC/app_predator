import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// Result of asking for the user's position.
sealed class LocationResult {
  const LocationResult();
}

class LocationFound extends LocationResult {
  const LocationFound(this.position);
  final Position position;
}

/// The user refused the permission (or the system blocks it).
class LocationDenied extends LocationResult {
  const LocationDenied();
}

/// Permission is fine, but there is no position (GPS off, timeout...).
class LocationUnavailable extends LocationResult {
  const LocationUnavailable();
}

/// Wraps geolocator so screens don't deal with permissions directly.
class LocationService {
  /// Asks for permission if needed. Returns true if we can read the GPS.
  Future<bool> ensurePermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Current position. Falls back to the last known one (useful offline).
  Future<LocationResult> currentPosition() async {
    if (!await ensurePermission()) return const LocationDenied();
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return LocationFound(position);
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition();
      return last == null ? const LocationUnavailable() : LocationFound(last);
    }
  }

  /// Continuous positions, for recording routes.
  Stream<Position> positionStream({int distanceFilterMeters = 5}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilterMeters,
      ),
    );
  }

  Future<void> openSettings() => Geolocator.openAppSettings();
}

final locationServiceProvider = Provider((ref) => LocationService());
