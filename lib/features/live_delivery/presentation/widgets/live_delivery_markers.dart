import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';

/// Destination marker: blue ring + home icon (matches live tracking design).
class LiveDeliveryDestinationMarker extends StatelessWidget {
  const LiveDeliveryDestinationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.home_rounded, color: Colors.white, size: 26.sp),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 10.w,
          height: 10.w,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

/// Pick-up / locker style marker (light accent + lock icon).
class LiveDeliveryLockerMarker extends StatelessWidget {
  const LiveDeliveryLockerMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: 0.22),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Icon(
        Icons.lock_outline_rounded,
        color: AppColors.primary,
        size: 16.sp,
      ),
    );
  }
}
