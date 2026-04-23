import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/custom_snack_bar.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class LiveDeliverySideFabs extends StatelessWidget {
  const LiveDeliverySideFabs({
    super.key,
    required this.bottomOffset,
    required this.onRecenterMap,
  });

  final double bottomOffset;
  final VoidCallback onRecenterMap;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final bg = isDark ? AppColors.darkCard : AppColors.lightTextPrimary;
    final iconColor = isDark ? AppColors.white : AppColors.white;

    Widget fab(IconData icon, VoidCallback onTap) {
      return Material(
        color: bg,
        elevation: 4,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
        ),
      );
    }

    return PositionedDirectional(
      end: 16.w,
      bottom: bottomOffset + 16.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          fab(Icons.my_location_rounded, onRecenterMap),
          SizedBox(height: 12.h),
          fab(Icons.layers_outlined, () {
            CustomSnackBar.showInfo(context, 'live_delivery_map_layers_soon');
          }),
        ],
      ),
    );
  }
}
