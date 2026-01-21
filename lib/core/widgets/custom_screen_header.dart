import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class CustomScreenHeader extends StatelessWidget {
  const CustomScreenHeader({
    super.key,
    required this.title,
    this.fontSize = 20,
  });
  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10.h,
        bottom: 20.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.2),
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => GoRouter.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Text(
              translate(title),
              textAlign: TextAlign.center,
              style: AppStyles.textstyle25.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize.sp,
              ),
            ),
          ),
          SizedBox(width: 40.w), // Balance the back button
        ],
      ),
    );
  }
}
