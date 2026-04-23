import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/features/live_delivery/presentation/constants/live_delivery_demo_route.dart';
import 'package:wasel/features/order/presentation/constants/order_map_config.dart';
import 'package:wasel/features/order/presentation/widgets/order_route_stop_marker.dart';

class LiveDeliveryMapView extends StatelessWidget {
  const LiveDeliveryMapView({
    super.key,
    required this.isDark,
    required this.mapController,
    required this.fitPaddingBottom,
  });

  final bool isDark;
  final MapController mapController;
  final double fitPaddingBottom;

  @override
  Widget build(BuildContext context) {
    final path = LiveDeliveryDemoRoute.courierPath;
    final pickup = path.first;
    final dropoff = LiveDeliveryDemoRoute.destination;
    final hasRoad = path.isNotEmpty;
    final linePoints = hasRoad ? path : [pickup, dropoff];
    final routeBounds = hasRoad
        ? LatLngBounds.fromPoints(path)
        : LatLngBounds(pickup, dropoff);

    final template = OrderMapConfig.urlTemplate(isDark);
    final subdomains = OrderMapConfig.subdomainsForTemplate(isDark);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: routeBounds,
          padding: EdgeInsets.only(
            left: 48,
            right: 48,
            top: 100,
            bottom: fitPaddingBottom,
          ),
        ),
        minZoom: 3,
        maxZoom: 18,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
        backgroundColor: isDark
            ? AppColors.darkScaffold
            : AppColors.lightScaffold,
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
