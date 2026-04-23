import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class LiveDeliveryArrivalHeader extends StatelessWidget {
  const LiveDeliveryArrivalHeader({
    super.key,
    required this.etaMinutes,
    required this.courierName,
  });

  final int etaMinutes;
  final String courierName;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: AppStyles.textstyle22.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
            children: [
              TextSpan(text: '${translate('live_delivery_arriving_in')} '),
              TextSpan(
                text: translate(
                  'live_delivery_eta_mins',
                  args: {'n': '$etaMinutes'},
                ),
                style: AppStyles.textstyle22.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          translate(
            'live_delivery_courier_on_way',
            args: {'name': courierName},
          ),
          style: AppStyles.textstyle15.copyWith(
            color: subtitleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
