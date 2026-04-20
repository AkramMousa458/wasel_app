import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/order/presentation/widgets/order_steps_text_widget.dart';

class OrderStepTwoHeader extends StatelessWidget {
  const OrderStepTwoHeader({
    super.key,
    required this.isDark,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
  });

  final bool isDark;
  final int currentStep;
  final int totalSteps;
  final String title;

  @override
  Widget build(BuildContext context) {
    final fg = AppColors.white;
    final progress = (currentStep / totalSteps).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 22.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F74FF), Color(0xFF0D4EC7)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Material(
            color: Colors.white.withValues(alpha: 0.16),
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
          SizedBox(height: 8.h),
          Text(
            translate('order_create_order'),
            style: AppStyles.textstyle16.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.textstyle30.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              OrderStepsTextWidget(
                currentStep: currentStep,
                totalSteps: totalSteps,
                color: isDark ? AppColors.darkInputFill : AppColors.lightCard,
                textColor: isDark ? AppColors.white : AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: Colors.black.withValues(alpha: 0.22),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
