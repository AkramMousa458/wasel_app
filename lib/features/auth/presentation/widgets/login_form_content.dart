import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/auth/presentation/widgets/mobile_number_input.dart';
import 'package:wasel/features/auth/presentation/widgets/send_verification_button.dart';
import 'package:wasel/features/auth/presentation/widgets/social_login_section.dart';
import 'package:wasel/features/auth/presentation/widgets/privacy_terms_footer.dart';

class LoginFormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final String selectedCountryCode;
  final bool isDark;
  final String? Function(String?)? phoneValidator;
  final VoidCallback onSendVerificationCode;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;
  final VoidCallback? onFacebookTap;
  final VoidCallback? onPrivacyPolicyTap;
  final VoidCallback? onTermsOfServiceTap;
  final bool isLoading;

  const LoginFormContent({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.isDark,
    this.phoneValidator,
    required this.onSendVerificationCode,
    this.onGoogleTap,
    this.onAppleTap,
    this.onFacebookTap,
    this.onPrivacyPolicyTap,
    this.onTermsOfServiceTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Heading
          Text(
            translate('lets_get_moving'),
            textAlign: TextAlign.center,
            style: AppStyles.textstyle30.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),

          // Description
          Text(
            translate('enter_mobile_number'),
            textAlign: TextAlign.center,
            style: AppStyles.textstyle16.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          SizedBox(height: 32.h),
          SizedBox(height: 25.h),

          // Mobile number input
          MobileNumberInput(
            controller: phoneController,
            selectedCountryCode: selectedCountryCode,
            isDark: isDark,
            validator: phoneValidator,
          ),
          SizedBox(height: 24.h),

          // Send verification code button
          SendVerificationButton(
            onPressed: onSendVerificationCode,
            isLoading: isLoading,
          ),
          SizedBox(height: 32.h),

          // Social login section
          // SocialLoginSection(
          //   isDark: isDark,
          //   onGoogleTap: onGoogleTap,
          //   onAppleTap: onAppleTap,
          //   onFacebookTap: onFacebookTap,
          // ),

          // Spacer to push footer to the bottom
          SizedBox(height: MediaQuery.of(context).size.height * 0.18),

          // Privacy Policy and Terms of Service
          PrivacyTermsFooter(
            isDark: isDark,
            onPrivacyPolicyTap: onPrivacyPolicyTap,
            onTermsOfServiceTap: onTermsOfServiceTap,
          ),
        ],
      ),
    );
  }
}
