import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel/features/profile/presentation/screens/add_edit_address_screen.dart';
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
              onPressed: () => _navigateToAddEditAddress(context),
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
          ..._getSortedAddresses(
            user.savedAddresses,
          ).map((address) => _buildAddressCard(context, address)),
      ],
    );
  }

  List<SavedAddress> _getSortedAddresses(List<SavedAddress> addresses) {
    // Create a mutable copy to sort
    final sortedList = List<SavedAddress>.from(addresses);
    sortedList.sort((a, b) {
      if (a.isDefault) return -1;
      if (b.isDefault) return 1;
      return 0;
    });
    return sortedList;
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

  Widget _buildAddressCard(BuildContext context, SavedAddress savedAddress) {
    return SavedPlaceCard(
      isDark: isDark,
      title: savedAddress.label,
      address: _formatAddress(savedAddress.address),
      icon: _getIcon(savedAddress.label),
      iconColor: _getIconColor(savedAddress.label),
      isDefault: savedAddress.isDefault,
      onEdit: () => _navigateToAddEditAddress(context, address: savedAddress),
      onDelete: () => _showDeleteConfirmation(context, savedAddress),
      onTap: () => _showAddressDetailsBottomSheet(context, savedAddress),
    );
  }

  void _showAddressDetailsBottomSheet(
    BuildContext context,
    SavedAddress address,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkInputFill
                        : AppColors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: _getIconColor(
                        address.label,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      _getIcon(address.label),
                      color: _getIconColor(address.label),
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.label,
                          style: AppStyles.textstyle18.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                        if (address.isDefault)
                          Container(
                            margin: EdgeInsets.only(top: 4.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              'Default', // translate('default')
                              style: AppStyles.textstyle10.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              _buildDetailItem(
                context,
                icon: Icons.location_on_outlined,
                title: translate('governorate'),
                value: address.address.governorate,
              ),
              _buildDetailItem(
                context,
                icon: Icons.location_city_outlined,
                title: translate('city'),
                value: address.address.city,
              ),
              _buildDetailItem(
                context,
                icon: Icons.add_road_outlined,
                title: translate('street'),
                value: address.address.street,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      icon: Icons.apartment_outlined,
                      title: translate('building'),
                      value: address.address.building,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      icon: Icons.layers_outlined,
                      title: translate('floor'),
                      value: address.address.floor,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      icon: Icons.door_front_door_outlined,
                      title: translate('door'),
                      value: address.address.door,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Optionally trigger 'use this address' logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    translate('close'), // Or 'Select Address'
                    style: AppStyles.textstyle16.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    if (value.isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.textstyle12.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.grey,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AppStyles.textstyle14.copyWith(
                    color: isDark ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddEditAddress(
    BuildContext context, {
    SavedAddress? address,
  }) {
    // Pass the existing cubit instance to the new screen
    final cubit = context.read<ProfileCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: AddEditAddressScreen(address: address),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, SavedAddress address) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(translate('confirm_delete_address')),
        content: Text(translate('delete_address_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (address.id != null) {
                context.read<ProfileCubit>().deleteAddress(address.id!);
              }
            },
            child: Text(
              translate('delete'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
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
