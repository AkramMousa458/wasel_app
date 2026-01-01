import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/order_history/data/models/order_model.dart';
import 'package:wasel/features/order_history/presentation/manager/order_history_cubit.dart';
import 'package:wasel/features/order_history/presentation/manager/order_history_state.dart';
import 'package:wasel/features/order_history/presentation/widgets/order_card.dart';
import 'package:wasel/features/order_history/presentation/widgets/order_history_header.dart';
import 'package:wasel/features/order_history/presentation/widgets/order_history_tab_switch.dart';

class OrderHistoryScreen extends StatefulWidget {
  static const String routeName = '/order-history';

  const OrderHistoryScreen({super.key, required this.isBack});
  final bool isBack;

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _selectedIndex = 0; // 0 for Active, 1 for Past

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return BlocProvider(
      create: (context) => OrderHistoryCubit()..loadOrders(),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkScaffold
            : AppColors.lightScaffold,
        body: Column(
          children: [
            OrderHistoryHeader(isBack: widget.isBack),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -28),
                child: Column(
                  children: [
                    _buildTabSwitch(isDark),
                    Expanded(child: _buildOrdersListBloc(isDark)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSwitch(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: OrderHistoryTabSwitch(
        isDark: isDark,
        selectedIndex: _selectedIndex,
        onChanged: (index) {
          if (_selectedIndex != index) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildOrdersListBloc(bool isDark) {
    return BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
      builder: (context, state) {
        if (state is OrderHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderHistoryError) {
          return Center(child: Text(state.message));
        } else if (state is OrderHistoryLoaded) {
          return _buildOrdersList(state, isDark);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildOrdersList(OrderHistoryLoaded state, bool isDark) {
    final orders = _selectedIndex == 0 ? state.activeOrders : state.pastOrders;
    final title = _selectedIndex == 0
        ? translate('in_progress')
        : translate('yesterday');

    if (orders.isEmpty) {
      return Center(
        child: Text(
          translate('no_orders_found'),
          style: AppStyles.textstyle16.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 0, left: 20.w, right: 20.w, bottom: 0),
      itemCount: orders.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSectionTitle(title, orders.length, isDark);
        }
        return _buildOrderItem(orders[index - 1], isDark);
      },
    );
  }

  Widget _buildSectionTitle(String title, int count, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 15.h),
      child: Row(
        children: [
          Text(
            title,
            style: AppStyles.textstyle18.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          if (_selectedIndex == 0 && count > 0)
            Container(
              margin: EdgeInsets.only(left: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A), // Dark blue badge
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: const Color(0xFF60A5FA),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderModel order, bool isDark) {
    if (_selectedIndex == 0) {
      return ActiveOrderCard(order: order, isDark: isDark);
    } else {
      return PastOrderCard(order: order, isDark: isDark);
    }
  }
}
