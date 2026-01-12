import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel/features/profile/presentation/manager/profile_state.dart';
import 'package:wasel/features/profile/presentation/widgets/personal_info_card.dart';
import 'package:wasel/features/profile/presentation/widgets/profile_header.dart';
import 'package:wasel/features/profile/presentation/widgets/profile_saved_places_section.dart';
import 'package:wasel/features/profile/presentation/widgets/profile_settings_section.dart';
import 'package:wasel/features/profile/presentation/widgets/profile_shimmer.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile-screen';
  final bool isBack;
  const ProfileScreen({super.key, required this.isBack});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isDark = ThemeUtils.isDark(context);

        if (state is ProfileLoading || state is ProfileInitial) {
          return Scaffold(
            backgroundColor: isDark
                ? AppColors.darkScaffold
                : AppColors.lightScaffold,
            body: const ProfileShimmer(),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            backgroundColor: isDark
                ? AppColors.darkScaffold
                : AppColors.lightScaffold,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().getProfile(),
                    child: Text(translate('retry')),
                  ),
                ],
              ),
            ),
          );
        }

        UserModel? user;
        if (state is ProfileLoaded) {
          user = state.user;
        }

        return Scaffold(
          backgroundColor: isDark
              ? AppColors.darkScaffold
              : AppColors.lightScaffold,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                ProfileHeader(isDark: isDark, isBack: isBack, user: user),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      // Personal Info Card
                      PersonalInfoCard(isDark: isDark, user: user),
                      SizedBox(height: 32.h),

                      // Saved Places
                      ProfileSavedPlacesSection(isDark: isDark),
                      SizedBox(height: 16.h),

                      // Settings and Logout
                      ProfileSettingsSection(isDark: isDark),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
