import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class OrderPaymentSummaryCard extends StatelessWidget {
  const OrderPaymentSummaryCard({
    super.key,
    required this.deliveryFee,
    required this.serviceFee,
    required this.isDark,
  });

  final double deliveryFee;
  final double serviceFee;
  final bool isDark;

  double get total => deliveryFee + serviceFee;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('order_order_summary'),
            style: AppStyles.textstyle14Bold.copyWith(
              color: subtitleColor,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 16.h),
          _SummaryRow(
            label: translate('order_delivery_fee'),
            value: _money(deliveryFee),
            labelColor: titleColor,
            valueColor: titleColor,
          ),
          SizedBox(height: 10.h),
          _SummaryRow(
            label: translate('order_service_fee'),
            value: _money(serviceFee),
            labelColor: titleColor,
            valueColor: titleColor,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Divider(
              color: subtitleColor.withValues(alpha: 0.3),
              thickness: 1,
              height: 1,
            ),
          ),
          _SummaryRow(
            label: translate('order_total'),
            value: _money(total),
            labelColor: titleColor,
            valueColor: AppColors.primary,
            isValueEmphasized: true,
          ),
        ],
      ),
    );
  }

  String _money(double value) => '\$${value.toStringAsFixed(2)}';
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.isValueEmphasized = false,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final bool isValueEmphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.textstyle16.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: AppStyles.textstyle22.copyWith(
            color: valueColor,
            fontWeight: isValueEmphasized ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
