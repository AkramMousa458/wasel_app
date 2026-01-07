import 'package:go_router/go_router.dart';
import 'package:wasel/core/widgets/error_screen.dart';
import 'package:wasel/features/app/presentation/components/app_shell.dart';
import 'package:wasel/features/auth/presentation/screens/complete_profile_screen.dart';
import 'package:wasel/features/auth/presentation/screens/login_screen.dart';
import 'package:wasel/features/base/presentation/screens/base_screen.dart';
import 'package:wasel/features/order_history/presentation/screens/order_history_screen.dart';
import 'package:wasel/features/settings/presentation/screens/settings_screen.dart';
import 'package:wasel/features/splash/presentation/screens/splash_screen.dart';

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
            path: BaseScreen.routeName,
            builder: (context, state) => const BaseScreen(),
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
