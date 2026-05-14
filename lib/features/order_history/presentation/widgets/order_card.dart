import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/live_delivery/data/models/live_delivery_screen_args.dart';
import 'package:wasel/features/live_delivery/presentation/screens/live_delivery_tracking_screen.dart';
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
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(12.r),
                        image: order.customerImage.isEmpty
                            ? null
                            : DecorationImage(
                                image: CachedNetworkImageProvider(
                                  order.customerImage,
                                ),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: order.customerImage.isEmpty
                          ? Icon(
                              Icons.local_shipping_outlined,
                              color: isDark ? Colors.white38 : Colors.black38,
                              size: 24.sp,
                            )
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
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
                SizedBox(height: 4.h),
                order.driver != null
                    ? Row(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            color: isDark ? AppColors.white : AppColors.black,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${translate('delivery')}: ',
                            style: AppStyles.textstyle12.copyWith(
                              color: isDark ? AppColors.white : AppColors.black,
                            ),
                          ),
                          Text(
                            '${order.driver?.name} ',
                            style: AppStyles.textstyle12.copyWith(
                              color: isDark ? AppColors.white : AppColors.black,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            color: isDark ? AppColors.white : AppColors.black,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${translate('delivery')}: ${translate('not_assigned')}',
                            style: AppStyles.textstyle12.copyWith(
                              color: isDark ? AppColors.white : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 16.h),

                // Arrival time tag (minutes)
                if (order.slaMinutes != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: Colors.white.withValues(alpha: 0.85),
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${translate('live_delivery_arriving_in')} ${translate('live_delivery_eta_mins', args: {'n': '${order.slaMinutes}'})}',
                            style: AppStyles.textstyle12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 16.h),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final eta = int.tryParse(
                        order.slaMinutes.toString().replaceAll(
                          RegExp(r'[^0-9]'),
                          '',
                        ),
                      );
                      context.push(
                        LiveDeliveryTrackingScreen.routeName,
                        extra: LiveDeliveryScreenArgs(
                          orderId: order.id,
                          etaMinutes: eta,
                        ),
                      );
                    },
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
                        order.customerName,
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
                          Expanded(
                            child: Text(
                              order.status == OrderStatus.delivered
                                  ? translate('delivered')
                                  : translate('cancelled'),
                              style: AppStyles.textstyle12.copyWith(
                                color: order.status == OrderStatus.delivered
                                    ? AppColors.success500
                                    : AppColors.error500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (order.description.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          order.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.textstyle12.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
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
