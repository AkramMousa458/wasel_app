import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/home/presentation/widgets/home_header.dart';
import 'package:wasel/features/home/presentation/widgets/home_question_text.dart';
import 'package:wasel/features/home/presentation/widgets/send_item_card.dart';

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
                  HomeQuestionText(isDark: isDark),
                  SizedBox(height: 20.h),
                  const SendItemCard(),
                  // Text(
                  //   translate('what_do_you_want_to'),
                  //   textAlign: TextAlign.start,
                  //   style: AppStyles.textstyle16.copyWith(
                  //     fontWeight: FontWeight.bold,
                  //     color: AppColors.lightTextPrimary,
                  //   ),
                  // ),
                  // Text(
                  //   translate('send_today?'),
                  //   textAlign: TextAlign.start,
                  //   style: AppStyles.textstyle16.copyWith(
                  //     fontWeight: FontWeight.bold,
                  //     color: AppColors.lightTextPrimary,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
