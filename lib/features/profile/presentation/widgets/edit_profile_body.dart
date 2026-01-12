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
  late TextEditingController _descriptionArController;
  late TextEditingController _descriptionEnController;

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(
      text: widget.user?.name?.ar ?? '',
    );
    _nameEnController = TextEditingController(
      text: widget.user?.name?.en ?? '',
    );
    // Assuming description is part of the user model or we fetch it.
    // For now, initializing empty or placeholder if not in model yet (based on previous user request, it's not in UserModel yet but added to API)
    // We will leave empty for now as UserModel definition provided earlier didn't have description field in `view_file` output Step 196.
    // But user request in Step 187 showed description in body/response.
    // I should probably check if UserModel has description. It wasn't in the file viewed in Step 196.
    _descriptionArController = TextEditingController();
    _descriptionEnController = TextEditingController();
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    super.dispose();
  }

  void _updateNameAndDescription() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateProfile(
        arabicName: _nameArController.text,
        englishName: _nameEnController.text,
        arabicDescription: _descriptionArController.text,
        englishDescription: _descriptionEnController.text,
      );
    }
  }

  void _showUpdatePhoneDialog(BuildContext context, bool isDark) {
    final phoneController = TextEditingController();
    final otpController = TextEditingController();
    bool otpSent = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
            title: Text(
              translate('update_phone'),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!otpSent)
                  CompleteProfileTextField(
                    controller: phoneController,
                    hintText: translate('phone_number'),
                    isDark: isDark,
                    keyboardType: TextInputType.phone,
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
                    if (phoneController.text.isNotEmpty) {
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
          showSnackBar(context, state.message, false);
        } else if (state is AuthOtpSent) {
          showSnackBar(context, translate('otp_sent'), true);
        }
      },
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            showSnackBar(context, translate('profile_updated'), true);
            context.read<ProfileCubit>().getProfile();
            context.pop();
          } else if (state is ProfileError) {
            showSnackBar(context, state.message, false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
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
                  SizedBox(height: 20.h),

                  // Description Section (Optional)
                  Text(
                    translate('description'),
                    style: AppStyles.textstyle16.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CompleteProfileTextField(
                    controller: _descriptionArController,
                    hintText: translate('arabic_description'),
                    isDark: isDark,
                  ),
                  SizedBox(height: 10.h),
                  CompleteProfileTextField(
                    controller: _descriptionEnController,
                    hintText: translate('english_description'),
                    isDark: isDark,
                  ),
                  SizedBox(height: 30.h),

                  CustomButton(
                    text: translate('save_changes'),
                    onPressed: _updateNameAndDescription,
                    isLoading: state is ProfileUpdating,
                  ),

                  SizedBox(height: 40.h),
                  Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
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
          );
        },
      ),
    );
  }
}
