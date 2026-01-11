import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_section.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_item.dart';

class SettingsSupportSection extends StatelessWidget {
  final bool isDark;

  const SettingsSupportSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
}
