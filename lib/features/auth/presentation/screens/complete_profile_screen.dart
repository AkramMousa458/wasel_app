import 'package:flutter/material.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/features/auth/presentation/widgets/complete_profile_body.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});
  static const String routeName = '/complete-profile';

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active to set the correct background color
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkScaffold
          : AppColors.lightScaffold,
      body: const SafeArea(child: CompleteProfileBody()),
    );
  }
}
