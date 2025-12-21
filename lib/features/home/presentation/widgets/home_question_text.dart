import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class HomeQuestionText extends StatelessWidget {
  const HomeQuestionText({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${translate('what_do_you_want_to')} ',
            style: AppStyles.textstyle25.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    AppColors.primary, // Blue
                    AppColors.secondary, // Yellow
                  ],
                ).createShader(bounds);
              },
              child: Text(
                translate('send_today'),
                style: AppStyles.textstyle28.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // REQUIRED
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
