import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_dialogs.dart';
import 'package:wasel/core/utils/app_string.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel/features/profile/presentation/manager/profile_state.dart';
import 'package:wasel/features/profile/presentation/widgets/profile_temp_image_icon.dart';
import 'package:wasel/features/settings/presentation/screens/settings_screen.dart';

class ProfileHeader extends StatelessWidget {
  final bool isDark;
  final bool isBack;
  final UserModel? user;

  const ProfileHeader({
    super.key,
    required this.isDark,
    this.isBack = true,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    String displayName = '';
    if (user != null && user!.name != null) {
      final lang = locator<LocalStorage>().language ?? 'en';
      displayName = lang == 'ar' ? user!.name!.ar : user!.name!.en;
    }

    String memberSince = '';
    if (user?.createdAt != null) {
      try {
        final date = DateTime.parse(user!.createdAt!);
        memberSince = date.year.toString();
      } catch (e) {
        // ignore
      }
    }

    String? userImage;
    if (user?.image != null && user!.image!.isNotEmpty) {
      userImage =
          '${AppString.baseUrl}${user!.image!.startsWith('/') ? user!.image!.substring(1) : user!.image!}';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10.h,
        bottom: 30.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F62FE), // Bright Blue from design
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          // AppBar Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isBack
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  : SizedBox(width: 48),
              Text(
                translate('my_profile'),
                style: AppStyles.textstyle18.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    GoRouter.of(context).push(SettingsScreen.routeName);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Profile Image with Badge
          BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {},
            builder: (context, state) {
              Widget profileImage;

              if (state is ProfileLoaded && state.localImage != null) {
                profileImage = CircleAvatar(
                  radius: 50.r,
                  backgroundColor: isDark
                      ? AppColors.darkCard
                      : AppColors.lightCard,
                  backgroundImage: FileImage(state.localImage!),
                );
              } else if (userImage != null) {
                profileImage = CachedNetworkImage(
                  imageUrl: userImage,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 50.r,
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
                      radius: 50.r,
                      backgroundColor: isDark
                          ? AppColors.darkCard
                          : AppColors.lightCard,
                    ),
                  ),

                  errorWidget: (context, url, error) =>
                      ProfileTempImageIcon(isDark: isDark),
                );
              } else {
                profileImage = ProfileTempImageIcon(isDark: isDark);
              }

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: profileImage,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: isDark
                                ? AppColors.darkCard
                                : AppColors.lightCard,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                            ),
                            builder: (context) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 35.w,
                                    height: 4.h,
                                    margin: EdgeInsets.symmetric(vertical: 8.r),
                                    padding: EdgeInsets.all(16.r),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.lightCard
                                          : AppColors.darkCard,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.r),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.xmark,
                                          size: 16.sp,
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors.lightTextPrimary,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      Text(
                                        translate('change_photo'),
                                        style: AppStyles.textstyle18.copyWith(
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors.darkScaffold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.trashCan,
                                          size: 16.sp,
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors.lightTextPrimary,
                                        ),
                                        onPressed: () {
                                          context.pop();
                                          AppDialogs.showDeleteProfilePhotoDialog(
                                            context,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.r,
                                      horizontal: 20.r,
                                    ),
                                    leading: Icon(
                                      FontAwesomeIcons.camera,
                                      size: 34.r,
                                      color: AppColors.primary,
                                    ),
                                    title: Text(
                                      translate('camera'),
                                      style: AppStyles.textstyle16.copyWith(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      context
                                          .read<ProfileCubit>()
                                          .updateProfileImage(
                                            ImageSource.camera,
                                          );
                                    },
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.r,
                                      horizontal: 20.r,
                                    ),
                                    leading: Icon(
                                      FontAwesomeIcons.image,
                                      size: 34.r,
                                      color: AppColors.primary,
                                    ),
                                    title: Text(
                                      translate('gallery'),
                                      style: AppStyles.textstyle16.copyWith(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      context
                                          .read<ProfileCubit>()
                                          .updateProfileImage(
                                            ImageSource.gallery,
                                          );
                                    },
                                  ),
                                  SizedBox(height: 80),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 12.h),

          // Name
          Text(
            displayName.isNotEmpty ? displayName : 'Guest',
            style: AppStyles.textstyle25.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          // Tags
          if (memberSince.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${translate('member_since')} $memberSince',
                    style: AppStyles.textstyle12.copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 4.w),
                      Text(
                        '4.9', // Static for now as no rating in user model
                        style: AppStyles.textstyle12.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
