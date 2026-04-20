import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/features/order/data/models/order_review_draft.dart';
import 'package:wasel/features/order/presentation/widgets/order_steps_text_widget.dart';

class OrderStepFourReviewOrderScreen extends StatelessWidget {
  const OrderStepFourReviewOrderScreen({super.key, required this.reviewDraft});

  static const String routeName = '/order/review';

  final OrderReviewDraft reviewDraft;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final bgColor = isDark ? AppColors.darkScaffold : const Color(0xFFEAF0F7);
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 110.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Material(
                        color: cardColor,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: titleColor,
                            size: 18.sp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        translate('order_review_order'),
                        style: AppStyles.textstyle18.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Material(
                        color: cardColor,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.help_outline_rounded,
                            color: titleColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Text(
                        translate('order_summary'),
                        style: AppStyles.textstyle12.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      OrderStepsTextWidget(
                        currentStep: 4,
                        totalSteps: 4,
                        // color: Colors.transparent,
                        // textColor: subtitleColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _EstimateCard(total: reviewDraft.total, isDark: isDark),
                  SizedBox(height: 14.h),
                  _RouteDetailsCard(
                    isDark: isDark,
                    pickupAddress: reviewDraft.packageDraft.pickupAddress,
                    dropoffAddress: reviewDraft.packageDraft.dropoffAddress,
                  ),
                  SizedBox(height: 14.h),
                  _DetailsGrid(
                    isDark: isDark,
                    packageType: reviewDraft.packageDraft.packageSize,
                    details: reviewDraft.packageDraft.details,
                    weightKg: reviewDraft.estimatedWeightKg,
                  ),
                  SizedBox(height: 14.h),
                  _PaymentInfoCard(
                    isDark: isDark,
                    methodLabel: reviewDraft.paymentMethodLabel,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              child: CustomButton(
                text: 'order_confirm_order',
                onPressed: () {},
                borderRadius: 16.r,
                icon: const Icon(Icons.check_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({required this.total, required this.isDark});

  final double total;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Text(
            translate('order_total_estimate'),
            style: AppStyles.textstyle14.copyWith(
              color: titleColor.withValues(alpha: 0.75),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: AppStyles.textstyle40.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              translate('order_best_price_applied'),
              style: AppStyles.textstyle12.copyWith(
                color: const Color(0xFF0E8D3D),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteDetailsCard extends StatelessWidget {
  const _RouteDetailsCard({
    required this.isDark,
    required this.pickupAddress,
    required this.dropoffAddress,
  });

  final bool isDark;
  final String pickupAddress;
  final String dropoffAddress;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                translate('order_route_details'),
                style: AppStyles.textstyle20.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                translate('edit'),
                style: AppStyles.textstyle14Bold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _RoutePointRow(
            icon: Icons.my_location_rounded,
            pointLabel: translate('order_pick_up'),
            address: pickupAddress,
            titleColor: titleColor,
            subtitleColor: subtitleColor,
            iconBgColor: AppColors.primarySoft.withValues(alpha: 0.2),
            iconColor: AppColors.primary,
          ),
          SizedBox(height: 10.h),
          _RoutePointRow(
            icon: Icons.location_on_rounded,
            pointLabel: translate('order_drop_off'),
            address: dropoffAddress,
            titleColor: titleColor,
            subtitleColor: subtitleColor,
            iconBgColor: AppColors.secondary.withValues(alpha: 0.2),
            iconColor: const Color(0xFF0E8D3D),
          ),
        ],
      ),
    );
  }
}

class _RoutePointRow extends StatelessWidget {
  const _RoutePointRow({
    required this.icon,
    required this.pointLabel,
    required this.address,
    required this.titleColor,
    required this.subtitleColor,
    required this.iconBgColor,
    required this.iconColor,
  });

  final IconData icon;
  final String pointLabel;
  final String address;
  final Color titleColor;
  final Color subtitleColor;
  final Color iconBgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 22.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pointLabel,
                style: AppStyles.textstyle12.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.textstyle16.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsGrid extends StatelessWidget {
  const _DetailsGrid({
    required this.isDark,
    required this.packageType,
    required this.details,
    required this.weightKg,
  });

  final bool isDark;
  final String packageType;
  final String details;
  final double weightKg;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    Widget tile(String title, String value, IconData icon) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.textstyle10.copyWith(
                      color: subtitleColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.textstyle14Bold.copyWith(
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: tile(
                translate('order_package'),
                _localizePackage(packageType),
                Icons.inventory_2_rounded,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: tile(
                translate('order_weight'),
                '~${weightKg.toStringAsFixed(1)} kg',
                Icons.scale_rounded,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        tile(translate('order_item_details'), details, Icons.notes_rounded),
      ],
    );
  }

  String _localizePackage(String id) {
    switch (id) {
      case 'small':
        return translate('order_package_small');
      case 'medium':
        return translate('order_package_medium');
      case 'large':
        return translate('order_package_large');
      default:
        return id;
    }
  }
}

class _PaymentInfoCard extends StatelessWidget {
  const _PaymentInfoCard({required this.isDark, required this.methodLabel});

  final bool isDark;
  final String methodLabel;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.credit_card_rounded,
            color: AppColors.primary,
            size: 24.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('order_payment_method'),
                  style: AppStyles.textstyle12.copyWith(
                    color: subtitleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  methodLabel,
                  style: AppStyles.textstyle16.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_rounded, color: AppColors.secondary, size: 20.sp),
        ],
      ),
    );
  }
}
