import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wasel/core/utils/app_colors.dart';

class ProfileTempImageIcon extends StatelessWidget {
  const ProfileTempImageIcon({
    super.key,
    required this.isDark,
    this.radius = 50,
  });

  final bool isDark;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius.r,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      child: Icon(
        FontAwesomeIcons.solidUser,
        size: radius.r * 0.9,
        color: isDark ? AppColors.grey : AppColors.primary,
      ),
    );
  }
}
