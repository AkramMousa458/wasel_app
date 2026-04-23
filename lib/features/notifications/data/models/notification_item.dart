import 'package:flutter/material.dart';

enum NotificationCategory { all, orders, offers }

enum NotificationGroup { today, yesterday }

enum NotificationItemType { orderDelivery, offer, badge, delivered }

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.category,
    required this.group,
    required this.type,
    this.actionPrimaryLabel,
    this.actionSecondaryLabel,
  });

  final String id;
  final String title;
  final String message;
  final String timeLabel;
  final NotificationCategory category;
  final NotificationGroup group;
  final NotificationItemType type;
  final String? actionPrimaryLabel;
  final String? actionSecondaryLabel;

  IconData get icon {
    switch (type) {
      case NotificationItemType.orderDelivery:
        return Icons.local_shipping_rounded;
      case NotificationItemType.offer:
        return Icons.shopping_bag_outlined;
      case NotificationItemType.badge:
        return Icons.workspace_premium_rounded;
      case NotificationItemType.delivered:
        return Icons.inventory_2_rounded;
    }
  }

  Color get iconBg {
    switch (type) {
      case NotificationItemType.orderDelivery:
        return const Color(0xFF2D7EF7);
      case NotificationItemType.offer:
        return const Color(0xFFC8F5CC);
      case NotificationItemType.badge:
        return const Color(0xFFE9EEF8);
      case NotificationItemType.delivered:
        return const Color(0xFFE9EEF8);
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationItemType.orderDelivery:
        return Colors.white;
      case NotificationItemType.offer:
        return const Color(0xFF1C8C3B);
      case NotificationItemType.badge:
        return const Color(0xFF5A75A3);
      case NotificationItemType.delivered:
        return const Color(0xFF71829E);
    }
  }
}
