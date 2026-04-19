import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/core/widgets/custom_button.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
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
    required this.routeDistanceKm,
    required this.onPickupTap,
    required this.onDropoffTap,
    required this.onPickupChanged,
    required this.onDropoffChanged,
    required this.onSuggestionSelected,
    required this.onConfirm,
    required this.savedAddresses,
    required this.onSavedAddressSelected,
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
  final double? routeDistanceKm;
  final VoidCallback onPickupTap;
  final VoidCallback onDropoffTap;
  final ValueChanged<String> onPickupChanged;
  final ValueChanged<String> onDropoffChanged;
  final ValueChanged<OrderPlaceSuggestion> onSuggestionSelected;
  final VoidCallback onConfirm;
  /// From [UserModel.savedAddresses], same source as profile saved places.
  final List<SavedAddress> savedAddresses;
  final ValueChanged<SavedAddress> onSavedAddressSelected;

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
              if (routeDistanceKm != null) ...[
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkInputFill
                        : AppColors.lightInputFill,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.route_rounded,
                        size: 18.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${translate('order_distance')}: ${routeDistanceKm!.toStringAsFixed(1)} km',
                        style: AppStyles.textstyle12.copyWith(color: primaryText),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 16.h),
              Text(
                translate('saved_places'),
                style: AppStyles.textstyle14.copyWith(
                  color: primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              if (savedAddresses.isEmpty)
                _SavedPlacesEmptyHint(isDark: isDark, borderColor: borderColor)
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _sortedSavedAddresses(savedAddresses)
                        .map(
                          (address) => Padding(
                            padding: EdgeInsetsDirectional.only(end: 12.w),
                            child: SizedBox(
                              width: 250.w,
                              child: _SavedAddressQuickTile(
                                isDark: isDark,
                                address: address,
                                onTap: () => onSavedAddressSelected(address),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
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

/// Same ordering as [ProfileSavedPlacesSection]: default address first.
List<SavedAddress> _sortedSavedAddresses(List<SavedAddress> addresses) {
  final sorted = List<SavedAddress>.from(addresses);
  sorted.sort((a, b) {
    if (a.isDefault) return -1;
    if (b.isDefault) return 1;
    return 0;
  });
  return sorted;
}

class _SavedPlacesEmptyHint extends StatelessWidget {
  const _SavedPlacesEmptyHint({
    required this.isDark,
    required this.borderColor,
  });

  final bool isDark;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInputFill : AppColors.lightInputFill,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 22.sp,
            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              translate('no_saved_places'),
              style: AppStyles.textstyle12.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedAddressQuickTile extends StatelessWidget {
  const _SavedAddressQuickTile({
    required this.isDark,
    required this.address,
    required this.onTap,
  });

  final bool isDark;
  final SavedAddress address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = _savedPlaceIcon(address.label);
    final iconColor = _savedPlaceIconColor(address.label);
    final subtitle = _formatSavedAddressLine(address.address);

    return Padding(
      padding: EdgeInsets.zero,
      child: Material(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: address.isDefault
                  ? Border.all(color: AppColors.primary, width: 2)
                  : Border.all(
                      color: isDark
                          ? AppColors.darkInputFill
                          : AppColors.lightBorder,
                    ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 22.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.label,
                        style: AppStyles.textstyle14.copyWith(
                          color: isDark ? AppColors.white : AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          style: AppStyles.textstyle12.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

IconData _savedPlaceIcon(String label) {
  final lower = label.toLowerCase();
  if (lower.contains('home') || lower.contains('المنزل')) {
    return Icons.home_rounded;
  }
  if (lower.contains('work') || lower.contains('العمل')) {
    return Icons.work_rounded;
  }
  return Icons.location_on_rounded;
}

Color _savedPlaceIconColor(String label) {
  final lower = label.toLowerCase();
  if (lower.contains('home') || lower.contains('المنزل')) {
    return AppColors.secondary;
  }
  if (lower.contains('work') || lower.contains('العمل')) {
    return const Color(0xFF3B82F6);
  }
  return AppColors.primary;
}

String _formatSavedAddressLine(AddressDetails address) {
  final parts = [
    address.street,
    address.city,
  ].where((e) => e.trim().isNotEmpty).toList();
  return parts.take(2).join(', ');
}
