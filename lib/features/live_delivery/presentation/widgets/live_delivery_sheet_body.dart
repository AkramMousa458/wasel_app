import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_arrival_header.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_chat_call_row.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_courier_card.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_sheet_handle.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_status_stepper.dart';

class LiveDeliverySheetBody extends StatelessWidget {
  const LiveDeliverySheetBody({
    super.key,
    required this.scrollController,
    required this.etaMinutes,
    required this.courierName,
    required this.courierRating,
    required this.courierAvatarUrl,
    required this.currentStepIndex,
    this.onRateDelivery,
  });

  final ScrollController scrollController;
  final int etaMinutes;
  final String courierName;
  final double courierRating;
  final String? courierAvatarUrl;
  final int currentStepIndex;
  final VoidCallback? onRateDelivery;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final sheetColor = isDark ? AppColors.darkCard : AppColors.white;

    return Container(
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
        children: [
          const LiveDeliverySheetHandle(),
          LiveDeliveryArrivalHeader(
            etaMinutes: etaMinutes,
            courierName: courierName,
          ),
          LiveDeliveryStatusStepper(currentStepIndex: currentStepIndex),
          LiveDeliveryCourierCard(
            name: courierName,
            rating: courierRating,
            avatarUrl: courierAvatarUrl,
          ),
          const LiveDeliveryChatCallRow(),
          if (currentStepIndex != 3 && onRateDelivery != null) ...[
            SizedBox(height: 12.h),
            CustomButton(
              text: 'live_delivery_rate_now',
              onPressed: onRateDelivery,
              borderRadius: 16.r,
              icon: Icon(Icons.star_rounded, color: Colors.white, size: 20.sp),
            ),
          ],
        ],
      ),
    );
  }
}
