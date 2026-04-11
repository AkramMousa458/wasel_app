import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Reads GPS when permitted; returns null if unavailable (no permission, services off, errors).
abstract final class OrderDeviceLocationService {
  OrderDeviceLocationService._();

  static Future<LatLng?> tryGetCurrentLatLng() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition();
      if (last == null) return null;
      return LatLng(last.latitude, last.longitude);
    }
  }
}
