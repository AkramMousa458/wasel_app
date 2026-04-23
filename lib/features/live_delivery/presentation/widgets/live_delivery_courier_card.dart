import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class LiveDeliveryCourierCard extends StatelessWidget {
  const LiveDeliveryCourierCard({
    super.key,
    required this.name,
    required this.rating,
    required this.avatarUrl,
  });

  final String name;
  final double rating;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Padding(
      padding: EdgeInsets.only(top: 22.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: (avatarUrl == null || avatarUrl!.isEmpty)
                    ? Icon(
                        Icons.person_rounded,
                        size: 32.sp,
                        color: AppColors.primary,
                      )
                    : null,
              ),
              PositionedDirectional(
                end: -2,
                bottom: -2,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: AppColors.lightTextPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    color: AppColors.secondary,
                    size: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppStyles.textstyle18.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.secondary,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppStyles.textstyle14Bold.copyWith(
                        color: titleColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text('•', style: TextStyle(color: subtitleColor)),
                    ),
                    Icon(
                      Icons.two_wheeler_rounded,
                      color: subtitleColor,
                      size: 18.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      translate('live_delivery_vehicle_scooter'),
                      style: AppStyles.textstyle14.copyWith(
                        color: subtitleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
