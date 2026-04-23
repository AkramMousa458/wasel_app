import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class LiveDeliveryRatingCard extends StatelessWidget {
  const LiveDeliveryRatingCard({
    super.key,
    required this.courierName,
    required this.vehicle,
    required this.ratingValue,
    required this.onRatingChanged,
    required this.courierAvatarUrl,
  });

  final String courierName;
  final String vehicle;
  final int ratingValue;
  final ValueChanged<int> onRatingChanged;
  final String? courierAvatarUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final chipBg = isDark ? AppColors.darkInputFill : AppColors.lightInputFill;

    Widget feedbackChip(String text, bool highlight) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: highlight ? AppColors.secondary : chipBg,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(
          text,
          style: AppStyles.textstyle14.copyWith(
            color: highlight ? AppColors.lightTextPrimary : titleColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34.r,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            backgroundImage:
                (courierAvatarUrl != null && courierAvatarUrl!.isNotEmpty)
                ? NetworkImage(courierAvatarUrl!)
                : null,
            child: (courierAvatarUrl == null || courierAvatarUrl!.isEmpty)
                ? Icon(
                    Icons.person_rounded,
                    size: 34.sp,
                    color: AppColors.primary,
                  )
                : null,
          ),
          SizedBox(height: 10.h),
          Text(
            translate(
              'live_delivery_rating_how_was',
              args: {'name': courierName},
            ),
            style: AppStyles.textstyle25.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            translate(
              'live_delivery_rating_vehicle_line',
              args: {'vehicle': vehicle},
            ),
            style: AppStyles.textstyle12.copyWith(
              color: subtitleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final idx = i + 1;
              return IconButton(
                onPressed: () => onRatingChanged(idx),
                icon: Icon(
                  Icons.star_rounded,
                  size: 36.sp,
                  color: idx <= ratingValue
                      ? AppColors.secondary
                      : subtitleColor.withValues(alpha: 0.45),
                ),
              );
            }),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: [
              feedbackChip(
                '🚀 ${translate('live_delivery_tag_super_fast')}',
                false,
              ),
              feedbackChip(
                '🙂 ${translate('live_delivery_tag_friendly')}',
                true,
              ),
              feedbackChip(
                '📦 ${translate('live_delivery_tag_careful_handling')}',
                false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
