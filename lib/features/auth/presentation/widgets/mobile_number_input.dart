import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class MobileNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCountryCode;
  final bool isDark;
  final String? Function(String?)? validator;

  const MobileNumberInput({
    super.key,
    required this.controller,
    required this.selectedCountryCode,
    required this.isDark,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate('mobile_number'),
          style: AppStyles.textstyle12.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country code selector
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkInputFill
                    : AppColors.lightInputFill,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇪🇬', style: TextStyle(fontSize: 20.sp)),
                  SizedBox(width: 6.w),
                  Text(
                    selectedCountryCode,
                    style: AppStyles.textstyle16.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 20.w,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Phone number input
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                validator: validator,
                style: AppStyles.textstyle16.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: '01xx xxx xxxx',
                  hintStyle: AppStyles.textstyle16.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  errorStyle: AppStyles.textstyle12.copyWith(color: Colors.red),
                  errorMaxLines: 2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primary, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkInputFill
                      : AppColors.lightInputFill,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
