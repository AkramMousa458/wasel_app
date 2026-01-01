import 'package:flutter/material.dart';
import 'package:wasel/features/base/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:wasel/features/home/presentation/screens/home_screen.dart';
import 'package:wasel/features/order_history/presentation/screens/order_history_screen.dart';
import 'package:wasel/features/profile/presentation/screens/profile_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
  static const String routeName = '/base-screen';

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const OrderHistoryScreen(
      isBack: false,
    ), // My Orders - TODO: Replace with actual screen
    const Placeholder(), // Add/Create - TODO: Replace with actual screen
    const Placeholder(), // Chat - TODO: Replace with actual screen
    const ProfileScreen(isBack: false), // Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
