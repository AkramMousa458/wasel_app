import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_string.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel/features/profile/presentation/manager/profile_state.dart';
import 'package:wasel/features/profile/presentation/widgets/profile_temp_image_icon.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.isDark});
  final bool isDark;

  static const double _avatarRadius = 26;

  UserModel? _userFromState(ProfileState state) {
    if (state is ProfileLoaded) return state.user;
    if (state is ProfileUpdating) return state.user;
    if (state is ProfileUpdateSuccess) return state.authModel.user;
    return null;
  }

  String? _profileImageUrl(UserModel? user) {
    final path = user?.image;
    if (path == null || path.isEmpty) return null;
    return '${AppString.baseUrl}${path.startsWith('/') ? path.substring(1) : path}';
  }

  String _displayNameFromState(ProfileState state) {
    final user = _userFromState(state);

    if (user?.name == null) return 'Guest';

    final lang = locator<LocalStorage>().language ?? 'en';
    final raw = lang == 'ar' ? user!.name!.ar : user!.name!.en;
    final trimmed = raw.trim();
    return trimmed.isNotEmpty ? trimmed : 'Guest';
  }

  String _displayLocationFromState(ProfileState state) {
    final user = _userFromState(state);

    if (user?.savedAddresses.isEmpty ?? true) {
      return translate('no_location_set');
    }

    return user!.savedAddresses
        .firstWhere((address) => address.isDefault)
        .label;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // User Avatar
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final user = _userFromState(state);
                final networkUrl = _profileImageUrl(user);

                late final Widget avatar;
                if (state is ProfileLoaded && state.localImage != null) {
                  avatar = CircleAvatar(
                    radius: _avatarRadius.r,
                    backgroundColor: isDark
                        ? AppColors.darkCard
                        : AppColors.lightCard,
                    backgroundImage: FileImage(state.localImage!),
                  );
                } else if (networkUrl != null) {
                  avatar = CachedNetworkImage(
                    imageUrl: networkUrl,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: _avatarRadius.r,
                      backgroundColor: isDark
                          ? AppColors.darkCard
                          : AppColors.lightCard,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: isDark
                          ? AppColors.shimmerDarkBaseColor
                          : AppColors.shimmerLightBaseColor,
                      highlightColor: isDark
                          ? AppColors.shimmerDarkHighlightColor
                          : AppColors.shimmerLightHighlightColor,
                      child: CircleAvatar(
                        radius: _avatarRadius.r,
                        backgroundColor: isDark
                            ? AppColors.darkCard
                            : AppColors.lightCard,
                      ),
                    ),
                    errorWidget: (context, url, error) => ProfileTempImageIcon(
                      isDark: isDark,
                      radius: _avatarRadius,
                    ),
                  );
                } else {
                  avatar = ProfileTempImageIcon(
                    isDark: isDark,
                    radius: _avatarRadius,
                  );
                }

                return Stack(
                  children: [
                    avatar,
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 15.r,
                        height: 15.r,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? AppColors.lightTextPrimary
                                : AppColors.white,
                            width: 2,
                          ),
                          color: AppColors.success500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return Text(
                      _displayNameFromState(state),
                      style: AppStyles.textstyle16.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    );
                  },
                ),
                SizedBox(height: 4.h),
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 2.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.locationDot,
                          size: 14.r,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        SizedBox(width: 4.w),
                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                            return Text(
                              _displayLocationFromState(state),
                              style: AppStyles.textstyle12.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 3.w),
                        Icon(
                          FontAwesomeIcons.chevronDown,
                          size: 10.r,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w),
          ],
        ),

        IconButton(
          onPressed: () {},
          iconSize: 22.r,
          icon: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(FontAwesomeIcons.solidBell),
                Positioned(
                  top: -5,
                  right: -3,
                  child: Container(
                    width: 11.r,
                    height: 11.r,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? AppColors.lightTextPrimary
                            : AppColors.white,
                        width: 2,
                      ),
                      color: isDark ? AppColors.error500 : AppColors.error500,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
