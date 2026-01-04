import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';

class SettingsToggleItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const SettingsToggleItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(12.r),
        bottomRight: Radius.circular(12.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          onChanged(!value);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 20.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
