import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/features/home/presentation/widgets/activity_card.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              translate('recent_activity'),
              style: isDark
                  ? AppStyles.textstyle18.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    )
                  : AppStyles.textstyle18.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                translate('see_all'),
                style: AppStyles.textstyle14.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ActivityCard(isDark: isDark),
      ],
    );
  }
}
