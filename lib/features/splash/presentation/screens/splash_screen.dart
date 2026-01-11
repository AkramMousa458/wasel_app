import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/assets.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/';

  const SplashScreen({super.key});

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
