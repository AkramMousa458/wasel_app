import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
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
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundImage: const NetworkImage(
                    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: Colors.black, size: 16.sp),
                ),
              ),
            ],
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
