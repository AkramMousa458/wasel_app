import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_dialogs.dart';

class SettingsLogoutButton extends StatelessWidget {
  final bool isDark;

  const SettingsLogoutButton({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          AppDialogs.showLogoutDialog(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.error500.withValues(alpha: 0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: AppColors.error500, size: 20.r),
              SizedBox(width: 8.w),
              Text(
                translate('log_out'),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
