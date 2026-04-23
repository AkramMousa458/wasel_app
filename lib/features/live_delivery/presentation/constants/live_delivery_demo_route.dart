import 'package:latlong2/latlong.dart';

/// Demo coordinates (Riyadh area) until live tracking is wired to the backend.
abstract final class LiveDeliveryDemoRoute {
  static final LatLng destination = LatLng(24.7136, 46.6753);

  static final List<LatLng> courierPath = [
    LatLng(24.7220, 46.6580),
    LatLng(24.7185, 46.6650),
    LatLng(24.7158, 46.6705),
    destination,
  ];

  static final List<LatLng> lockerWaypoints = [
    LatLng(24.7185, 46.6650),
    LatLng(24.7158, 46.6705),
  ];
}
