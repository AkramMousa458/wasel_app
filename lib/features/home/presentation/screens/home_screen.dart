import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/widgets/custom_app_bar.dart';
import 'package:wasel/core/widgets/language_toggle_button.dart';
import 'package:wasel/features/home/presentation/widgets/home_screen_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: const CustomAppBar(
          title: 'home',
          isBack: false,
          action: LanguageToggleButton(),
        ),
      ),
      body: const SafeArea(child: HomeScreenBody()),
    );
  }
}
