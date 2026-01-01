import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/order_history/data/models/order_model.dart';
import 'package:wasel/features/order_history/presentation/widgets/order_status_chip.dart';

class ActiveOrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const ActiveOrderCard({super.key, required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to order details
          },
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                // Header: Icon + Title + Status
                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF2C2C2E,
                        ), // Dark grey placeholder BG
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: NetworkImage(order.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.storeName,
                            style: AppStyles.textstyle16.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.white : AppColors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            order.description,
                            style: AppStyles.textstyle12.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OrderStatusChip(status: order.status),
                  ],
                ),
                SizedBox(height: 16.h),

                // Main Content (Visual)
                Container(
                  height: 120.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF1F5F9), // Darker/Lighter inset
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'Map / Details Placeholder',
                          style: TextStyle(
                            color: isDark ? Colors.white24 : Colors.black26,
                          ),
                        ),
                      ),
                      // If profiles exist (Group Order)
                      if (order.profileImages.isNotEmpty)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Row(
                            children: [
                              for (
                                int i = 0;
                                i < order.profileImages.length && i < 3;
                                i++
                              )
                                Align(
                                  widthFactor: 0.7,
                                  child: CircleAvatar(
                                    radius: 14.r,
                                    backgroundColor: isDark
                                        ? AppColors.darkCard
                                        : AppColors.lightCard,
                                    child: CircleAvatar(
                                      radius: 12.r,
                                      backgroundImage: NetworkImage(
                                        order.profileImages[i],
                                      ),
                                    ),
                                  ),
                                ),
                              if (order.newItemCount > 0)
                                Align(
                                  widthFactor: 0.7,
                                  child: CircleAvatar(
                                    radius: 14.r,
                                    backgroundColor: isDark
                                        ? AppColors.darkCard
                                        : AppColors.lightCard,
                                    child: CircleAvatar(
                                      radius: 12.r,
                                      backgroundColor: const Color(0xFF1E293B),
                                      child: Text(
                                        '+${order.newItemCount}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                      // Arrival Time Tag
                      if (order.arrivalTime.isNotEmpty)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A), // Very dark navy
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              order.status == OrderStatus.inTransit
                                  ? '${translate('arriving_in')} ${order.arrivalTime}'
                                  : order.arrivalTime,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          order.type == OrderType.pickup
                              ? translate('view_pickup_details')
                              : translate('track_order'),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PastOrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const PastOrderCard({super.key, required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9), // Subtle bg
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.inventory_2_outlined, // Package icon generic
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.storeName,
                        style: AppStyles.textstyle16.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            order.status == OrderStatus.delivered
                                ? Icons.check_circle
                                : Icons.cancel,
                            size: 14.sp,
                            color: order.status == OrderStatus.delivered
                                ? AppColors.success500
                                : AppColors.error500,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            order.description, // "Delivered" or "Cancelled"
                            style: AppStyles.textstyle12.copyWith(
                              color: order.status == OrderStatus.delivered
                                  ? AppColors.success500
                                  : AppColors.error500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action (Reorder or Arrow)
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    order.status == OrderStatus.delivered
                        ? Icons.refresh
                        : Icons.arrow_forward,
                    color: isDark ? Colors.white70 : Colors.black54,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
