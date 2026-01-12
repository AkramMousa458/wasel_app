import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/profile/presentation/screens/edit_profile_screen.dart'
    show EditProfileScreen;

class PersonalInfoCard extends StatelessWidget {
  final bool isDark;
  final UserModel? user;

  const PersonalInfoCard({super.key, required this.isDark, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate('personal_info'),
                style: AppStyles.textstyle16.copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(
                    context,
                  ).push(EditProfileScreen.routeName, extra: user);
                },
                child: Text(
                  translate('edit'),
                  style: AppStyles.textstyle14.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            icon: Icons.phone,
            title: translate('phone'),
            value: user?.phone ?? '',
            isDark: isDark,
          ),
          if (user?.email != null) ...[
            Divider(
              height: 32.h,
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            _buildInfoRow(
              icon: Icons.email,
              title: translate('email'),
              value: user?.email ?? '',
              isDark: isDark,
            ),
          ],
          if (user?.role == 'admin') ...[
            Divider(
              height: 32.h,
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            _buildInfoRow(
              icon: Icons.badge,
              title: translate('role'),
              value: user!.role!,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.blue.shade200 : const Color(0xFF0F172A),
            size: 20.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title, // Uppercase title like "PHONE", "EMAIL"
              style: AppStyles.textstyle10.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: AppStyles.textstyle14.copyWith(
                color: isDark ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
