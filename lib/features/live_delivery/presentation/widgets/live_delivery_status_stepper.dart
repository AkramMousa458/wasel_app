import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';

/// Horizontal delivery timeline (LTR for consistent stage order in AR/EN).
class LiveDeliveryStatusStepper extends StatelessWidget {
  const LiveDeliveryStatusStepper({super.key, required this.currentStepIndex});

  /// 0 = assigned … 3 = delivered (active highlight).
  final int currentStepIndex;

  static const List<String> _labelKeys = [
    'live_delivery_step_assigned',
    'live_delivery_step_picking_up',
    'live_delivery_step_on_the_way',
    'live_delivery_step_delivered',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final inactiveLine = isDark
        ? AppColors.darkTextSecondary.withValues(alpha: 0.35)
        : AppColors.lightBorder;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var i = 0; i < 4; i++) ...[
                  _StepDot(
                    isActive: i == currentStepIndex,
                    isCompleted: i < currentStepIndex,
                    isDark: isDark,
                  ),
                  if (i < 3)
                    Expanded(
                      child: Container(
                        height: 3.h,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: currentStepIndex > i
                              ? AppColors.secondary
                              : inactiveLine,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                ],
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                for (var i = 0; i < 4; i++)
                  Expanded(
                    child: Text(
                      translate(_labelKeys[i]),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.textstyle10.copyWith(
                        color: _labelColor(i, isDark),
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _labelColor(int i, bool isDark) {
    final active = i <= currentStepIndex;
    if (active) {
      return isDark ? AppColors.white : AppColors.lightTextPrimary;
    }
    return isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.isActive,
    required this.isCompleted,
    required this.isDark,
  });

  final bool isActive;
  final bool isCompleted;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final on = isActive || isCompleted;
    final dotColor = on
        ? AppColors.secondary
        : (isDark
              ? AppColors.darkTextSecondary.withValues(alpha: 0.5)
              : AppColors.lightTextSecondary.withValues(alpha: 0.55));

    return Container(
      width: 14.w,
      height: 14.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dotColor,
        border: Border.all(
          color: isActive ? AppColors.secondary : Colors.transparent,
          width: isActive ? 2.5 : 0,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.35),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
    );
  }
}
