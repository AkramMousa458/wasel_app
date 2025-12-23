import 'package:flutter/material.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_styles.dart';

class ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String topText;
  final String bottomText;
  final bool isDark;

  const ActionCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.topText,
    required this.bottomText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(26),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: () {
            print('${translate(bottomText)} Card Tapped');
          },
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ICON
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: iconBg.withValues(alpha: 0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),

                const SizedBox(height: 18),

                /// TOP TEXT
                Text(
                  translate(topText),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.6)
                        : AppColors.grey,
                  ),
                ),

                const SizedBox(height: 6),

                /// BOTTOM TEXT (MAIN TITLE)
                Text(
                  translate(bottomText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.textstyle18.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
