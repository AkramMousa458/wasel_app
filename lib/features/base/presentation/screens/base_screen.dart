import 'package:flutter/material.dart';
import 'package:wasel/features/home/presentation/screens/home_screen.dart';

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
    // const HomeScreen(),
    // const HomeScreen(),
    // const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Text('Show Here Navigation Bar'),
    );
  }
}
