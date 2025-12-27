import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:wasel/features/auth/presentation/screens/login_screen.dart';
import 'package:wasel/features/home/presentation/widgets/action_card.dart';
import 'package:wasel/features/home/presentation/widgets/home_header.dart';
import 'package:wasel/features/home/presentation/widgets/home_question_text.dart';
import 'package:wasel/features/home/presentation/widgets/send_item_card.dart';
import 'package:wasel/features/home/presentation/widgets/recent_activity_section.dart';
import 'package:wasel/features/home/presentation/widgets/referral_card.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  HomeHeader(isDark: isDark),
                  SizedBox(height: 20.h),
                  /////////////----------- Handle logout -----------/////////////
                  IconButton(
                    onPressed: () {
                      locator<LocalStorage>().logout();
                      GoRouter.of(context).go(LoginScreen.routeName);
                    },
                    icon: const Icon(Icons.logout),
                  ),
                  HomeQuestionText(isDark: isDark),
                  SizedBox(height: 20.h),
                  SendItemCard(isDark: isDark),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: ActionCard(
                          isDark: isDark,
                          icon: FontAwesomeIcons.bagShopping,
                          iconBg: const Color(0xFF6BFF7A),
                          iconColor: AppColors.darkCard,
                          topText: 'shop',
                          bottomText: 'buy_something',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ActionCard(
                          isDark: isDark,
                          icon: FontAwesomeIcons.truckFast,
                          iconBg: const Color(0xFF1F3C88),
                          iconColor: const Color(0xFF3B82F6),
                          topText: 'earn',
                          bottomText: 'deliver_order',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  RecentActivitySection(isDark: isDark),
                  SizedBox(height: 20.h),
                  ReferralCard(isDark: isDark),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
