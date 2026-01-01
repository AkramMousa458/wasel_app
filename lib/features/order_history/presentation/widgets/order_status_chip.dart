import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/order_history/data/models/order_model.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData? icon;

    switch (status) {
      case OrderStatus.inTransit:
        backgroundColor = const Color(
          0xFF1E3A8A,
        ).withValues(alpha: 0.5); // Example dark blue tint
        textColor = const Color(0xFF60A5FA);
        text = 'In Transit';
        icon = Icons.circle; // Dot
        break;
      case OrderStatus.courierAssigned:
        backgroundColor = Colors.purple.withValues(alpha: 0.1);
        textColor = Colors.purple;
        text = 'Assigned';
        break;
      case OrderStatus.delivered:
        backgroundColor = AppColors.success500.withValues(alpha: 0.1);
        textColor = AppColors.success500;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        backgroundColor = AppColors.error500.withValues(alpha: 0.1);
        textColor = AppColors.error500;
        text = 'Cancelled';
        break;
    }

    // Special case for "In Transit" style in the design (Pill shape with dot)
    if (status == OrderStatus.inTransit) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: const Color(0xFF172554), // Dark blue from screenshot
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFF2563EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.w,
              height: 6.w,
              decoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              text,
              style: AppStyles.textstyle12.copyWith(
                color: const Color(0xFF93C5FD),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: AppStyles.textstyle12.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
