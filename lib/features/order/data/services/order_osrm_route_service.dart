import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

/// Driving routes via [OSRM](https://project-osrm.org/) public demo (`router.project-osrm.org`).
/// For heavy production use, host your own OSRM or use a provider with a key and SLA.
class OrderOsrmRouteService {
  OrderOsrmRouteService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://router.project-osrm.org',
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
              headers: const {
                'User-Agent': 'WaselApp/1.0 (com.example.wasel)',
              },
            ),
          );

  final Dio _dio;

  /// Ordered points and distance along the driving route (roads). Throws if routing fails.
  Future<OrderDrivingRoute> getDrivingRoute(LatLng from, LatLng to) async {
    if (from.latitude == to.latitude && from.longitude == to.longitude) {
      return OrderDrivingRoute(points: [from], distanceMeters: 0);
    }

    final path =
        '${from.longitude},${from.latitude};${to.longitude},${to.latitude}';
    final response = await _dio.get<Map<String, dynamic>>(
      '/route/v1/driving/$path',
      queryParameters: const <String, dynamic>{
        'overview': 'full',
        'geometries': 'geojson',
        'steps': 'false',
      },
    );

    final data = response.data;
    if (data == null) throw Exception('Empty OSRM response');

    final code = data['code'];
    if (code != 'Ok') {
      throw Exception('OSRM: $code');
    }

    final routes = data['routes'];
    if (routes is! List || routes.isEmpty) throw Exception('No route');

    final route0 = routes.first;
    if (route0 is! Map<String, dynamic>) throw Exception('Bad route entry');
    final distanceRaw = route0['distance'];
    if (distanceRaw is! num) throw Exception('Bad distance');

    final geom = route0['geometry'];
    if (geom is! Map) throw Exception('Bad geometry');

    final coordsList = geom['coordinates'];
    if (coordsList is! List<dynamic>) throw Exception('Bad coordinates');

    final out = <LatLng>[];
    for (final c in coordsList) {
      if (c is! List || c.length < 2) continue;
      final lon = (c[0] as num).toDouble();
      final lat = (c[1] as num).toDouble();
      out.add(LatLng(lat, lon));
    }
    if (out.isEmpty) throw Exception('Empty geometry');
    return OrderDrivingRoute(
      points: out,
      distanceMeters: distanceRaw.toDouble(),
    );
  }
}

class OrderDrivingRoute {
  const OrderDrivingRoute({
    required this.points,
    required this.distanceMeters,
  });

  final List<LatLng> points;
  final double distanceMeters;
}
