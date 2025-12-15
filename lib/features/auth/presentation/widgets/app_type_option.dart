import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class AppTypeOption extends StatefulWidget {
  final bool isSelected;
  final bool isDark;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AppTypeOption({
    super.key,
    required this.isSelected,
    required this.isDark,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<AppTypeOption> createState() => _AppTypeOptionState();
}

class _AppTypeOptionState extends State<AppTypeOption> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: widget.isSelected ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        builder: (context, value, child) {
          return AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutCubic,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: Color.lerp(Colors.transparent, AppColors.primary, value),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      widget.icon,
                      key: ValueKey('${widget.icon}-${widget.isSelected}'),
                      size: 20.w,
                      color: Color.lerp(
                        widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        AppColors.white,
                        value,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOutCubic,
                    style: AppStyles.textstyle12.copyWith(
                      color: Color.lerp(
                        widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        AppColors.white,
                        value,
                      ),
                      fontWeight: widget.isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    child: Text(widget.label),
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
