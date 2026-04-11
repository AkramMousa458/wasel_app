import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class OrderRouteStopMarker extends StatelessWidget {
  const OrderRouteStopMarker({
    super.key,
    required this.isDark,
    required this.accentColor,
    required this.icon,
    required this.labelKey,
  });

  final bool isDark;
  final Color accentColor;
  final IconData icon;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    final labelBg = isDark ? AppColors.darkCard : AppColors.lightTextPrimary;
    final labelFg = isDark ? AppColors.darkTextSecondary : AppColors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: accentColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.45),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 18.sp),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: labelBg,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            translate(labelKey),
            style: AppStyles.textstyle10.copyWith(
              color: labelFg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Pickup marker (purple + package icon).
class OrderPickupMarker extends StatelessWidget {
  const OrderPickupMarker({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return OrderRouteStopMarker(
      isDark: isDark,
      accentColor: AppColors.primary,
      icon: FontAwesomeIcons.box,
      labelKey: 'order_pickup_label',
    );
  }
}

/// Drop-off marker (green + pin).
class OrderDropoffMarker extends StatelessWidget {
  const OrderDropoffMarker({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return OrderRouteStopMarker(
      isDark: isDark,
      accentColor: AppColors.secondary,
      icon: FontAwesomeIcons.locationDot,
      labelKey: 'order_dropoff_label',
    );
  }
}
