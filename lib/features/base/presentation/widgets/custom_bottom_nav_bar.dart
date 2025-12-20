import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const animationDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.house,
                    selectedIcon: FontAwesomeIcons.houseChimney,
                    label: 'Home',
                    index: 0,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.inventory_2_outlined,
                    selectedIcon: Icons.inventory_2,
                    label: 'My Orders',
                    index: 1,
                    isDark: isDark,
                  ),
                  // Spacer for center button
                  SizedBox(width: 50.w),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.commentDots,
                    selectedIcon: FontAwesomeIcons.solidCommentDots,
                    label: 'Chat',
                    index: 3,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: FontAwesomeIcons.user,
                    selectedIcon: FontAwesomeIcons.solidUser,
                    label: 'Profile',
                    index: 4,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            // Floating center button
            Positioned(
              left: 0,
              right: 0,
              top: -25.h,
              child: Center(child: _buildCenterButton(context: context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected
        ? (isDark ? AppColors.white : AppColors.lightTextPrimary)
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: TweenAnimationBuilder(
                  key: ValueKey('${isSelected}_$index'),
                  tween: ColorTween(
                    begin: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    end: color,
                  ),
                  duration: animationDuration,
                  curve: Curves.easeInOut,
                  builder: (context, animatedColor, child) {
                    return AnimatedScale(
                      scale: isSelected ? 1.0 : 0.9,
                      duration: animationDuration,
                      curve: Curves.easeInCubic,
                      child: Icon(
                        isSelected ? selectedIcon : icon,
                        color: animatedColor as Color,
                        size: isSelected ? 24.sp : 20.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 3.h),
              AnimatedSwitcher(
                duration: animationDuration,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: isSelected
                    ? TweenAnimationBuilder<double>(
                        key: const ValueKey('indicator'),
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        builder: (context, scale, child) {
                          return Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Transform.scale(
                              scale: scale,
                              child: Opacity(
                                opacity: scale,
                                child: CircleAvatar(
                                  radius: 3.r,
                                  backgroundColor: isDark
                                      ? AppColors.white
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : AnimatedDefaultTextStyle(
                        key: const ValueKey('text'),
                        duration: animationDuration,
                        style: AppStyles.textstyle10.copyWith(
                          color: color,
                          fontWeight: FontWeight.normal,
                        ),
                        child: Text(label),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton({required BuildContext context}) {
    final isSelected = selectedIndex == 2;

    return GestureDetector(
      onTap: () => onTap(2),
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        width: isSelected ? 56.w : 50.w,
        height: isSelected ? 56.h : 50.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF39E965), // Light green
              Color(0xFF12B76A), // Darker green
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF39E965,
              ).withValues(alpha: isSelected ? 0.6 : 0.4),
              blurRadius: isSelected ? 16 : 12,
              spreadRadius: isSelected ? 3 : 2,
            ),
          ],
        ),
        child: AnimatedScale(
          scale: isSelected ? 1.1 : 1.0,
          duration: animationDuration,
          curve: Curves.easeInOut,
          child: Icon(
            Icons.add,
            color: AppColors.black,
            size: 28.sp,
            weight: 3,
          ),
        ),
      ),
    );
  }
}
