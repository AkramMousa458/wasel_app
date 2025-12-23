import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class ReferralCard extends StatelessWidget {
  const ReferralCard({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24.r),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            print('Referral Card Tapped');
          },
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          translate('invite_friends'),
                          style: AppStyles.textstyle12.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${translate('get')} ',
                              style: AppStyles.textstyle16.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.black,
                              ),
                            ),
                            TextSpan(
                              text: '10% ${translate('off')}',
                              style: AppStyles.textstyle16.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(
                              text: ' ${translate('your_next_delivery')}',
                              style: AppStyles.textstyle16.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12.r),
                  margin: EdgeInsets.only(left: 2.w),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FontAwesomeIcons.gift,
                    color: AppColors.primary,
                    size: 24.r,
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
