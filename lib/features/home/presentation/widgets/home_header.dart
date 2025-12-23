import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // User Avatar
            Stack(
              children: [
                // User Photo
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: isDark
                      ? AppColors.darkCard
                      : AppColors.lightCard,
                  child: Icon(
                    FontAwesomeIcons.solidUser,
                    size: 30.r,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                // Green Dot Online
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 15.r,
                    height: 15.r,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? AppColors.lightTextPrimary
                            : AppColors.white,
                        width: 2,
                      ),
                      color: AppColors.success500,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('أكرم باشا!'),
                  style: AppStyles.textstyle16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 2.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.locationDot,
                          size: 14.r,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Cairo, Egypt',
                          style: AppStyles.textstyle12.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Icon(
                          FontAwesomeIcons.chevronDown,
                          size: 10.r,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w),
          ],
        ),

        IconButton(
          onPressed: () {},
          iconSize: 22.r,
          icon: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(FontAwesomeIcons.solidBell),
                Positioned(
                  top: -5,
                  right: -3,
                  child: Container(
                    width: 11.r,
                    height: 11.r,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? AppColors.lightTextPrimary
                            : AppColors.white,
                        width: 2,
                      ),
                      color: isDark ? AppColors.error500 : AppColors.error500,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
