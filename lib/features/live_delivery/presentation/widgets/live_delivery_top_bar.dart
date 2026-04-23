import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';

class LiveDeliveryTopBar extends StatelessWidget {
  const LiveDeliveryTopBar({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final fg = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final pillBg = isDark ? AppColors.darkCard : AppColors.white;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
      child: Row(
        children: [
          Material(
            color: pillBg,
            shape: const CircleBorder(),
            elevation: isDark ? 0 : 2,
            shadowColor: Colors.black26,
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: fg,
                size: 18.sp,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: pillBg,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  translate('live_delivery_order_id', args: {'id': orderId}),
                  style: AppStyles.textstyle14Bold.copyWith(color: fg),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              translate('live_delivery_help'),
              style: AppStyles.textstyle14Bold.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
