import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/profile/presentation/widgets/saved_place_card.dart';

class ProfileSavedPlacesSection extends StatelessWidget {
  final bool isDark;
  final UserModel user;

  const ProfileSavedPlacesSection({
    super.key,
    required this.isDark,
    required this.user,
  });

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
              onPressed: () {
                // TODO: Navigate to add address screen
              },
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
        if (user.savedAddresses.isEmpty)
          _buildEmptyState()
        else
          ...user.savedAddresses.map((address) => _buildAddressCard(address)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 48.sp,
            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
          ),
          SizedBox(height: 12.h),
          Text(
            translate('no_saved_places'),
            style: AppStyles.textstyle14.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(SavedAddress savedAddress) {
    return SavedPlaceCard(
      isDark: isDark,
      title: savedAddress.label,
      address: _formatAddress(savedAddress.address),
      icon: _getIcon(savedAddress.label),
      iconColor: _getIconColor(savedAddress.label),
    );
  }

  String _formatAddress(AddressDetails address) {
    final parts = [
      address.street,
      address.building,
      address.floor,
      address.city,
    ].where((element) => element.isNotEmpty).toList();

    return parts.join(', ');
  }

  IconData _getIcon(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('home') || lowerLabel.contains('المنزل')) {
      return Icons.home_rounded;
    } else if (lowerLabel.contains('work') || lowerLabel.contains('العمل')) {
      return Icons.work_rounded;
    }
    return Icons.location_on_rounded;
  }

  Color _getIconColor(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('home') || lowerLabel.contains('المنزل')) {
      return AppColors.secondary;
    } else if (lowerLabel.contains('work') || lowerLabel.contains('العمل')) {
      return const Color(0xFF3B82F6); // Blue
    }
    return AppColors.primary;
  }
}
