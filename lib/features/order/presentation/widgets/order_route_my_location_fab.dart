import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class OrderRouteMyLocationFab extends StatelessWidget {
  const OrderRouteMyLocationFab({
    super.key,
    required this.onPressed,
    this.bottomOffset = 0,
  });

  final VoidCallback onPressed;
  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return Positioned(
      right: 16.w,
      bottom: bottomOffset + 16.h,
      child: Material(
        color: isDark ? AppColors.darkCard : AppColors.white,
        elevation: 4,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Icon(
              Icons.my_location_rounded,
              color: isDark ? AppColors.white : AppColors.primary,
              size: 22.sp,
            ),
          ),
        ),
      ),
    );
  }
}
