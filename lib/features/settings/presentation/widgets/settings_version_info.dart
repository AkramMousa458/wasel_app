import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';

class SettingsVersionInfo extends StatelessWidget {
  final bool isDark;

  const SettingsVersionInfo({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Wasel App v1.0.2 (Build 204)',
        style: TextStyle(
          fontSize: 12.sp,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
