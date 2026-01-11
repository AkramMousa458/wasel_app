import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/features/app/presentation/manager/app_cubit.dart';
import 'package:wasel/features/app/presentation/manager/app_state.dart';
import 'package:wasel/features/auth/presentation/screens/complete_profile_screen.dart';
import 'package:wasel/features/auth/presentation/screens/login_screen.dart';
import 'package:wasel/features/base/presentation/screens/base_screen.dart';

class AppGate extends StatefulWidget {
  final Widget child;
  const AppGate({super.key, required this.child});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  @override
  void initState() {
    super.initState();
    // Check initial state in case the listener missed the transition
    // widgets binding to ensure context is valid for navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AppCubit>().state;
      _onAppStateChanged(context, state);
    });
  }

  void _onAppStateChanged(BuildContext context, AppState state) {
    if (state is AppUnauthenticated) {
      context.go(LoginScreen.routeName);
    } else if (state is AppIncompleteProfile) {
      context.go(CompleteProfileScreen.routeName);
    } else if (state is AppUserBanned) {
      //TODO: show banned screen
    } else if (state is AppUserDeleted) {
      //TODO: show deleted screen
    } else if (state is AppAuthenticated) {
      // If we are authenticated, but currently on a "Guest Only" route (like Login, Splash, CompleteProfile),
      // then redirect to Home (BaseScreen).
      // Otherwise (if we are on Settings, Details, etc.), stay where we are.
      context.go(BaseScreen.routeName);
      // final String location = GoRouterState.of(context).uri.toString();

      // final isGuestRoute =
      //     location == LoginScreen.routeName ||
      //     location == SplashScreen.routeName ||
      //     location == CompleteProfileScreen.routeName;

      // if (isGuestRoute) {
      //   context.go(BaseScreen.routeName);
      // }
    } else if (state is AppLogout) {
      context.go(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: _onAppStateChanged,
      listenWhen: (previous, current) =>
          true, // Listen to all state changes including re-emissions of same state type if any
      child: widget.child,
    );
  }
}
