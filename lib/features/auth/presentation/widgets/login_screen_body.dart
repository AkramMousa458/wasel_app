import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/features/auth/presentation/widgets/login_header.dart';
import 'package:wasel/features/auth/presentation/widgets/login_form_content.dart';
import 'package:wasel/features/base/presentation/screens/base_screen.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final TextEditingController _phoneController = TextEditingController();
  final String _selectedCountryCode = '+20';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return translate('phone_number_required');
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Egyptian phone numbers should be 11 digits and start with 01
    if (digitsOnly.length < 10) {
      return translate('phone_number_too_short');
    }

    if (digitsOnly.length > 11) {
      return translate('phone_number_too_long');
    }

    // Check if it's a valid Egyptian mobile number (starts with 01)
    if (!digitsOnly.startsWith('01') || digitsOnly.length != 11) {
      return translate('phone_number_invalid');
    }

    return null;
  }

  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  void _handleSendVerificationCode() {
    if (_validateForm()) {
      // Handle send verification code
      // You can access the phone number via _phoneController.text
      // final phoneNumber = '$_selectedCountryCode${_phoneController.text.replaceAll(RegExp(r'[^\d]'), '')}';
      // TODO: Implement API call to send verification code
      GoRouter.of(context).go(BaseScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                  AppColors.darkScaffold,
                ]
              : [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.9),
                  AppColors.lightScaffold,
                ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with logo and language toggle
              const LoginHeader(),

              // Main card with form content
              Container(
                margin: EdgeInsets.only(top: 20.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  child: LoginFormContent(
                    formKey: _formKey,
                    phoneController: _phoneController,
                    selectedCountryCode: _selectedCountryCode,
                    isDark: isDark,
                    phoneValidator: _validatePhoneNumber,
                    onSendVerificationCode: _handleSendVerificationCode,
                    onGoogleTap: () {
                      // Handle Google login
                    },
                    onAppleTap: () {
                      // Handle Apple login
                    },
                    onFacebookTap: () {
                      // Handle Facebook login
                    },
                    onPrivacyPolicyTap: () {
                      // Handle privacy policy
                    },
                    onTermsOfServiceTap: () {
                      // Handle terms of service
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
