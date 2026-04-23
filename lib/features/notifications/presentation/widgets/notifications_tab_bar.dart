import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/notifications/data/models/notification_item.dart';

class NotificationsTabBar extends StatelessWidget {
  const NotificationsTabBar({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final NotificationCategory active;
  final ValueChanged<NotificationCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (NotificationCategory.all, 'notifications_tab_all'),
      (NotificationCategory.orders, 'notifications_tab_orders'),
      (NotificationCategory.offers, 'notifications_tab_offers'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (final (category, key) in tabs)
          _TabItem(
            text: translate(key),
            selected: category == active,
            onTap: () => onChanged(category),
          ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          children: [
            Text(
              text,
              style: AppStyles.textstyle16.copyWith(
                color: selected
                    ? AppColors.primary
                    : AppColors.lightTextSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w200,
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
