import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';

class OrderStepTwoSizeSelector extends StatelessWidget {
  const OrderStepTwoSizeSelector({
    super.key,
    required this.isDark,
    required this.selectedSize,
    required this.onChanged,
  });

  final bool isDark;
  final String? selectedSize;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = [
      _PackageSizeOption(
        id: 'small',
        icon: Icons.mail_outline_rounded,
        title: translate('order_package_small'),
        subtitle: translate('order_package_small_hint'),
      ),
      _PackageSizeOption(
        id: 'medium',
        icon: Icons.inventory_2_outlined,
        title: translate('order_package_medium'),
        subtitle: translate('order_package_medium_hint'),
      ),
      _PackageSizeOption(
        id: 'large',
        icon: Icons.inbox_outlined,
        title: translate('order_package_large'),
        subtitle: translate('order_package_large_hint'),
      ),
    ];

    return Row(
      children: options
          .map(
            (option) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: _OrderPackageSizeTile(
                  option: option,
                  isDark: isDark,
                  isSelected: selectedSize == option.id,
                  onTap: () => onChanged(option.id),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _OrderPackageSizeTile extends StatelessWidget {
  const _OrderPackageSizeTile({
    required this.option,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  final _PackageSizeOption option;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark
        ? const Color(0xFF0F1D3C)
        : const Color(0xFFF1F5FF);
    final textColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Material(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected ? AppColors.secondary : Colors.transparent,
              width: 1.6,
            ),
          ),
          child: Column(
            children: [
              Icon(
                option.icon,
                color: isSelected
                    ? AppColors.secondary
                    : textColor.withValues(alpha: 0.75),
                size: 24.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                option.title,
                style: AppStyles.textstyle14Bold.copyWith(color: textColor),
              ),
              SizedBox(height: 4.h),
              Text(
                option.subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.textstyle12.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PackageSizeOption {
  const _PackageSizeOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
}
