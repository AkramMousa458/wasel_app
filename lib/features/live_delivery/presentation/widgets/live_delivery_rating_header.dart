import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class LiveDeliveryRatingHeader extends StatelessWidget {
  const LiveDeliveryRatingHeader({super.key, required this.receiverName});

  final String receiverName;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Column(
      children: [
        Container(
          width: 180.w,
          height: 180.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              colors: [Color(0xFFF4D093), Color(0xFFE5B867)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Text('📦', style: TextStyle(fontSize: 72.sp)),
          ),
        ),
        SizedBox(height: 18.h),
        Text(
          translate('live_delivery_rating_hooray'),
          style: AppStyles.textstyle30.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          translate('live_delivery_rating_delivered'),
          textAlign: TextAlign.center,
          style: AppStyles.textstyle30.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        SizedBox(height: 6.h),
        Text.rich(
          TextSpan(
            style: AppStyles.textstyle16.copyWith(color: subtitleColor),
            children: [
              TextSpan(text: '${translate('live_delivery_rating_reached')} '),
              TextSpan(
                text: receiverName,
                style: AppStyles.textstyle16.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: ' ${translate('live_delivery_rating_safely')}'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
