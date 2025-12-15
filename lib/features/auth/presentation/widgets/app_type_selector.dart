import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/features/auth/presentation/widgets/app_type_option.dart';

class AppTypeSelector extends StatelessWidget {
  final int selectedAppType;
  final bool isDark;
  final ValueChanged<int> onAppTypeChanged;

  const AppTypeSelector({
    super.key,
    required this.selectedAppType,
    required this.isDark,
    required this.onAppTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInputFill : AppColors.lightInputFill,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTypeOption(
              isSelected: selectedAppType == 0,
              isDark: isDark,
              icon: Icons.person,
              label: translate('user_app'),
              onTap: () => onAppTypeChanged(0),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AppTypeOption(
              isSelected: selectedAppType == 1,
              isDark: isDark,
              icon: Icons.two_wheeler,
              label: translate('delivery_app'),
              onTap: () => onAppTypeChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}
