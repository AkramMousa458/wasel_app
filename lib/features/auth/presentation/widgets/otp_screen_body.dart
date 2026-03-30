import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/custom_snack_bar.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/features/app/presentation/manager/app_cubit.dart';
import 'package:wasel/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:wasel/features/auth/presentation/manager/otp_cubit/otp_cubit.dart';
import 'package:wasel/features/base/presentation/screens/base_screen.dart';

class OtpScreenBody extends StatefulWidget {
  const OtpScreenBody({
    super.key,
    required this.phone,
    required this.authCubit,
  });

  final String phone;
  final AuthCubit authCubit;

  @override
  State<OtpScreenBody> createState() => _OtpScreenBodyState();
}

class _OtpScreenBodyState extends State<OtpScreenBody> {
  static const int _otpLength = 6;

  String _currentCode = '';
  Timer? _timer;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    context.read<OtpCubit>().startResendCooldown();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      context.read<OtpCubit>().tickTimer();
    });
  }

  void _handleCodeChanged(String code) {
    _currentCode = code;
    context.read<OtpCubit>().updateDigit(0, code);
  }

  void _handleCodeCompleted(String code) {
    _currentCode = code;
    widget.authCubit.verifyPhoneOtp(widget.phone, code);
  }

  void _handleVerify() {
    if (_currentCode.length < _otpLength) {
      showSnackBar(context, translate('otp_incomplete'), false);
      return;
    }
    widget.authCubit.verifyPhoneOtp(widget.phone, _currentCode);
  }

  void _handleResend() {
    setState(() {
      _currentCode = '';
      _otpController.clear();
    });
    widget.authCubit.requestPhoneOtp(widget.phone);
    _startTimer();
  }

  String _formatPhone(String phone) {
    if (phone.length >= 4) {
      return '********${phone.substring(phone.length - 3, phone.length)}';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return BlocConsumer<AuthCubit, AuthState>(
      bloc: widget.authCubit,
      listener: (context, state) {
        if (state is AuthFailure) {
          showSnackBar(context, state.message, false);
          context.read<OtpCubit>().updateDigit(0, '');
          _otpController.clear();
        } else if (state is AuthLoginSuccess) {
          context.read<AppCubit>().checkAuth();
          context.go(BaseScreen.routeName);
        }
      },
      builder: (context, authState) {
        final isLoading = authState is AuthLoading;
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
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(child: _buildCard(context, isDark, isLoading)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool isDark, bool isLoading) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 36.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIllustration(),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildTitle(isDark),
            ),
            SizedBox(height: 12.h),
            _buildSubtitle(isDark),
            SizedBox(height: 36.h),
            _buildOtpFields(isDark),
            SizedBox(height: 16.h),
            _buildResendRow(isDark),
            SizedBox(height: 36.h),
            _buildVerifyButton(isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.phone_android_rounded,
          size: 42.sp,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Text(
      translate('enter_verification_code'),
      textAlign: TextAlign.center,
      style: AppStyles.textstyle28.copyWith(
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
    );
  }

  Widget _buildSubtitle(bool isDark) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppStyles.textstyle16.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
        children: [
          TextSpan(text: '${translate('code_sent_to_phone')}\n'),
          const TextSpan(text: '\n', style: TextStyle(height: 0.5)),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                _formatPhone(widget.phone),
                style: AppStyles.textstyle16.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpFields(bool isDark) {
    final fillColor = isDark
        ? AppColors.darkInputFill
        : AppColors.lightInputFill;
    final borderColor = isDark
        ? AppColors.darkInputFill
        : AppColors.lightBorder;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2.0),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: _otpLength,
        controller: _otpController,
        autofocus: true,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        onChanged: _handleCodeChanged,
        onCompleted: _handleCodeCompleted,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        keyboardType: TextInputType.number,
        cursor: Container(width: 2.w, height: 24.h, color: AppColors.primary),
      ),
    );
  }

  Widget _buildResendRow(bool isDark) {
    return BlocBuilder<OtpCubit, OtpState>(
      builder: (context, otpState) {
        final canResend = context.read<OtpCubit>().canResend();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translate('didnt_receive_code'),
              style: AppStyles.textstyle14.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            SizedBox(width: 4.w),
            if (canResend)
              GestureDetector(
                onTap: _handleResend,
                child: Text(
                  translate('resend'),
                  style: AppStyles.textstyle14.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Text(
                '${translate('resend_in')} ${otpState.remainingSeconds}s',
                style: AppStyles.textstyle14.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildVerifyButton(bool isLoading) {
    return CustomButton(
      onPressed: isLoading ? null : _handleVerify,
      isLoading: isLoading,
      text: translate('verify'),
    );
  }
}
