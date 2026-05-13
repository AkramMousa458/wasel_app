import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel/features/profile/presentation/manager/profile_state.dart';
import 'package:wasel/features/profile/presentation/screens/profile_screen.dart';

/// Opens the home header “pick / set default address” bottom sheet.
void showHomeSavedAddressesSheet(BuildContext context, {required bool isDark}) {
  final cubit = context.read<ProfileCubit>();
  final messenger = ScaffoldMessenger.of(context);
  final scheme = _SheetColorScheme.fromIsDark(isDark);

  showModalBottomSheet<void>(
    context: context,
    // isScrollControlled: true,
    backgroundColor: scheme.sheetBackground,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (sheetContext) {
      final maxHeight = MediaQuery.sizeOf(sheetContext).height * 0.72;
      return BlocProvider.value(
        value: cubit,
        child: _SheetUpdateListener(
          messenger: messenger,
          child: _SheetSurface(
            scheme: scheme,
            isDark: isDark,
            maxHeight: maxHeight,
            sheetContext: sheetContext,
          ),
        ),
      );
    },
  );
}

// --- Profile state helpers (kept local so this file stays self-contained) ---

UserModel? _userFromProfileState(ProfileState state) {
  if (state is ProfileLoaded) return state.user;
  if (state is ProfileUpdating) return state.user;
  if (state is ProfileUpdateSuccess) return state.authModel.user;
  return null;
}

List<SavedAddress> _sortedSavedAddresses(List<SavedAddress> addresses) {
  final sorted = List<SavedAddress>.from(addresses);
  sorted.sort((a, b) {
    if (a.isDefault) return -1;
    if (b.isDefault) return 1;
    return 0;
  });
  return sorted;
}

String _formatSavedAddressLine(AddressDetails address) {
  final parts = [
    address.street,
    address.building,
    address.floor,
    address.city,
    address.governorate,
  ].where((e) => e.isNotEmpty).toList();
  return parts.join(', ');
}

IconData _savedAddressIconForLabel(String label) {
  final lower = label.toLowerCase();
  if (lower.contains('home') || lower.contains('المنزل')) {
    return Icons.home_rounded;
  }
  if (lower.contains('work') || lower.contains('العمل')) {
    return Icons.work_rounded;
  }
  return Icons.location_on_rounded;
}

Color _savedAddressIconColorForLabel(String label) {
  final lower = label.toLowerCase();
  if (lower.contains('home') || lower.contains('المنزل')) {
    return AppColors.secondary;
  }
  if (lower.contains('work') || lower.contains('العمل')) {
    return const Color(0xFF3B82F6);
  }
  return AppColors.primary;
}

Map<String, dynamic> _savedAddressToEditBody(
  SavedAddress address, {
  required bool isDefault,
}) {
  const fallbackLng = 31.2357116;
  const fallbackLat = 30.0444196;
  final coords = address.location.coordinates;
  return {
    'label': address.label,
    'location': {
      'type': 'Point',
      'coordinates': coords.length >= 2
          ? [coords[0], coords[1]]
          : [fallbackLng, fallbackLat],
    },
    'address': {
      'governorate': address.address.governorate,
      'city': address.address.city,
      'street': address.address.street,
      'building': address.address.building,
      'floor': address.address.floor,
      'door': address.address.door,
    },
    'isDefault': isDefault,
  };
}

// --- Theme tokens for the sheet ---

class _SheetColorScheme {
  const _SheetColorScheme({
    required this.sheetBackground,
    required this.border,
    required this.fillMuted,
    required this.primaryText,
    required this.secondaryText,
    required this.cardBackground,
  });

  factory _SheetColorScheme.fromIsDark(bool isDark) {
    return _SheetColorScheme(
      sheetBackground: isDark ? AppColors.darkCard : AppColors.white,
      border: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
      fillMuted: isDark ? AppColors.darkInputFill : AppColors.lightInputFill,
      primaryText: isDark
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary,
      secondaryText: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
      cardBackground: isDark ? AppColors.darkCard : AppColors.white,
    );
  }

  final Color sheetBackground;
  final Color border;
  final Color fillMuted;
  final Color primaryText;
  final Color secondaryText;
  final Color cardBackground;
}

// --- Sheet chrome & layout ---

class _SheetUpdateListener extends StatelessWidget {
  const _SheetUpdateListener({required this.messenger, required this.child});

  final ScaffoldMessengerState messenger;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          (previous is ProfileUpdating && current is ProfileLoaded) ||
          (previous is ProfileUpdating && current is ProfileError),
      listener: (listenerContext, state) {
        if (state is ProfileLoaded) {
          Navigator.of(listenerContext).pop();
        } else if (state is ProfileError) {
          messenger.showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: child,
    );
  }
}

