import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_section.dart';
import 'package:wasel/features/settings/presentation/widgets/settings_item.dart';

class SettingsFinanceSection extends StatelessWidget {
  final bool isDark;

  const SettingsFinanceSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
}
