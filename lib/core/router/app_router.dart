import 'package:go_router/go_router.dart';
import 'package:wasel/core/widgets/error_screen.dart';
import 'package:wasel/features/auth/presentation/screens/login_screen.dart';
import 'package:wasel/features/app/presentation/components/app_shell.dart';
import 'package:wasel/features/auth/presentation/screens/complete_profile_screen.dart';
import 'package:wasel/features/base/presentation/screens/base_screen.dart';
import 'package:wasel/features/order/data/models/order_package_details_draft.dart';
import 'package:wasel/features/order/data/models/order_review_draft.dart';
import 'package:wasel/features/order/data/models/order_route_details_draft.dart';
import 'package:wasel/features/order/presentation/screens/order_step_one_select_route_screen.dart';
import 'package:wasel/features/order/presentation/screens/order_step_four_review_order_screen.dart';
import 'package:wasel/features/order/presentation/screens/order_step_two_package_details_screen.dart';
import 'package:wasel/features/order/presentation/screens/order_step_three_pickup_details_screen.dart';
import 'package:wasel/features/live_delivery/data/models/live_delivery_screen_args.dart';
import 'package:wasel/features/live_delivery/presentation/screens/live_delivery_tracking_screen.dart';
import 'package:wasel/features/order_history/presentation/screens/order_history_screen.dart';
import 'package:wasel/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:wasel/features/profile/presentation/screens/profile_screen.dart';
import 'package:wasel/features/settings/presentation/screens/settings_screen.dart';
import 'package:wasel/features/splash/presentation/screens/splash_screen.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: SplashScreen.routeName,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: ErrorScreen.routeName,
            builder: (context, state) =>
                ErrorScreen(error: state.extra as String?),
          ),
          GoRoute(
            path: LoginScreen.routeName,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: CompleteProfileScreen.routeName,
            builder: (context, state) => const CompleteProfileScreen(),
          ),
          GoRoute(
            path: ProfileScreen.routeName,
            builder: (context, state) =>
                ProfileScreen(isBack: state.extra as bool? ?? false),
          ),
          GoRoute(
            path: EditProfileScreen.routeName,
            builder: (context, state) {
              final user = state.extra as UserModel?;
              return EditProfileScreen(user: user);
            },
          ),
          GoRoute(
            path: BaseScreen.routeName,
            builder: (context, state) => const BaseScreen(),
          ),
          GoRoute(
            path: OrderStepOneSelectRouteScreen.routeName,
            builder: (context, state) => const OrderStepOneSelectRouteScreen(),
          ),
          GoRoute(
            path: OrderStepTwoPackageDetailsScreen.routeName,
            builder: (context, state) {
              final routeDetails = state.extra as OrderRouteDetailsDraft?;
              return OrderStepTwoPackageDetailsScreen(
                routeDetails: routeDetails,
              );
            },
          ),
          GoRoute(
            path: OrderStepThreePickupDetailsScreen.routeName,
            builder: (context, state) {
              final draft = state.extra as OrderPackageDetailsDraft?;
              return OrderStepThreePickupDetailsScreen(draft: draft);
            },
          ),
          GoRoute(
            path: OrderStepFourReviewOrderScreen.routeName,
            builder: (context, state) {
              final reviewDraft = state.extra as OrderReviewDraft?;
              if (reviewDraft == null) {
                return const OrderStepThreePickupDetailsScreen();
              }
              return OrderStepFourReviewOrderScreen(reviewDraft: reviewDraft);
            },
          ),
          GoRoute(
            path: LiveDeliveryTrackingScreen.routeName,
            builder: (context, state) {
              final extra = state.extra;
              if (extra is LiveDeliveryScreenArgs) {
                return LiveDeliveryTrackingScreen(args: extra);
              }
              if (extra is String) {
                return LiveDeliveryTrackingScreen(
                  args: LiveDeliveryScreenArgs(orderId: extra),
                );
              }
              return LiveDeliveryTrackingScreen(
                args: const LiveDeliveryScreenArgs(orderId: 'WS-8291'),
              );
            },
          ),
          GoRoute(
            path: OrderHistoryScreen.routeName,
            builder: (context, state) => const OrderHistoryScreen(isBack: true),
          ),
          GoRoute(
            path: SettingsScreen.routeName,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
