import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/auth/data/repos/auth_repo_impl.dart';
import 'package:wasel/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:wasel/features/auth/presentation/widgets/complete_profile_body.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});
  static const String routeName = '/complete-profile';

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active to set the correct background color
    final isDark = ThemeUtils.isDark(context);

    return BlocProvider(
      create: (context) => AuthCubit(locator<AuthRepoImpl>()),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkScaffold
            : AppColors.lightScaffold,
        body: const SafeArea(child: CompleteProfileBody()),
      ),
    );
  }
}
