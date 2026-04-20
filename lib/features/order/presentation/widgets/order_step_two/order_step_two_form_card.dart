import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'dart:io';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/features/order/presentation/widgets/order_step_two/order_step_two_size_selector.dart';

class OrderStepTwoFormCard extends StatelessWidget {
  const OrderStepTwoFormCard({
    super.key,
    required this.isDark,
    required this.selectedSize,
    required this.onSizeChanged,
    required this.detailsController,
    required this.formKey,
    required this.imagePath,
    required this.onUploadTap,
    required this.onContinueTap,
  });

  final bool isDark;
  final String? selectedSize;
  final ValueChanged<String> onSizeChanged;
  final TextEditingController detailsController;
  final GlobalKey<FormState> formKey;
  final String? imagePath;
  final VoidCallback onUploadTap;
  final VoidCallback onContinueTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final inputColor = isDark
        ? const Color(0xFF0F1D3C)
        : const Color(0xFF1C2B4A);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: translate('order_item_photo'),
            trailing: '(${translate('optional')})',
            color: titleColor,
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: onUploadTap,
            borderRadius: BorderRadius.circular(16.r),
            child: Ink(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: imagePath == null ? 28.h : 8.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF9CF8D), Color(0xFFF7BC6B)],
                ),
              ),
              child: imagePath == null
                  ? Column(
                      children: [
                        Icon(
                          Icons.add_a_photo_rounded,
                          color: AppColors.primary,
                          size: 28.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          translate('order_tap_upload_image'),
                          style: AppStyles.textstyle14.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            File(imagePath!),
                            width: double.infinity,
                            height: 120.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        PositionedDirectional(
                          top: 6.h,
                          end: 6.w,
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(height: 16.h),
          _SectionTitle(title: translate('order_details'), color: titleColor),
          SizedBox(height: 8.h),
          Form(
            key: formKey,
            child: TextFormField(
              controller: detailsController,
              minLines: 2,
              maxLines: 3,
              // style: AppStyles.textstyle16.copyWith(color: Colors.white),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return translate('order_details_required');
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark
                    ? AppColors.darkInputFill
                    : AppColors.lightInputFill,
                // fillColor: inputColor,
                hintText: translate('order_details_hint'),
                hintStyle: AppStyles.textstyle16.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.4,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.error500),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.error500,
                    width: 1.4,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          _SectionTitle(
            title: translate('order_package_size'),
            color: titleColor,
          ),
          SizedBox(height: 10.h),
          OrderStepTwoSizeSelector(
            isDark: isDark,
            selectedSize: selectedSize,
            onChanged: onSizeChanged,
          ),
          SizedBox(height: 20.h),
          CustomButton(
            text: 'order_continue_to_pickup',
            onPressed: onContinueTap,
            borderRadius: 16.r,
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_forward_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.color,
    this.trailing,
  });

  final String title;
  final String? trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppStyles.textstyle12.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        if (trailing != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 6.w),
            child: Text(
              trailing!,
              style: AppStyles.textstyle12.copyWith(
                color: color.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
