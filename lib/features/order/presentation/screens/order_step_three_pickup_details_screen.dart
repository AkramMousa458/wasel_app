import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/features/order/data/models/order_package_details_draft.dart';
import 'package:wasel/features/order/presentation/widgets/order_step_two/order_step_two_header.dart';

class OrderStepThreePickupDetailsScreen extends StatelessWidget {
  const OrderStepThreePickupDetailsScreen({super.key, required this.draft});

  static const String routeName = '/order/pickup-details';

  final OrderPackageDetailsDraft draft;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OrderStepTwoHeader(
              isDark: isDark,
              currentStep: 3,
              totalSteps: 5,
              title: translate('order_pickup_details_title'),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('order_step_three_connected'),
                        style: AppStyles.textstyle16.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      if (draft.imagePath != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            File(draft.imagePath!),
                            width: double.infinity,
                            height: 130.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                      _InfoRow(
                        label: translate('order_package_size'),
                        value: _localizedPackageSize(draft.packageSize),
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                      SizedBox(height: 10.h),
                      _InfoRow(
                        label: translate('order_details'),
                        value: draft.details,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                      const Spacer(),
                      CustomButton(
                        text: 'order_continue',
                        onPressed: () {},
                        borderRadius: 16.r,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _localizedPackageSize(String sizeId) {
    switch (sizeId) {
      case 'small':
        return translate('order_package_small');
      case 'medium':
        return translate('order_package_medium');
      case 'large':
        return translate('order_package_large');
      default:
        return sizeId;
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final String label;
  final String value;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.textstyle12.copyWith(
            color: secondaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppStyles.textstyle14.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
