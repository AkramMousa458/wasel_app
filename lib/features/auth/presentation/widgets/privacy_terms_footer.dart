import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class PrivacyTermsFooter extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onPrivacyPolicyTap;
  final VoidCallback? onTermsOfServiceTap;

  const PrivacyTermsFooter({
    super.key,
    required this.isDark,
    this.onPrivacyPolicyTap,
    this.onTermsOfServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPrivacyPolicyTap,
          child: Text(
            translate('privacy_policy'),
            style: AppStyles.textstyle12.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Text(
          ' • ',
          style: AppStyles.textstyle12.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        GestureDetector(
          onTap: onTermsOfServiceTap,
          child: Text(
            translate('terms_of_service'),
            style: AppStyles.textstyle12.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

