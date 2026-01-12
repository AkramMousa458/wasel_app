import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/custom_snack_bar.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/core/widgets/custom_screen_header.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:wasel/features/auth/presentation/widgets/complete_profile_text_field.dart';
import 'package:wasel/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel/features/profile/presentation/manager/profile_state.dart';

class EditProfileBody extends StatefulWidget {
  final UserModel? user;

  const EditProfileBody({super.key, this.user});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(
      text: widget.user?.name?.ar ?? '',
    );
    _nameEnController = TextEditingController(
      text: widget.user?.name?.en ?? '',
    );
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    super.dispose();
  }

  void _updateName() {
    if (_formKey.currentState!.validate()) {
      if (_nameArController.text == widget.user?.name?.ar &&
          _nameEnController.text == widget.user?.name?.en) {
        return;
      }
      context.read<ProfileCubit>().updateProfile(
        arabicName: _nameArController.text,
        englishName: _nameEnController.text,
      );
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return translate('phone_number_required');
    }

    // Remove all non-digit characters
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.startsWith('1')) {
      digitsOnly = '0$digitsOnly';
    }
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

  void _showUpdatePhoneDialog(BuildContext context, bool isDark) {
    final phoneFormKey = GlobalKey<FormState>();
    final phoneController = TextEditingController();
    final otpController = TextEditingController();
    bool otpSent = false;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
            title: Text(
              translate('update_phone'),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            content: Form(
              key: phoneFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!otpSent)
                    CompleteProfileTextField(
                      controller: phoneController,
                      hintText: translate('phone_number'),
                      isDark: isDark,
                      keyboardType: TextInputType.phone,
                      validator: _validatePhoneNumber,
                    ),
                  if (otpSent)
                    CompleteProfileTextField(
                      controller: otpController,
                      hintText: translate('otp'),
                      isDark: isDark,
                      keyboardType: TextInputType.number,
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(translate('cancel')),
              ),
              if (!otpSent)
                TextButton(
                  onPressed: () {
                    if (phoneFormKey.currentState!.validate()) {
                      context
                          .read<AuthCubit>()
                          .requestPhoneOtp(phoneController.text)
                          .then((_) {
                            setState(() {
                              otpSent = true;
                            });
                          });
                    }
                  },
                  child: Text(translate('send_otp')),
                ),
              if (otpSent)
                TextButton(
                  onPressed: () {
                    if (otpController.text.isNotEmpty) {
                      context.read<AuthCubit>().verifyPhoneOtp(
                        phoneController.text,
                        otpController.text,
                      );
                      context.pop();
                    }
                  },
                  child: Text(translate('verify')),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showUpdateEmailDialog(BuildContext context, bool isDark) {
    final emailController = TextEditingController();
    final otpController = TextEditingController();
    bool otpSent = false;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
            title: Text(
              translate('update_email'),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!otpSent)
                  CompleteProfileTextField(
                    controller: emailController,
                    hintText: translate('email'),
                    isDark: isDark,
                    keyboardType: TextInputType.emailAddress,
                  ),
                if (otpSent)
                  CompleteProfileTextField(
                    controller: otpController,
                    hintText: translate('otp'),
                    isDark: isDark,
                    keyboardType: TextInputType.number,
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(translate('cancel')),
              ),
              if (!otpSent)
                TextButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty) {
                      context
                          .read<AuthCubit>()
                          .requestEmailOtp(emailController.text)
                          .then((_) {
                            setState(() {
                              otpSent = true;
                            });
                          });
                    }
                  },
                  child: Text(translate('send_otp')),
                ),
              if (otpSent)
                TextButton(
                  onPressed: () {
                    if (otpController.text.isNotEmpty) {
                      context.read<AuthCubit>().verifyEmail(
                        emailController.text,
                        otpController.text,
                      );
                      context.pop();
                    }
                  },
                  child: Text(translate('verify')),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          CustomSnackBar.showError(context, state.message);
        } else if (state is AuthOtpSent) {
          CustomSnackBar.showInfo(context, translate('otp_sent'));
        } else if (state is AuthLoginSuccess) {
          context.read<ProfileCubit>().getProfile();
          context.pop();
          CustomSnackBar.showSuccess(
            context,
            state.authModel.message ?? 'profile_updated_successfully',
          );
        }
      },
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            CustomSnackBar.showSuccess(
              context,
              translate('profile_updated_successfully'),
            );
            context.read<ProfileCubit>().getProfile();
          } else if (state is ProfileError) {
            CustomSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const CustomScreenHeader(title: 'edit_profile', fontSize: 18),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Section
                        Text(
                          translate('edit_name'),
                          style: AppStyles.textstyle16.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CompleteProfileTextField(
                          controller: _nameArController,
                          hintText: translate('arabic_name'),
                          isDark: isDark,
                          isRequired: true,
                        ),
                        SizedBox(height: 10.h),
                        CompleteProfileTextField(
                          controller: _nameEnController,
                          hintText: translate('english_name'),
                          isDark: isDark,
                          isRequired: true,
                        ),

                        SizedBox(height: 30.h),

                        CustomButton(
                          text: translate('save_changes'),
                          onPressed: _updateName,
                          isLoading: state is ProfileUpdating,
                        ),

                        SizedBox(height: 40.h),
                        Divider(
                          color: isDark ? Colors.grey[700] : Colors.grey[300],
                        ),
                        SizedBox(height: 20.h),

                        // Contact Info Section
                        Text(
                          translate('contact_info'),
                          style: AppStyles.textstyle16.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Phone
                        Row(
                          children: [
                            Icon(Icons.phone, color: AppColors.primary),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                widget.user?.phone ?? translate('no_phone'),
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  _showUpdatePhoneDialog(context, isDark),
                              child: Text(translate('change')),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),
                        // Email
                        Row(
                          children: [
                            Icon(Icons.email, color: AppColors.primary),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                widget.user?.email ?? translate('no_email'),
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  _showUpdateEmailDialog(context, isDark),
                              child: Text(translate('change')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
