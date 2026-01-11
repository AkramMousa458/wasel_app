import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_dialogs.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfileSettingsSection extends StatelessWidget {
  final bool isDark;

  const ProfileSettingsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            ],
          ),
        ),

        // Logout Request
        ProfileMenuItem(
          isDark: isDark,
          title: translate('log_out'),
          icon: Icons.logout,
          textColor: AppColors.error500,
          trailing: const SizedBox.shrink(),
          onTap: () {
            AppDialogs.showLogoutDialog(context);
          },
        ),
      ],
    );
  }
}
