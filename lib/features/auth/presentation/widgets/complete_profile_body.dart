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

  void _handleSendEmailOtp() {
    if (_emailFormKey.currentState!.validate()) {
      context.read<AuthCubit>().requestEmailOtp(_emailController.text.trim());
    }
  }

  void _handleSaveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateProfile(
        arabicName: _arabicNameController.text.trim(),
        englishName: _englishNameController.text.trim(),
        state: _stateController.text.trim(),
        city: _cityController.text.trim(),
        street: _streetController.text.trim(),
        building: _buildingController.text.trim(),
        floor: _floorController.text.trim(),
        door: _doorController.text.trim(),
      );
    }
  }

  void _handleLogout() {
    context.read<AppCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          CustomSnackBar.showError(context, state.message);
        }
      },
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            context.read<AppCubit>().checkAuth();
          } else if (state is ProfileError) {
            CustomSnackBar.showError(context, state.message);
          }
        },
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPersonalInfoSection(isDark),
                      SizedBox(height: 20.h),
                      _buildEmailSection(isDark),
                      SizedBox(height: 20.h),
                      _buildLocationSection(isDark),
                      SizedBox(height: 20.h),
                      _buildAddressSection(isDark),
                      SizedBox(height: 32.h),
                      _buildSaveButton(),
                      SizedBox(height: 16.h),
                      _buildLogoutButton(),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────
  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: AppColors.white,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('complete_profile'),
                style: AppStyles.textstyle22.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                translate('enter_mobile_number'),
                style: AppStyles.textstyle12.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Section Card Wrapper ─────────────────────────────────────────────────
  Widget _buildSectionCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.r),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, size: 16.sp, color: iconColor),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: AppStyles.textstyle14Bold.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  // ── Personal Info ────────────────────────────────────────────────────────
  Widget _buildPersonalInfoSection(bool isDark) {
    return _buildSectionCard(
      isDark: isDark,
      icon: Icons.badge_outlined,
      iconColor: AppColors.primary,
      title: translate('personal_info'),
      children: [
        CompleteProfileTextField(
          controller: _arabicNameController,
          hintText: translate('arabic_name'),
          isDark: isDark,
          isRequired: true,
          suffixText: translate('required'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '${translate('arabic_name')} ${translate('required')}';
            }
            return null;
          },
        ),
        SizedBox(height: 12.h),
        CompleteProfileTextField(
          controller: _englishNameController,
          hintText: translate('english_name'),
          isDark: isDark,
          isRequired: true,
          suffixText: translate('required'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '${translate('english_name')} ${translate('required')}';
            }
            return null;
          },
        ),
      ],
    );
  }

  // ── Email ────────────────────────────────────────────────────────────────
  Widget _buildEmailSection(bool isDark) {
    return _buildSectionCard(
      isDark: isDark,
      icon: Icons.email_outlined,
      iconColor: AppColors.secondary,
      title: translate('email'),
      children: [
        Form(
          key: _emailFormKey,
          child: CompleteProfileTextField(
            controller: _emailController,
            hintText: translate('email'),
            isDark: isDark,
            keyboardType: TextInputType.emailAddress,
            suffixText: translate('optional'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${translate('email')} ${translate('required')}';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 12.h),
        BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthOtpSent) {
              CustomSnackBar.showInfo(
                context,
                translate('code_sent_to_email'),
              );
            }
          },
          builder: (context, state) {
            final isLoadingOtp = state is AuthLoading;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButton(
                  width: 160.w,
                  height: 42.h,
                  text: 'verify_email',
                  isLoading: isLoadingOtp,
                  textStyle: AppStyles.textstyle14.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: isLoadingOtp ? null : _handleSendEmailOtp,
                ),
                if (state is AuthOtpSent) ...[
                  SizedBox(height: 12.h),
                  CompleteProfileTextField(
                    controller: _emailOtpController,
                    hintText: translate('email_otp'),
                    isDark: isDark,
                    keyboardType: TextInputType.number,
                    suffixText: translate('required'),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  // ── Location Map ─────────────────────────────────────────────────────────
  Widget _buildLocationSection(bool isDark) {
    return _buildSectionCard(
      isDark: isDark,
      icon: Icons.location_on_outlined,
      iconColor: AppColors.error,
      title: translate('location_from_map'),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                    'https://mt1.google.com/vt/lyrs=m&x=1310&y=3160&z=13',
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  height: 120.h,
                  color: isDark
                      ? AppColors.darkInputFill
                      : AppColors.lightInputFill,
                  child: Icon(
                    Icons.map_outlined,
                    size: 48.sp,
                    color: AppColors.grey,
                  ),
                ),
              ),
              Container(
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: CustomButton(
                    width: 140.w,
                    height: 40.h,
                    text: 'set_on_map',
                    backgroundColor: AppColors.darkScaffold,
                    textStyle: AppStyles.textstyle14.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: () {
                      // TODO: Open Map Selection
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Address Details ──────────────────────────────────────────────────────
  Widget _buildAddressSection(bool isDark) {
    return _buildSectionCard(
      isDark: isDark,
      icon: Icons.home_outlined,
      iconColor: AppColors.warning500,
      title: translate('saved_places'),
      children: [
        CompleteProfileTextField(
          controller: _stateController,
          hintText: translate('state'),
          isDark: isDark,
          suffixText: translate('optional'),
        ),
        SizedBox(height: 12.h),
        CompleteProfileTextField(
          controller: _cityController,
          hintText: translate('city'),
          isDark: isDark,
          suffixText: translate('optional'),
        ),
        SizedBox(height: 12.h),
        CompleteProfileTextField(
          controller: _streetController,
          hintText: translate('street'),
          isDark: isDark,
          suffixText: translate('optional'),
        ),
        SizedBox(height: 12.h),
        CompleteProfileTextField(
          controller: _buildingController,
          hintText: translate('building'),
          isDark: isDark,
          suffixText: translate('optional'),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CompleteProfileTextField(
                controller: _floorController,
                hintText: translate('floor'),
                isDark: isDark,
                suffixText: translate('optional'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CompleteProfileTextField(
                controller: _doorController,
                hintText: translate('door'),
                isDark: isDark,
                suffixText: translate('optional'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Buttons ──────────────────────────────────────────────────────────────
  Widget _buildSaveButton() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isLoading = state is ProfileUpdating;
        return CustomButton(
          text: 'save_profile',
          isLoading: isLoading,
          onPressed: isLoading ? null : _handleSaveProfile,
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return CustomButton(
      text: 'log_out',
      backgroundColor: AppColors.error.withValues(alpha: 0.08),
      textColor: AppColors.error,
      icon: Icon(Icons.logout_rounded, size: 18.sp, color: AppColors.error),
      onPressed: _handleLogout,
    );
  }
}
