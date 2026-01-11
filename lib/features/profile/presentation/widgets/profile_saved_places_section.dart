import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/profile/presentation/widgets/saved_place_card.dart';

class ProfileSavedPlacesSection extends StatelessWidget {
  final bool isDark;

  const ProfileSavedPlacesSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Saved Places Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              translate('saved_places'),
              style: AppStyles.textstyle16.copyWith(
                color: isDark ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 16.sp, color: AppColors.secondary),
              label: Text(
                translate('add_new'),
                style: AppStyles.textstyle14.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Saved Places List
        SavedPlaceCard(
          isDark: isDark,
          title: translate('home'),
          address: '123 Design Street, Apt 4B',
          icon: Icons.home,
          iconColor: AppColors.secondary,
        ),
        SavedPlaceCard(
          isDark: isDark,
          title: translate('work'),
          address: 'Tech Hub, Building C',
          icon: Icons.work,
          iconColor: const Color(0xFF3B82F6), // Blue
        ),
      ],
    );
  }
}
