import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_app_preferences_section.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_finance_section.dart';
import 'package:wasel/core/widgets/custom_screen_header.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_logout_button.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_support_section.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_version_info.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkScaffold
          : AppColors.lightScaffold,
      body: Column(
        children: [
          const CustomScreenHeader(title: 'settings'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsAppPreferencesSection(
                    isDark: isDark,
                    notificationsEnabled: _notificationsEnabled,
                    onNotificationChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  SizedBox(height: 24.h),
                  SettingsFinanceSection(isDark: isDark),
                  SizedBox(height: 24.h),
                  SettingsSupportSection(isDark: isDark),
                  SizedBox(height: 24.h),
                  SettingsLogoutButton(isDark: isDark),
                  SizedBox(height: 16.h),
                  SettingsVersionInfo(isDark: isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
