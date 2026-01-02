import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/language/language_cubit.dart';
import 'package:wasel/core/theme/theme_cubit.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_header.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_section.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_item.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_toggle_item.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkScaffold
          : AppColors.lightScaffold,
      body: Column(
        children: [
          const SettingsHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserCard(isDark),
                  SizedBox(height: 24.h),
                  _buildAppPreferences(isDark),
                  SizedBox(height: 24.h),
                  _buildFinanceSection(isDark),
                  SizedBox(height: 24.h),
                  _buildSupportSection(isDark),
                  SizedBox(height: 24.h),
                  _buildLogoutButton(isDark),
                  SizedBox(height: 16.h),
                  _buildVersionInfo(isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: const NetworkImage(
                  'https://randomuser.me/api/portraits/men/32.jpg',
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16.r,
                  height: 16.r,
                  decoration: BoxDecoration(
                    color: AppColors.success500,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkCard : AppColors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ahmed Al-Farsi',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Wasel Pro Member',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () {
                // Navigate to edit profile
              },
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: Icon(Icons.edit, color: AppColors.primary, size: 20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppPreferences(bool isDark) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        final isArabic = locale.languageCode == 'ar';
        return SettingsSection(
          title: translate('app_preferences'),
          isDark: isDark,
          children: [
            SettingsItem(
              icon: Icons.language,
              iconColor: AppColors.primary,
              title: translate('language'),
              trailing: Text(
                isArabic ? '🇪🇬' : '🇺🇸',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              isDark: isDark,
              isTopBorderRaduis: true,
              onTap: () {
                context.read<LanguageCubit>().toggleLanguage();
              },
            ),
            SettingsToggleItem(
              icon: Icons.notifications,
              iconColor: const Color(0xFFFF9500),
              title: translate('notifications'),
              value: _notificationsEnabled,
              isDark: isDark,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            SettingsToggleItem(
              icon: Icons.dark_mode,
              iconColor: const Color(0xFF9C27B0),
              title: translate('dark_mode'),
              value:
                  context.read<ThemeCubit>().state.brightness ==
                  Brightness.dark,
              isDark: isDark,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
                _darkModeEnabled
                    ? context.read<ThemeCubit>().setDarkTheme()
                    : context.read<ThemeCubit>().setLightTheme();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFinanceSection(bool isDark) {
    return SettingsSection(
      title: translate('finance'),
      isDark: isDark,
      children: [
        SettingsItem(
          icon: Icons.credit_card,
          iconColor: const Color(0xFF34C759),
          title: translate('payment_methods'),
          isDark: isDark,
          onTap: () {
            // Navigate to payment methods
          },
        ),
        SettingsItem(
          icon: Icons.account_balance_wallet,
          iconColor: const Color(0xFF00C7BE),
          title: translate('wasel_wallet'),
          trailing: Text(
            '\$24.50',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          isDark: isDark,
          onTap: () {
            // Navigate to wallet
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection(bool isDark) {
    return SettingsSection(
      title: translate('support_info'),
      isDark: isDark,
      children: [
        SettingsItem(
          icon: Icons.help_outline,
          iconColor: const Color(0xFF007AFF),
          title: translate('help_center'),
          isDark: isDark,
          onTap: () {
            // Navigate to help center
          },
        ),
        SettingsItem(
          icon: Icons.privacy_tip_outlined,
          iconColor: const Color(0xFF5856D6),
          title: translate('privacy_policy'),
          isDark: isDark,
          onTap: () {
            // Navigate to privacy policy
          },
        ),
      ],
    );
  }

  Widget _buildLogoutButton(bool isDark) {
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          // Show logout confirmation dialog
          _showLogoutDialog();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.error500.withValues(alpha: 0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: AppColors.error500, size: 20.r),
              SizedBox(width: 8.w),
              Text(
                translate('log_out'),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo(bool isDark) {
    return Center(
      child: Text(
        'Wasel App v1.0.2 (Build 204)',
        style: TextStyle(
          fontSize: 12.sp,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate('confirm_logout')),
        content: Text(translate('logout_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              // Perform logout
              Navigator.pop(context);
            },
            child: Text(
              translate('log_out'),
              style: TextStyle(color: AppColors.error500),
            ),
          ),
        ],
      ),
    );
  }
}
