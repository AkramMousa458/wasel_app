import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Default map positions (Cairo) until pickup/drop-off are wired to GPS/search.
abstract final class OrderRouteDefaults {
  static final LatLng pickup = LatLng(30.0520, 31.2336);
  static final LatLng dropoff = LatLng(30.0455, 31.2388);

  static LatLngBounds get routeBounds =>
      LatLngBounds.fromPoints([pickup, dropoff]);
}
