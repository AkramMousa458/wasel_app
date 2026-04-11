import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class OrderRouteAppBar extends StatelessWidget {
  const OrderRouteAppBar({
    super.key,
    required this.isDark,
    required this.currentStep,
    required this.totalSteps,
  });

  final bool isDark;
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? AppColors.white : AppColors.lightTextPrimary;
    // final fg = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final barBg = isDark
        ? AppColors.darkCard.withValues(alpha: 0.92)
        : AppColors.white.withValues(alpha: 0.95);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: barBg,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: fg,
                    size: 18.sp,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  translate(
                    'order_step_format',
                    args: {'current': '$currentStep', 'total': '$totalSteps'},
                  ),
                  style: AppStyles.textstyle12.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 6.h,
            left: 0,
            right: 0,
            // bottom: 0,
            child: Text(
              translate('order_select_route'),
              textAlign: TextAlign.center,
              style: AppStyles.textstyle16.copyWith(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
