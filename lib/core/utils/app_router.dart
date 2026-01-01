import 'package:go_router/go_router.dart';
import 'package:wasel/features/auth/presentation/screens/login_screen.dart';
import 'package:wasel/features/base/presentation/screens/base_screen.dart';
import 'package:wasel/features/order_history/presentation/screens/order_history_screen.dart';
import 'package:wasel/features/splash/presentation/screens/splash_screen.dart';

abstract class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: BaseScreen.routeName,
        builder: (context, state) => const BaseScreen(),
      ),
      GoRoute(
        path: OrderHistoryScreen.routeName,
        builder: (context, state) => const OrderHistoryScreen(isBack: true),
      ),
    ],
  );
}
