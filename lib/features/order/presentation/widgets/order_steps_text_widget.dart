import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class OrderStepsTextWidget extends StatelessWidget {
  const OrderStepsTextWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.color,
    this.textColor,
  });

  final int currentStep;
  final int totalSteps;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        translate(
          'order_step_format',
          args: {'current': '$currentStep', 'total': '$totalSteps'},
        ),
        style: AppStyles.textstyle12.copyWith(
          color:textColor ?? AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
