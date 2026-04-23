import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/notifications/data/models/notification_item.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppStyles.textstyle18.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      item.timeLabel,
                      style: AppStyles.textstyle12.copyWith(
                        color: subtitleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  item.message,
                  style: AppStyles.textstyle14.copyWith(
                    color: subtitleColor,
                    height: 1.35,
                  ),
                ),
                if (item.actionPrimaryLabel != null &&
                    item.actionSecondaryLabel != null)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Row(
                      children: [
                        _ActionPill(
                          label: item.actionPrimaryLabel!,
                          isPrimary: true,
                        ),
                        SizedBox(width: 8.w),
                        _ActionPill(
                          label: item.actionSecondaryLabel!,
                          isPrimary: false,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.label, required this.isPrimary});

  final String label;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary : AppColors.lightInputFill,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        label,
        style: AppStyles.textstyle14Bold.copyWith(
          color: isPrimary ? AppColors.white : AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}
