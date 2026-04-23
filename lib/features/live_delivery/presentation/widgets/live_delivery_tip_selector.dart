import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class LiveDeliveryTipSelector extends StatelessWidget {
  const LiveDeliveryTipSelector({
    super.key,
    required this.selectedTip,
    required this.onTipSelected,
  });

  final int selectedTip;
  final ValueChanged<int> onTipSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final chipBg = isDark ? AppColors.darkInputFill : AppColors.lightInputFill;

    Widget tipChip(int amount) {
      final selected = selectedTip == amount;
      return Expanded(
        child: InkWell(
          onTap: () => onTipSelected(amount),
          borderRadius: BorderRadius.circular(22.r),
          child: Container(
            height: 46.h,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : chipBg,
              borderRadius: BorderRadius.circular(22.r),
            ),
            alignment: Alignment.center,
            child: Text(
              '\$$amount',
              style: AppStyles.textstyle16.copyWith(
                color: selected ? AppColors.white : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                translate('live_delivery_tip_courier'),
                style: AppStyles.textstyle18.copyWith(
                  color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                translate('live_delivery_tip_note'),
                style: AppStyles.textstyle14.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              tipChip(1),
              SizedBox(width: 10.w),
              tipChip(3),
              SizedBox(width: 10.w),
              tipChip(5),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  height: 46.h,
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.edit_rounded,
                    color: subtitleColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
