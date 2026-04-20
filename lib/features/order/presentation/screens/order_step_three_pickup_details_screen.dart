import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/features/order/data/models/order_package_details_draft.dart';
import 'package:wasel/features/order/presentation/widgets/order_step_three/order_payment_method_tile.dart';
import 'package:wasel/features/order/presentation/widgets/order_step_three/order_payment_summary_card.dart';
import 'package:wasel/features/order/presentation/widgets/order_steps_text_widget.dart';

class OrderStepThreePickupDetailsScreen extends StatefulWidget {
  const OrderStepThreePickupDetailsScreen({super.key, this.draft});

  static const String routeName = '/order/pickup-details';

  final OrderPackageDetailsDraft? draft;

  @override
  State<OrderStepThreePickupDetailsScreen> createState() =>
      _OrderStepThreePickupDetailsScreenState();
}

class _OrderStepThreePickupDetailsScreenState
    extends State<OrderStepThreePickupDetailsScreen> {
  String _selectedMethod = _PaymentMethod.cashOnDelivery.id;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final bgColor = isDark ? AppColors.darkScaffold : const Color(0xFFEAF0F7);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Material(
                    color: isDark ? AppColors.darkCard : AppColors.white,
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
                  OrderStepsTextWidget(currentStep: 3, totalSteps: 4),
                  const Spacer(),
                  Material(
                    color: isDark ? AppColors.darkCard : AppColors.white,
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
              SizedBox(height: 20.h),
              Text(
                translate('order_payment'),
                style: AppStyles.textstyle20.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                translate('order_choose_payment_method'),
                style: AppStyles.textstyle15.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 18.h),
              ..._PaymentMethod.values.map(
                (method) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: OrderPaymentMethodTile(
                    icon: method.icon,
                    title: translate(method.titleKey),
                    subtitle: translate(method.subtitleKey),
                    isSelected: _selectedMethod == method.id,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedMethod = method.id),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              OrderPaymentSummaryCard(
                deliveryFee: 5.0,
                serviceFee: 1.5,
                isDark: isDark,
              ),
              SizedBox(height: 16.h),
              CustomButton(
                text: 'order_confirm_order',
                onPressed: () {},
                borderRadius: 16.r,
                icon: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_back_rounded
                      : Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _PaymentMethod {
  cashOnDelivery(
    id: 'cash_on_delivery',
    icon: Icons.payments_outlined,
    titleKey: 'order_payment_cash_on_delivery',
    subtitleKey: 'order_payment_cash_on_delivery_subtitle',
  ),
  card(
    id: 'debit_credit_card',
    icon: Icons.credit_card_rounded,
    titleKey: 'order_payment_debit_credit_card',
    subtitleKey: 'order_payment_debit_credit_card_subtitle',
  ),
  applePay(
    id: 'apple_pay',
    icon: Icons.phone_iphone_rounded,
    titleKey: 'order_payment_apple_pay',
    subtitleKey: 'order_payment_apple_pay_subtitle',
  );

  const _PaymentMethod({
    required this.id,
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
  });

  final String id;
  final IconData icon;
  final String titleKey;
  final String subtitleKey;
}
