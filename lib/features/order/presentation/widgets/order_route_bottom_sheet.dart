import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/features/order/data/models/order_place_suggestion.dart';
import 'package:wasel/features/order/presentation/cubit/order_route_selection_state.dart';
import 'package:wasel/features/order/presentation/widgets/order_route_search_suggestions.dart';

class OrderRouteBottomSheet extends StatelessWidget {
  const OrderRouteBottomSheet({
    super.key,
    required this.scrollController,
    required this.isDark,
    required this.pickupController,
    required this.dropoffController,
    required this.suggestions,
    required this.isSearching,
    required this.activeSearchField,
    required this.searchErrorKey,
    required this.onPickupTap,
    required this.onDropoffTap,
    required this.onPickupChanged,
    required this.onDropoffChanged,
    required this.onSuggestionSelected,
    required this.onConfirm,
    required this.onQuickHome,
    required this.onQuickWork,
    required this.onQuickFavorites,
  });

  /// From [DraggableScrollableSheet] — required so the sheet drags correctly.
  final ScrollController scrollController;
  final bool isDark;
  final TextEditingController pickupController;
  final TextEditingController dropoffController;
  final List<OrderPlaceSuggestion> suggestions;
  final bool isSearching;
  final OrderRouteSearchField? activeSearchField;
  final String? searchErrorKey;
  final VoidCallback onPickupTap;
  final VoidCallback onDropoffTap;
  final ValueChanged<String> onPickupChanged;
  final ValueChanged<String> onDropoffChanged;
  final ValueChanged<OrderPlaceSuggestion> onSuggestionSelected;
  final VoidCallback onConfirm;
  final VoidCallback onQuickHome;
  final VoidCallback onQuickWork;
  final VoidCallback onQuickFavorites;

  @override
  Widget build(BuildContext context) {
    final sheetBg = isDark ? AppColors.darkCard : AppColors.white;
    final borderColor =
        isDark ? AppColors.darkInputFill : AppColors.lightBorder;
    final fillColor =
        isDark ? AppColors.darkInputFill : AppColors.lightInputFill;
    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final showPickupSuggestions = activeSearchField == OrderRouteSearchField.pickup &&
        (isSearching || suggestions.isNotEmpty || searchErrorKey != null);
    final showDropSuggestions = activeSearchField == OrderRouteSearchField.dropoff &&
        (isSearching || suggestions.isNotEmpty || searchErrorKey != null);

    InputDecoration fieldDecoration({required bool focusedSecondary}) {
      return InputDecoration(
        filled: true,
        fillColor: fillColor,
        suffixIcon: Icon(
          Icons.search_rounded,
          color: secondaryText,
          size: 22.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 14.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: focusedSecondary ? AppColors.secondary : AppColors.primary,
            width: 2,
          ),
        ),
      );
    }

    return Material(
      color: sheetBg,
      elevation: isDark ? 12 : 8,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.45 : 0.2),
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _LabeledStop(
                isDark: isDark,
                labelKey: 'order_from',
                leading: _StopDot(color: AppColors.primary),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: pickupController,
                      onTap: onPickupTap,
                      onChanged: onPickupChanged,
                      style: AppStyles.textstyle14.copyWith(color: primaryText),
                      decoration: fieldDecoration(focusedSecondary: false).copyWith(
                        hintText: translate('order_search_pickup_hint'),
                        hintStyle: AppStyles.textstyle14.copyWith(
                          color: secondaryText,
                        ),
                      ),
                    ),
                    if (showPickupSuggestions) ...[
                      SizedBox(height: 8.h),
                      OrderRouteSearchSuggestions(
                        isDark: isDark,
                        suggestions: suggestions,
                        isSearching: isSearching,
                        errorTranslateKey: searchErrorKey,
                        onSelect: onSuggestionSelected,
                      ),
                    ],
                  ],
                ),
                showConnector: true,
                connectorColor: borderColor,
              ),
              _LabeledStop(
                isDark: isDark,
                labelKey: 'order_to',
                leading: _StopDot(
                  color: AppColors.secondary,
                  child: Icon(
                    FontAwesomeIcons.locationDot,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: dropoffController,
                      onTap: onDropoffTap,
                      onChanged: onDropoffChanged,
                      style: AppStyles.textstyle14.copyWith(color: primaryText),
                      decoration: fieldDecoration(focusedSecondary: true).copyWith(
                        hintText: translate('order_where_going'),
                        hintStyle: AppStyles.textstyle14.copyWith(
                          color: secondaryText,
                        ),
                      ),
                    ),
                    if (showDropSuggestions) ...[
                      SizedBox(height: 8.h),
                      OrderRouteSearchSuggestions(
                        isDark: isDark,
                        suggestions: suggestions,
                        isSearching: isSearching,
                        errorTranslateKey: searchErrorKey,
                        onSelect: onSuggestionSelected,
                      ),
                    ],
                  ],
                ),
                showConnector: false,
                connectorColor: borderColor,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _QuickChip(
                      isDark: isDark,
                      icon: FontAwesomeIcons.house,
                      labelKey: 'home',
                      onTap: onQuickHome,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _QuickChip(
                      isDark: isDark,
                      icon: FontAwesomeIcons.briefcase,
                      labelKey: 'work',
                      onTap: onQuickWork,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _QuickChip(
                      isDark: isDark,
                      icon: FontAwesomeIcons.heart,
                      labelKey: 'order_favorites',
                      onTap: onQuickFavorites,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              CustomButton(
                text: 'order_confirm_locations',
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.white,
                  size: 22.sp,
                ),
                onPressed: onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledStop extends StatelessWidget {
  const _LabeledStop({
    required this.isDark,
    required this.labelKey,
    required this.leading,
    required this.trailing,
    required this.showConnector,
    required this.connectorColor,
  });

  final bool isDark;
  final String labelKey;
  final Widget leading;
  final Widget trailing;
  final bool showConnector;
  final Color connectorColor;

  @override
  Widget build(BuildContext context) {
    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Padding(
      padding: EdgeInsets.only(bottom: showConnector ? 4.h : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate(labelKey),
            style: AppStyles.textstyle10.copyWith(
              color: secondaryText,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  leading,
                  if (showConnector) ...[
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: 2,
                      height: 24.h,
                      child: CustomPaint(
                        painter: _DashedLinePainter(color: connectorColor),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(child: trailing),
            ],
          ),
        ],
      ),
    );
  }
}

class _StopDot extends StatelessWidget {
  const _StopDot({required this.color, this.child});

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child ??
          Container(
            width: 10.r,
            height: 10.r,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    double y = 0;
    const dash = 4.0;
    const gap = 4.0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dash), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.isDark,
    required this.icon,
    required this.labelKey,
    required this.onTap,
  });

  final bool isDark;
  final IconData icon;
  final String labelKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkInputFill : AppColors.lightInputFill;
    final fg = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18.sp, color: fg),
              SizedBox(height: 6.h),
              Text(
                translate(labelKey),
                style: AppStyles.textstyle12.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
