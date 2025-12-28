import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class SavedPlaceCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String address;
  final IconData icon;
  final Color iconColor;

  const SavedPlaceCard({
    super.key,
    required this.isDark,
    required this.title,
    required this.address,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: 0.2,
              ), // Light variant of the color
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.textstyle16.copyWith(
                    color: isDark ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  address,
                  style: AppStyles.textstyle12.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
