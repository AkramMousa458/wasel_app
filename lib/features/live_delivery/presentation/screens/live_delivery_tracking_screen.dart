import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/live_delivery/data/models/live_delivery_rating_args.dart';
import 'package:wasel/features/live_delivery/data/models/live_delivery_screen_args.dart';
import 'package:wasel/features/live_delivery/presentation/constants/live_delivery_demo_route.dart';
import 'package:wasel/features/live_delivery/presentation/screens/live_delivery_rating_screen.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_map_view.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_sheet_body.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_side_fabs.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_top_bar.dart';

class LiveDeliveryTrackingScreen extends StatefulWidget {
  const LiveDeliveryTrackingScreen({super.key, required this.args});

  static const String routeName = '/order/live-delivery';

  final LiveDeliveryScreenArgs args;

  @override
  State<LiveDeliveryTrackingScreen> createState() =>
      _LiveDeliveryTrackingScreenState();
}

class _LiveDeliveryTrackingScreenState
    extends State<LiveDeliveryTrackingScreen> {
  static const double _sheetInitial = 0.42;
  static const double _sheetMin = 0.28;
  static const double _sheetMax = 0.88;

  final MapController _mapController = MapController();
  double _sheetExtent = _sheetInitial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fitRoute();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _fitRoute() {
    final path = LiveDeliveryDemoRoute.courierPath;
    final bounds = LatLngBounds.fromPoints(path);
    final h = MediaQuery.sizeOf(context).height;
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.only(
          left: 40,
          right: 40,
          top: 100,
          bottom: h * _sheetExtent + 32,
        ),
      ),
    );
  }

  void _openRatingScreen() {
    final courierName =
        widget.args.courierName ?? translate('live_delivery_demo_courier');
    context.push(
      LiveDeliveryRatingScreen.routeName,
      extra: LiveDeliveryRatingArgs(
        orderId: widget.args.orderId,
        courierName: courierName,
        courierAvatarUrl: widget.args.courierAvatarUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final h = MediaQuery.sizeOf(context).height;
    final courierName =
        widget.args.courierName ?? translate('live_delivery_demo_courier');
    final eta = widget.args.etaMinutes ?? 12;

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          LiveDeliveryMapView(
            isDark: isDark,
            mapController: _mapController,
            fitPaddingBottom: h * _sheetInitial + 40,
          ),

          NotificationListener<DraggableScrollableNotification>(
            onNotification: (n) {
              final next = n.extent;
              if ((next - _sheetExtent).abs() > 0.002) {
                setState(() => _sheetExtent = next);
              }
              return false;
            },
            child: DraggableScrollableSheet(
              initialChildSize: _sheetInitial,
              minChildSize: _sheetMin,
              maxChildSize: _sheetMax,
              snap: true,
              snapSizes: const [_sheetMin, _sheetInitial, _sheetMax],
              builder: (context, scrollController) {
                return LiveDeliverySheetBody(
                  scrollController: scrollController,
                  etaMinutes: eta,
                  courierName: courierName,
                  courierRating: 4.9,
                  courierAvatarUrl: widget.args.courierAvatarUrl,
                  currentStepIndex: widget.args.currentStepIndex.clamp(0, 3),
                  onRateDelivery: _openRatingScreen,
                );
              },
            ),
          ),
          LiveDeliverySideFabs(
            bottomOffset: h * _sheetExtent,
            onRecenterMap: _fitRoute,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: LiveDeliveryTopBar(orderId: widget.args.orderId),
            ),
          ),
        ],
      ),
    );
  }
}
