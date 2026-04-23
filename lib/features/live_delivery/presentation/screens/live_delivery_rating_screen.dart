import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/features/base/presentation/screens/base_screen.dart';
import 'package:wasel/features/live_delivery/data/models/live_delivery_rating_args.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_rating_card.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_rating_header.dart';
import 'package:wasel/features/live_delivery/presentation/widgets/live_delivery_tip_selector.dart';

class LiveDeliveryRatingScreen extends StatefulWidget {
  const LiveDeliveryRatingScreen({super.key, required this.args});

  static const String routeName = '/order/live-delivery/rating';

  final LiveDeliveryRatingArgs args;

  @override
  State<LiveDeliveryRatingScreen> createState() =>
      _LiveDeliveryRatingScreenState();
}

class _LiveDeliveryRatingScreenState extends State<LiveDeliveryRatingScreen> {
  int _rating = 4;
  int _tipAmount = 3;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final bgColor = isDark ? AppColors.darkScaffold : const Color(0xFFEAF0F7);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      LiveDeliveryRatingHeader(
                        receiverName: widget.args.receiverName,
                      ),
                      SizedBox(height: 14.h),
                      LiveDeliveryRatingCard(
                        courierName: widget.args.courierName,
                        vehicle: widget.args.vehicle,
                        ratingValue: _rating,
                        onRatingChanged: (v) => setState(() => _rating = v),
                        courierAvatarUrl: widget.args.courierAvatarUrl,
                      ),
                      SizedBox(height: 12.h),
                      LiveDeliveryTipSelector(
                        selectedTip: _tipAmount,
                        onTipSelected: (v) => setState(() => _tipAmount = v),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              CustomButton(
                text: 'live_delivery_send_another_item',
                onPressed: () {
                  context.go(BaseScreen.routeName);
                },
                borderRadius: 16.r,
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => context.go(BaseScreen.routeName),
                child: Text(
                  translate('live_delivery_back_home'),
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
