import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/custom_snack_bar.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/features/app/presentation/manager/app_cubit.dart';
import 'package:wasel/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:wasel/features/auth/presentation/widgets/complete_profile_text_field.dart';
import 'package:wasel/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel/features/profile/presentation/manager/profile_state.dart';

class CompleteProfileBody extends StatefulWidget {
  const CompleteProfileBody({super.key});

  @override
  State<CompleteProfileBody> createState() => _CompleteProfileBodyState();
}

class _CompleteProfileBodyState extends State<CompleteProfileBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _arabicNameController = TextEditingController();
  final TextEditingController _englishNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailOtpController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _doorController = TextEditingController();

  @override
  void dispose() {
    _arabicNameController.dispose();
    _englishNameController.dispose();
    _emailController.dispose();
    _emailOtpController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _doorController.dispose();
    super.dispose();
  }

  void _handleVerifyEmail({required String email, required String code}) async {
    if (_emailFormKey.currentState!.validate()) {
      context.read<AuthCubit>().requestEmailOtp(email);
    }
  }

  void _handleSaveProfile() async {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateProfile(
        arabicName: _arabicNameController.text,
        englishName: _englishNameController.text,
        state: _stateController.text,
        city: _cityController.text,
        street: _streetController.text,
        building: _buildingController.text,
        floor: _floorController.text,
        door: _doorController.text,
        // TODO: Get location and pushToken
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine theme
    final isDark = ThemeUtils.isDark(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showSnackBar(context, state.message, false);
        }
      },
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            context.read<AppCubit>().checkAuth();
          } else if (state is ProfileError) {
            showSnackBar(context, state.message, false);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  translate('complete_profile'),
                  style: AppStyles.textstyle30.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32.h),

                // Arabic Name
                CompleteProfileTextField(
                  controller: _arabicNameController,
                  hintText: translate('arabic_name'),
                  isDark: isDark,
                  isRequired: true,
                  suffixText: '(${translate('required')})',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB), // Blue shade
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 16.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${translate('arabic_name')} ${translate('required')}';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // English Name
                CompleteProfileTextField(
                  controller: _englishNameController,
                  hintText: translate('english_name'),
                  isDark: isDark,
                  isRequired: true,
                  suffixText: '(${translate('required')})',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        size: 16.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${translate('english_name')} ${translate('required')}';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Email
                Form(
                  key: _emailFormKey,
                  child: CompleteProfileTextField(
                    controller: _emailController,
                    hintText: translate('email'),
                    isDark: isDark,
                    keyboardType: TextInputType.emailAddress,
                    suffixText: '(${translate('optional')})',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${translate('email')} ${translate('required')}';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 12.h),

                CustomButton(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 40.h,
                  textStyle: AppStyles.textstyle12.copyWith(
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                  text: 'verify_email',
                  onPressed: () => _handleVerifyEmail(
                    email: _emailController.text,
                    code: _emailOtpController.text,
                  ),
                ),

                SizedBox(height: 20.h),

                // Email OTP
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthOtpSent) {
                      // CustomSnackBar.info(message: translate('code_sent_to_email'));
                      showSnackBar(
                        context,
                        translate('code_sent_to_email'),
                        true,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthOtpSent) {
                      return Column(
                        children: [
                          CompleteProfileTextField(
                            controller: _emailOtpController,
                            hintText: translate('email_otp'),
                            isDark: isDark,
                            keyboardType: TextInputType.number,
                            suffixText: '(${translate('required')})',
                          ),
                          SizedBox(height: 24.h),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),

                // Map Section
                Text(
                  translate('location_from_map'),
                  style: AppStyles.textstyle14.copyWith(
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  height: 100.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    image: const DecorationImage(
                      image: CachedNetworkImageProvider(
                        'https://mt1.google.com/vt/lyrs=m&x=1310&y=3160&z=13', // Placeholder map
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Overlay gradient or color for better text visibility if needed
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.black.withValues(alpha: 0.1),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Open Map Selection
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF1E293B,
                            ), // Dark blue/grey
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                          ),
                          child: Text(translate('set_on_map')),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Address Details
                CompleteProfileTextField(
                  controller: _stateController,
                  hintText: translate('state'),
                  isDark: isDark,
                  suffixText: '(${translate('optional')})',
                ),
                SizedBox(height: 16.h),
                CompleteProfileTextField(
                  controller: _cityController,
                  hintText: translate('city'),
                  isDark: isDark,
                  suffixText: '(${translate('optional')})',
                ),
                SizedBox(height: 16.h),
                CompleteProfileTextField(
                  controller: _streetController,
                  hintText: translate('street'),
                  isDark: isDark,
                  suffixText: '(${translate('optional')})',
                ),
                SizedBox(height: 16.h),
                CompleteProfileTextField(
                  controller: _buildingController,
                  hintText: translate('building'),
                  isDark: isDark,
                  suffixText: '(${translate('optional')})',
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: CompleteProfileTextField(
                        controller: _floorController,
                        hintText: translate('floor'),
                        isDark: isDark,
                        suffixText: '(${translate('optional')})',
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CompleteProfileTextField(
                        controller: _doorController,
                        hintText: translate('door'),
                        isDark: isDark,
                        suffixText: '(${translate('optional')})',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      _handleSaveProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      translate('save_profile'),
                      style: AppStyles.textstyle16.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
