import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/order/data/models/order_place_suggestion.dart';

class OrderRouteSearchSuggestions extends StatelessWidget {
  const OrderRouteSearchSuggestions({
    super.key,
    required this.isDark,
    required this.suggestions,
    required this.isSearching,
    required this.errorTranslateKey,
    required this.onSelect,
  });

  final bool isDark;
  final List<OrderPlaceSuggestion> suggestions;
  final bool isSearching;
  /// When non-null, show translated error (e.g. `order_search_failed`).
  final String? errorTranslateKey;
  final ValueChanged<OrderPlaceSuggestion> onSelect;

  @override
  Widget build(BuildContext context) {
    final border =
        isDark ? AppColors.darkInputFill : AppColors.lightBorder;
    final fill = isDark ? AppColors.darkScaffold : AppColors.lightInputFill;

    return Container(
      constraints: BoxConstraints(maxHeight: 220.h),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isSearching) {
      return Padding(
        padding: EdgeInsets.all(20.r),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                translate('order_searching'),
                style: AppStyles.textstyle14.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (errorTranslateKey != null) {
      return Padding(
        padding: EdgeInsets.all(14.r),
        child: Text(
          translate(errorTranslateKey!),
          style: AppStyles.textstyle14.copyWith(color: AppColors.error),
        ),
      );
    }

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      itemCount: suggestions.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
      ),
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          dense: true,
          title: Text(
            item.displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.textstyle14.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          leading: Icon(
            Icons.place_outlined,
            color: AppColors.primary,
            size: 22.sp,
          ),
          onTap: () => onSelect(item),
        );
      },
    );
  }
}
