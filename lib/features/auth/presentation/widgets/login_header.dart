import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/language/language_cubit.dart';
import 'package:wasel/core/utils/assets.dart';
import 'package:wasel/core/widgets/language_toggle_button.dart';
import 'package:wasel/core/widgets/theme_toggle_button.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LanguageCubit>().state;
    final isRTL = locale.languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
      child: Column(
        children: [
          // Language and theme toggle buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isRTL) ...[
                  const LanguageToggleButton(),
                  const ThemeToggleButton(),
                ] else ...[
                  const ThemeToggleButton(),
                  const LanguageToggleButton(),
                ],
              ],
            ),
          ),
          SizedBox(height: 30.h),
          // Logo
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80.w),
            child: Image.asset(Assets.logoHorizontalWhite),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
