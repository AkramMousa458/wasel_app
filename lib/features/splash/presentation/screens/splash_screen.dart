// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/assets.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/auth/presentation/screens/login_screen.dart';
import 'package:wasel/features/base/presentation/screens/base_screen.dart';

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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _handleNavigation();
    // });
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      final token = locator<LocalStorage>().authToken;
      log('🔑 Akram Token: $token');

      if (token != null) {
        GoRouter.of(context).go(BaseScreen.routeName);
      } else {
        log('❌ Splash error token is null');
        if (mounted) {
          GoRouter.of(context).go(BaseScreen.routeName);
          // GoRouter.of(context).go(LoginScreen.routeName);
        }
      }
      // تحقق من بيانات المستخدم
    } catch (e, s) {
      log('❌ Splash error: $e\n$s');
      if (mounted) {
        GoRouter.of(context).go(LoginScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: Image.asset(Assets.logo),
              );
            },
          ),
        ),
      ),
    );
  }
}
