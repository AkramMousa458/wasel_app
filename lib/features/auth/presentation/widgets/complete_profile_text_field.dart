import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class CompleteProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final bool isRequired;
  final String? Function(String?)? validator;
  final bool isDark;
  final TextInputType? keyboardType;
  final String? suffixText;

  const CompleteProfileTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isRequired = false,
    this.validator,
    required this.isDark,
    this.keyboardType,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: AppStyles.textstyle14.copyWith(
        color: isDark ? AppColors.white : AppColors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyles.textstyle12.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.darkInputFill
            : AppColors.lightInputFill, // Using input fill colors
        prefixIcon: prefixIcon,
        suffixText: suffixText,
        suffixStyle: AppStyles.textstyle10.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r), // Rounded as per design
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
      ),
    );
  }
}
