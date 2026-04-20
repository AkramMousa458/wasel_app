import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class OrderStepTwoFooterNote extends StatelessWidget {
  const OrderStepTwoFooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${translate('order_prohibited_items')} '),
          TextSpan(
            text: translate('order_read_policy'),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: AppStyles.textstyle14.copyWith(color: textColor, height: 1.35),
    );
  }
}
