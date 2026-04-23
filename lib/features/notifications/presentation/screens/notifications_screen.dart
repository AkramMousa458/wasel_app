import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/notifications/data/models/notification_item.dart';
import 'package:wasel/features/notifications/presentation/widgets/notifications_group_section.dart';
import 'package:wasel/features/notifications/presentation/widgets/notifications_tab_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.isBack = false});
  static const String routeName = '/notifications';
  final bool isBack;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationCategory _activeTab = NotificationCategory.all;

  List<NotificationItem> get _items => [
    NotificationItem(
      id: 'n1',
      title: 'Order #WA-9821 is out for delivery',
      message:
          'Your driver is 5 minutes away. Get ready to receive your package!',
      timeLabel: '2m ago',
      category: NotificationCategory.orders,
      group: NotificationGroup.today,
      type: NotificationItemType.orderDelivery,
      actionPrimaryLabel: translate('notifications_track_map'),
      actionSecondaryLabel: translate('notifications_details'),
    ),
    NotificationItem(
      id: 'n2',
      title: '50% off your next delivery',
      message: 'Flash sale! Use code WASEL50 before midnight to save big.',
      timeLabel: '1h ago',
      category: NotificationCategory.offers,
      group: NotificationGroup.today,
      type: NotificationItemType.offer,
    ),
    NotificationItem(
      id: 'n3',
      title: 'You earned a new badge!',
      message:
          'Congratulations! You have reached "Silver Tier" for completing 10 orders this month.',
      timeLabel: 'Yesterday',
      category: NotificationCategory.all,
      group: NotificationGroup.yesterday,
      type: NotificationItemType.badge,
    ),
    NotificationItem(
      id: 'n4',
      title: 'Order #WA-9755 Delivered',
      message:
          'Your order was successfully delivered. Do not forget to rate your experience!',
      timeLabel: 'Yesterday',
      category: NotificationCategory.orders,
      group: NotificationGroup.yesterday,
      type: NotificationItemType.delivered,
    ),
  ];

  List<NotificationItem> get _filteredItems {
    if (_activeTab == NotificationCategory.all) return _items;
    return _items.where((n) => n.category == _activeTab).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final bgColor = isDark ? AppColors.darkScaffold : const Color(0xFFF4F6FA);
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final titleColor = isDark ? AppColors.white : AppColors.lightTextPrimary;

    final today = _filteredItems
        .where((n) => n.group == NotificationGroup.today)
        .toList();
    final yesterday = _filteredItems
        .where((n) => n.group == NotificationGroup.yesterday)
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 10.h),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                    backgroundColor: cardColor,
                    iconColor: titleColor,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        translate('notifications'),
                        style: AppStyles.textstyle18.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  _CircleIconButton(
                    icon: Icons.done_all_rounded,
                    onTap: () {},
                    backgroundColor: cardColor,
                    iconColor: titleColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: NotificationsTabBar(
                active: _activeTab,
                onChanged: (v) => setState(() => _activeTab = v),
              ),
            ),
            SizedBox(height: 6.h),
            const Divider(height: 1, color: AppColors.darkTextSecondary),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
                children: [
                  NotificationsGroupSection(
                    titleKey: 'notifications_today',
                    items: today,
                  ),
                  NotificationsGroupSection(
                    titleKey: 'notifications_yesterday',
                    items: yesterday,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 42.r,
          height: 42.r,
          child: Icon(icon, color: iconColor, size: 18.sp),
        ),
      ),
    );
  }
}
