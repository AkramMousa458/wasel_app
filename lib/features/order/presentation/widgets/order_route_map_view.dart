import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/features/order/presentation/constants/order_map_config.dart';
import 'package:wasel/features/order/presentation/widgets/order_route_stop_marker.dart';

/// Map layer: OSM-derived raster tiles (Carto by default); optional `mt0`–`mt3` mirror in [OrderMapConfig].
class OrderRouteMapView extends StatelessWidget {
  const OrderRouteMapView({
    super.key,
    required this.isDark,
    required this.mapController,
    required this.pickup,
    required this.dropoff,
    this.routePoints,
    this.fitPaddingBottom = 280,
  });

  final bool isDark;
  final MapController mapController;
  final LatLng pickup;
  final LatLng dropoff;
  /// OSRM road geometry; when null, a dashed straight segment is shown.
  final List<LatLng>? routePoints;
  /// Space reserved for the bottom sheet when fitting the route (logical px).
  final double fitPaddingBottom;

  @override
  Widget build(BuildContext context) {
    final template = OrderMapConfig.urlTemplate(isDark);
    final subdomains = OrderMapConfig.subdomainsForTemplate(isDark);

    final hasRoad =
        routePoints != null && routePoints!.isNotEmpty;
    final linePoints =
        hasRoad ? routePoints! : <LatLng>[pickup, dropoff];
    final routeBounds = hasRoad
        ? LatLngBounds.fromPoints(routePoints!)
        : LatLngBounds(pickup, dropoff);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: routeBounds,
          padding: EdgeInsets.only(
            left: 48,
            right: 48,
            top: 120,
            bottom: fitPaddingBottom,
          ),
        ),
        minZoom: 3,
        maxZoom: 18,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
        backgroundColor:
            isDark ? AppColors.darkScaffold : AppColors.lightScaffold,
      ),
      children: [
        TileLayer(
          urlTemplate: template,
          subdomains: subdomains,
          userAgentPackageName: 'com.example.wasel',
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: linePoints,
              color: AppColors.primary,
              strokeWidth: 4,
              pattern: hasRoad
                  ? const StrokePattern.solid()
                  : StrokePattern.dashed(segments: const [14, 10]),
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: pickup,
              width: 100,
              height: 100,
              alignment: Alignment.bottomCenter,
              rotate: true,
              child: OrderPickupMarker(isDark: isDark),
            ),
            Marker(
              point: dropoff,
              width: 100,
              height: 100,
              alignment: Alignment.bottomCenter,
              rotate: true,
              child: OrderDropoffMarker(isDark: isDark),
            ),
          ],
        ),
        RichAttributionWidget(
          showFlutterMapAttribution: false,
          animationConfig: const FadeRAWA(),
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors · CARTO',
              prependCopyright: false,
            ),
          ],
        ),
      ],
    );
  }
}
