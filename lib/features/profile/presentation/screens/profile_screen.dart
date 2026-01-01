import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/local_storage.dart' show LocalStorage;
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/auth/presentation/screens/login_screen.dart';
import 'package:wasel/features/profile/presentation/widgets/personal_info_card.dart';
import 'package:wasel/features/profile/presentation/widgets/profile_header.dart';
import 'package:wasel/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:wasel/features/profile/presentation/widgets/saved_place_card.dart';
import 'package:wasel/core/widgets/custom_confirmation_dialog.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile-screen';
  final bool isBack;
  const ProfileScreen({super.key, required this.isBack});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkScaffold
          : AppColors.lightScaffold,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            ProfileHeader(isDark: isDark, isBack: isBack),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Personal Info Card
                  PersonalInfoCard(isDark: isDark),
                  SizedBox(height: 32.h),

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
                        icon: Icon(
                          Icons.add,
                          size: 16.sp,
                          color: AppColors.secondary,
                        ),
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
                  SizedBox(height: 16.h),

                  // Settings Menu Container
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          isDark: isDark,
                          title: translate('payment_methods'),
                          icon: Icons.payment,
                          onTap: () {},
                        ),
                        Divider(
                          indent: 56.w,
                          height: 1,
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                        ProfileMenuItem(
                          isDark: isDark,
                          title: translate('notifications'),
                          icon: Icons.notifications,
                          onTap: () {},
                          trailing: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: const BoxDecoration(
                              color: AppColors.error500,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '2',
                              style: AppStyles.textstyle10.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          indent: 56.w,
                          height: 1,
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ],
                    ),
                  ),
                  ProfileMenuItem(
                    isDark: isDark,
                    title: translate('log_out'),
                    icon: Icons.logout,
                    textColor: AppColors.error500,
                    // For Log Out, usually no trailing arrow, but design might vary.
                    // The screenshot shows just the text and icon.
                    trailing: const SizedBox.shrink(),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomConfirmationDialog(
                          title: translate('log_out'),
                          message: translate('confirm_logout_message'),
                          confirmButtonText: translate('log_out'),
                          cancelButtonText: translate('cancel'),
                          isDestructive: true,
                          onConfirm: () {
                            locator<LocalStorage>().logout();
                            context.go(LoginScreen.routeName);
                          },
                        ),
                      );
                    },
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
