// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/assets.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/auth/presentation/screens/complete_profile_screen.dart';
import 'package:wasel/features/auth/presentation/screens/login_screen.dart';
import 'package:wasel/features/base/presentation/screens/base_screen.dart';
import 'package:wasel/features/profile/presentation/manager/profile_cubit.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      final token = locator<LocalStorage>().authToken;
      log('🔑 Akram Token: $token');

      if (token != null) {
        // فقط جلب البروفايل لو فيه token
        final user = locator<LocalStorage>().getUserProfile();
        if (user != null) {
          await context.read<ProfileCubit>().getProfile();
          if (user.name!.ar.isNotEmpty) {
            GoRouter.of(context).go(BaseScreen.routeName);
          } else {
            GoRouter.of(context).go(CompleteProfileScreen.routeName);
          }
        } else {
          // لو المستخدم موجودش في التخزين
          GoRouter.of(context).go(CompleteProfileScreen.routeName);
        }
      } else {
        log('❌ Splash error token is null');
        GoRouter.of(context).go(LoginScreen.routeName);
      }
    } catch (e, s) {
      log('❌ Splash error: $e\n$s');
      if (mounted) {
        GoRouter.of(context).go(LoginScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 130.w),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Image.asset(isDark ? Assets.logoWhite : Assets.logo),
              );
            },
          ),
        ),
      ),
    );
  }
}
