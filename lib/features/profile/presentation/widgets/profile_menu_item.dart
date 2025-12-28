import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final bool isDark;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? textColor;

  const ProfileMenuItem({
    super.key,
    required this.isDark,
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 2.h,
      ), // Separator handled by screen or list
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          leading: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color:
                  textColor ??
                  (isDark ? Colors.blue.shade200 : const Color(0xFF0F172A)),
              size: 20.sp,
            ),
          ),
          title: Text(
            title,
            style: AppStyles.textstyle14.copyWith(
              color: textColor ?? (isDark ? AppColors.white : AppColors.black),
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing:
              trailing ??
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              ),
        ),
      ),
    );
  }
}
