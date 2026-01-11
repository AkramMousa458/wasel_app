import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/language/language_cubit.dart';
import 'package:wasel/core/theme/theme_cubit.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_section.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_item.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_toggle_item.dart';

class SettingsAppPreferencesSection extends StatefulWidget {
  final bool isDark;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationChanged;

  const SettingsAppPreferencesSection({
    super.key,
    required this.isDark,
    required this.notificationsEnabled,
    required this.onNotificationChanged,
  });

  @override
  State<SettingsAppPreferencesSection> createState() =>
      _SettingsAppPreferencesSectionState();
}

class _SettingsAppPreferencesSectionState
    extends State<SettingsAppPreferencesSection> {
  // We need to manage the theme toggle state locally or read from cubit.
  // The original code used a local `_darkModeEnabled` but also read from cubit.
  // We'll read from Cubit mostly.

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        final isArabic = locale.languageCode == 'ar';
        return SettingsSection(
          title: translate('app_preferences'),
          isDark: widget.isDark,
          children: [
            SettingsItem(
              icon: Icons.language,
              iconColor: AppColors.primary,
              title: translate('language'),
              trailing: Text(
                isArabic ? '🇪🇬' : '🇺🇸',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: widget.isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              isDark: widget.isDark,
              isTopBorderRaduis: true,
              onTap: () {
                context.read<LanguageCubit>().toggleLanguage();
              },
            ),
            SettingsToggleItem(
              icon: Icons.notifications,
              iconColor: const Color(0xFFFF9500),
              title: translate('notifications'),
              value: widget.notificationsEnabled,
              isDark: widget.isDark,
              onChanged: widget.onNotificationChanged,
            ),
            SettingsToggleItem(
              icon: Icons.dark_mode,
              iconColor: const Color(0xFF9C27B0),
              title: translate('dark_mode'),
              value:
                  context.read<ThemeCubit>().state.brightness ==
                  Brightness.dark,
              isDark: widget.isDark,
              onChanged: (value) {
                value
                    ? context.read<ThemeCubit>().setDarkTheme()
                    : context.read<ThemeCubit>().setLightTheme();
              },
            ),
          ],
        );
      },
    );
  }
}
