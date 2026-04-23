import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/notifications/data/models/notification_item.dart';
import 'package:wasel/features/notifications/presentation/widgets/notification_card.dart';

class NotificationsGroupSection extends StatelessWidget {
  const NotificationsGroupSection({
    super.key,
    required this.titleKey,
    required this.items,
  });

  final String titleKey;
  final List<NotificationItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate(titleKey),
            style: AppStyles.textstyle14.copyWith(
              color: AppColors.lightTextSecondary,
              letterSpacing: 0.6,
            ),
          ),
          SizedBox(height: 10.h),
          ...items.map((item) => NotificationCard(item: item)),
        ],
      ),
    );
  }
}
