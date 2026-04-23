import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/custom_snack_bar.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class LiveDeliveryChatCallRow extends StatelessWidget {
  const LiveDeliveryChatCallRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final callBg = isDark ? AppColors.darkInputFill : AppColors.lightInputFill;

    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        children: [
          Material(
            color: callBg,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                CustomSnackBar.showInfo(context, 'live_delivery_call_soon');
              },
              child: Padding(
                padding: EdgeInsets.all(14.r),
                child: Icon(
                  Icons.phone_rounded,
                  color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                  size: 22.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Material(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(30.r),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  CustomSnackBar.showInfo(context, 'live_delivery_chat_soon');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.lightTextPrimary,
                        size: 22.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        translate('live_delivery_chat'),
                        style: AppStyles.textstyle16.copyWith(
                          color: AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
