import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtils.isDark(context);
    Color baseColor = isDark ? AppColors.darkCard : Colors.grey[300]!;
    Color highlightColor = isDark ? AppColors.darkInputFill : Colors.grey[100]!;
    Color cardColor = isDark ? AppColors.darkCard : Colors.white;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header similar to ProfileHeader
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
              child: Column(
                children: [
                  CircleAvatar(radius: 50.r, backgroundColor: cardColor),
                  SizedBox(height: 16.h),
                  Container(
                    width: 150.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 100.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Personal Info Card Shimmer
                  Container(
                    height: 200.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Saved Places Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 100.w, height: 20.h, color: cardColor),
                      Container(width: 80.w, height: 20.h, color: cardColor),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Saved Places List
                  Container(
                    height: 80.h,
                    width: double.infinity,
                    color: cardColor,
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 80.h,
                    width: double.infinity,
                    color: cardColor,
                  ),
                  SizedBox(height: 16.h),

                  // Settings Menu Container
                  Container(
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
