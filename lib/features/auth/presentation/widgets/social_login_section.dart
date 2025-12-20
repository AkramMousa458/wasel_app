import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/auth/presentation/widgets/social_login_button.dart';

class SocialLoginSection extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;
  final VoidCallback? onFacebookTap;

  const SocialLoginSection({
    super.key,
    required this.isDark,
    this.onGoogleTap,
    this.onAppleTap,
    this.onFacebookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDark
                    ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                translate('or_continue_with'),
                style: AppStyles.textstyle14.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark
                    ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        // Social login buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginButton(
              icon: Icons.g_mobiledata,
              label: 'Google',
              onTap: onGoogleTap ?? () {},
              isDark: isDark,
            ),
            SizedBox(width: 16.w),
            SocialLoginButton(
              icon: Icons.phone_iphone,
              label: 'iOS',
              onTap: onAppleTap ?? () {},
              isDark: isDark,
            ),
            SizedBox(width: 16.w),
            SocialLoginButton(
              icon: Icons.facebook,
              label: 'Facebook',
              onTap: onFacebookTap ?? () {},
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }
}

