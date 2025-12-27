import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/custom_snack_bar.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/auth/presentation/widgets/login_header.dart';
import 'package:wasel/features/auth/presentation/widgets/login_form_content.dart';
import 'package:wasel/features/base/presentation/screens/base_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';

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
      final phone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
      context.read<AuthCubit>().requestOtp(phone);
    }
  }

  void _showOtpDialog(BuildContext context, String phone) {
    final TextEditingController otpController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(translate('enter_verification_code')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(translate('code_sent_to_phone')),
            SizedBox(height: 16),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: translate('verification_code'),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final code = otpController.text;
              Navigator.pop(dialogContext); // Close dialog
              if (code.isNotEmpty) {
                // Call verify on the PARENT context, not dialogContext
                context.read<AuthCubit>().verifyOtp(phone, code);
              }
            },
            child: Text(translate('verify')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          // Show error
          // Assuming you have a way to show snackbar, e.g. TopSnackBar
          showSnackBar(context, state.message, false);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          // );
        } else if (state is AuthOtpSent) {
          // Show OTP Dialog
          final phone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
          _showOtpDialog(context, phone);
        } else if (state is AuthLoginSuccess) {
          // Navigate to Home
          GoRouter.of(context).go(BaseScreen.routeName);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.8),
                      AppColors.darkScaffold,
                    ]
                  : [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.9),
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
                        isLoading: isLoading,
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
      },
    );
  }
}