class _SheetSurface extends StatelessWidget {
  const _SheetSurface({
    required this.scheme,
    required this.isDark,
    required this.maxHeight,
    required this.sheetContext,
  });

  final _SheetColorScheme scheme;
  final bool isDark;
  final double maxHeight;
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: scheme.sheetBackground,
        elevation: isDark ? 12 : 8,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.45 : 0.2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: maxHeight,
          child: SafeArea(
            top: false,
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final user = _userFromProfileState(state);
                final updating = state is ProfileUpdating;
                final addresses = user?.savedAddresses ?? [];
                final sorted = _sortedSavedAddresses(addresses);

                return Column(
                  children: [
                    SizedBox(height: 10.h),
                    _SheetDragHandle(color: scheme.border),
                    _SheetHeader(
                      scheme: scheme,
                      onClose: () => Navigator.of(sheetContext).pop(),
                    ),
                    Divider(height: 1, thickness: 1, color: scheme.border),
                    if (updating)
                      LinearProgressIndicator(
                        minHeight: 3,
                        backgroundColor: scheme.border,
                        color: AppColors.primary,
                      ),
                    Expanded(
                      child: addresses.isEmpty
                          ? _EmptyAddressesList(
                              scheme: scheme,
                              sheetContext: sheetContext,
                            )
                          : _SavedAddressList(
                              scheme: scheme,
                              isDark: isDark,
                              addresses: sorted,
                              updating: updating,
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetDragHandle extends StatelessWidget {
  const _SheetDragHandle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.scheme, required this.onClose});

  final _SheetColorScheme scheme;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 4.w, 4.h),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: Icon(
              FontAwesomeIcons.xmark,
              size: 16.sp,
              color: scheme.primaryText,
            ),
          ),
          Expanded(
            child: Text(
              translate('saved_places'),
              textAlign: TextAlign.center,
              style: AppStyles.textstyle18.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.primaryText,
              ),
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }
}

// --- Empty state ---

class _EmptyAddressesList extends StatelessWidget {
  const _EmptyAddressesList({required this.scheme, required this.sheetContext});

  final _SheetColorScheme scheme;
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 14.w),
          decoration: BoxDecoration(
            color: scheme.fillMuted,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: scheme.border),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_off_outlined,
                size: 28.sp,
                color: scheme.secondaryText,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  translate('no_saved_places'),
                  style: AppStyles.textstyle14.copyWith(
                    color: scheme.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(sheetContext).pop();
              sheetContext.push(ProfileScreen.routeName, extra: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              translate('add_new'),
              style: AppStyles.textstyle16.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Address list ---

class _SavedAddressList extends StatelessWidget {
  const _SavedAddressList({
    required this.scheme,
    required this.isDark,
    required this.addresses,
    required this.updating,
  });

  final _SheetColorScheme scheme;
  final bool isDark;
  final List<SavedAddress> addresses;
  final bool updating;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _SavedAddressCard(
            scheme: scheme,
            isDark: isDark,
            address: addresses[index],
            updating: updating,
          ),
        );
      },
    );
  }
}

class _SavedAddressCard extends StatelessWidget {
  const _SavedAddressCard({
    required this.scheme,
    required this.isDark,
    required this.address,
    required this.updating,
  });

  final _SheetColorScheme scheme;
  final bool isDark;
  final SavedAddress address;
  final bool updating;

  @override
  Widget build(BuildContext context) {
    final line = _formatSavedAddressLine(address.address);
    final canSetDefault = !address.isDefault && address.id != null;
    final icon = _savedAddressIconForLabel(address.label);
    final iconColor = _savedAddressIconColorForLabel(address.label);

    return Container(
      decoration: BoxDecoration(
        color: scheme.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: address.isDefault ? AppColors.primary : scheme.border,
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              address.label,
                              style: AppStyles.textstyle14.copyWith(
                                color: scheme.primaryText,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (address.isDefault) _DefaultBadge(),
                        ],
                      ),
                      if (line.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          line,
                          style: AppStyles.textstyle12.copyWith(
                            color: scheme.secondaryText,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (canSetDefault) ...[
            Divider(height: 1, thickness: 1, color: scheme.border),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: updating
                      ? null
                      : () {
                          context.read<ProfileCubit>().editAddress(
                            address.id!,
                            _savedAddressToEditBody(address, isDefault: true),
                          );
                        },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text(
                    translate('set_as_default'),
                    style: AppStyles.textstyle14Bold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DefaultBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Text(
        translate('default'),
        style: AppStyles.textstyle10.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
