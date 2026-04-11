import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/custom_snack_bar.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/order/data/services/nominatim_place_search_service.dart';
import 'package:wasel/features/order/data/services/order_device_location_service.dart';
import 'package:wasel/features/order/presentation/constants/order_route_defaults.dart';
import 'package:wasel/features/order/presentation/cubit/order_route_selection_cubit.dart';
import 'package:wasel/features/order/presentation/cubit/order_route_selection_state.dart';
import 'package:wasel/features/order/presentation/widgets/order_route_app_bar.dart';
import 'package:wasel/features/order/presentation/widgets/order_route_bottom_sheet.dart';
import 'package:wasel/features/order/presentation/widgets/order_route_map_view.dart';
import 'package:wasel/features/order/presentation/widgets/order_route_my_location_fab.dart';
import 'package:wasel/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel/features/profile/presentation/manager/profile_state.dart';

/// Step 1 of 4 — select pickup / drop-off via search (Nominatim) or saved places.
class OrderSelectRouteScreen extends StatefulWidget {
  const OrderSelectRouteScreen({super.key});

  static const String routeName = '/order/select-route';

  @override
  State<OrderSelectRouteScreen> createState() => _OrderSelectRouteScreenState();
}

enum _QuickSlot { home, work, favorites }

class _OrderSelectRouteScreenState extends State<OrderSelectRouteScreen> {
  static const int _totalSteps = 4;
  static const double _sheetInitial = 0.6;
  static const double _sheetMin = 0.22;
  static const double _sheetMax = 0.95;

  final MapController _mapController = MapController();
  late final TextEditingController _pickupCtrl;
  late final TextEditingController _dropoffCtrl;
  int _lastSyncedRevision = -1;
  /// Tracks [DraggableScrollableSheet] height as a fraction of the screen (for FAB & map padding).
  double _sheetExtent = _sheetInitial;

  @override
  void initState() {
    super.initState();
    _pickupCtrl = TextEditingController(text: translate('order_current_location'));
    _dropoffCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pickupCtrl.dispose();
    _dropoffCtrl.dispose();
    super.dispose();
  }

  /// Must use a [BuildContext] that is **below** [BlocProvider] (not [State.context]).
  void _fitRouteBounds(BuildContext cubitContext) {
    final cubit = cubitContext.read<OrderRouteSelectionCubit>();
    final s = cubit.state;
    final h = MediaQuery.sizeOf(cubitContext).height;
    final bottomPad = (h * _sheetExtent + 40).clamp(160.0, 520.0);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(s.pickup, s.dropoff),
        padding: EdgeInsets.only(
          left: 48,
          right: 48,
          top: 120,
          bottom: bottomPad,
        ),
      ),
    );
  }

  List<SavedAddress> _savedAddresses(BuildContext context) {
    final ps = context.read<ProfileCubit>().state;
    if (ps is ProfileLoaded) return ps.user.savedAddresses;
    if (ps is ProfileUpdating && ps.user != null) {
      return ps.user!.savedAddresses;
    }
    if (ps is ProfileUpdateSuccess) {
      return ps.authModel.user?.savedAddresses ?? const [];
    }
    return const [];
  }

  SavedAddress? _savedForQuick(List<SavedAddress> list, _QuickSlot slot) {
    if (list.isEmpty) return null;
    switch (slot) {
      case _QuickSlot.home:
        for (final a in list) {
          final l = a.label.toLowerCase();
          if (l.contains('home') ||
              l.contains('منزل') ||
              l.contains('house')) {
            return a;
          }
        }
        return null;
      case _QuickSlot.work:
        for (final a in list) {
          final l = a.label.toLowerCase();
          if (l.contains('work') ||
              l.contains('عمل') ||
              l.contains('office') ||
              l.contains('مكتب')) {
            return a;
          }
        }
        return null;
      case _QuickSlot.favorites:
        for (final a in list) {
          if (a.isDefault) return a;
        }
        return list.first;
    }
  }

  void _applyQuick(BuildContext context, _QuickSlot slot) {
    final list = _savedAddresses(context);
    final addr = _savedForQuick(list, slot);
    if (addr == null) {
      CustomSnackBar.showError(
        context,
        translate('order_no_saved_for_quick'),
      );
      return;
    }
    context.read<OrderRouteSelectionCubit>().applySavedAddressToDropoff(addr);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return BlocProvider(
      create: (context) => OrderRouteSelectionCubit(
        NominatimPlaceSearchService(),
        initialPickup: OrderRouteDefaults.pickup,
        initialDropoff: OrderRouteDefaults.dropoff,
        initialPickupLabel: translate('order_current_location'),
      ),
      child: _BootstrapPickupFromGps(
        child: BlocListener<OrderRouteSelectionCubit, OrderRouteSelectionState>(
          listenWhen: (p, c) =>
              c.selectionRevision != p.selectionRevision ||
              p.pickup != c.pickup ||
              p.dropoff != c.dropoff,
          listener: (context, state) {
            if (!mounted) return;
            if (state.selectionRevision != _lastSyncedRevision) {
              _lastSyncedRevision = state.selectionRevision;
              if (_pickupCtrl.text != state.pickupCommittedLabel) {
                _pickupCtrl.value = TextEditingValue(
                  text: state.pickupCommittedLabel,
                  selection: TextSelection.collapsed(
                    offset: state.pickupCommittedLabel.length,
                  ),
                );
              }
              if (_dropoffCtrl.text != state.dropoffCommittedLabel) {
                _dropoffCtrl.value = TextEditingValue(
                  text: state.dropoffCommittedLabel,
                  selection: TextSelection.collapsed(
                    offset: state.dropoffCommittedLabel.length,
                  ),
                );
              }
            }
            _fitRouteBounds(context);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                BlocBuilder<OrderRouteSelectionCubit, OrderRouteSelectionState>(
                  buildWhen: (p, c) =>
                      p.pickup != c.pickup || p.dropoff != c.dropoff,
                  builder: (context, state) {
                    final h = MediaQuery.sizeOf(context).height;
                    return Positioned.fill(
                      child: OrderRouteMapView(
                        isDark: isDark,
                        mapController: _mapController,
                        pickup: state.pickup,
                        dropoff: state.dropoff,
                        fitPaddingBottom: h * _sheetInitial + 48,
                      ),
                    );
                  },
                ),
                SafeArea(
                  bottom: false,
                  child: OrderRouteAppBar(
                    isDark: isDark,
                    currentStep: 1,
                    totalSteps: _totalSteps,
                  ),
                ),
                NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    final next = notification.extent;
                    if ((next - _sheetExtent).abs() > 0.002) {
                      setState(() => _sheetExtent = next);
                    }
                    return false;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: _sheetInitial,
                    minChildSize: _sheetMin,
                    maxChildSize: _sheetMax,
                    snap: true,
                    snapSizes: const [_sheetMin, _sheetInitial, _sheetMax],
                    builder: (sheetContext, scrollController) {
                      return BlocBuilder<OrderRouteSelectionCubit,
                          OrderRouteSelectionState>(
                        builder: (context, state) {
                          return OrderRouteBottomSheet(
                            scrollController: scrollController,
                            isDark: isDark,
                            pickupController: _pickupCtrl,
                            dropoffController: _dropoffCtrl,
                            suggestions: state.suggestions,
                            isSearching: state.isSearching,
                            activeSearchField: state.activeSearchField,
                            searchErrorKey: state.searchError,
                            onPickupTap: () => context
                                .read<OrderRouteSelectionCubit>()
                                .focusPickupField(),
                            onDropoffTap: () => context
                                .read<OrderRouteSelectionCubit>()
                                .focusDropoffField(),
                            onPickupChanged: (t) => context
                                .read<OrderRouteSelectionCubit>()
                                .onPickupQueryChanged(t),
                            onDropoffChanged: (t) => context
                                .read<OrderRouteSelectionCubit>()
                                .onDropoffQueryChanged(t),
                            onSuggestionSelected: (place) => context
                                .read<OrderRouteSelectionCubit>()
                                .selectSuggestion(place),
                            onConfirm: () {
                              final ok = context
                                  .read<OrderRouteSelectionCubit>()
                                  .validateForNextStep();
                              if (!ok) {
                                CustomSnackBar.showError(
                                  context,
                                  translate('order_select_dropoff_required'),
                                );
                                return;
                              }
                              context
                                  .read<OrderRouteSelectionCubit>()
                                  .dismissSuggestions();
                              // Step 2 — wire navigation when ready
                            },
                            onQuickHome: () =>
                                _applyQuick(context, _QuickSlot.home),
                            onQuickWork: () =>
                                _applyQuick(context, _QuickSlot.work),
                            onQuickFavorites: () =>
                                _applyQuick(context, _QuickSlot.favorites),
                          );
                        },
                      );
                    },
                  ),
                ),
                Builder(
                  builder: (fabContext) {
                    final h = MediaQuery.sizeOf(fabContext).height;
                    return OrderRouteMyLocationFab(
                      bottomOffset: h * _sheetExtent,
                      onPressed: () => _fitRouteBounds(fabContext),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// After [BlocProvider] is available, requests GPS once and moves the pickup ("from") pin.
class _BootstrapPickupFromGps extends StatefulWidget {
  const _BootstrapPickupFromGps({required this.child});

  final Widget child;

  @override
  State<_BootstrapPickupFromGps> createState() =>
      _BootstrapPickupFromGpsState();
}

class _BootstrapPickupFromGpsState extends State<_BootstrapPickupFromGps> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _applyGpsPickup());
  }

  Future<void> _applyGpsPickup() async {
    final point = await OrderDeviceLocationService.tryGetCurrentLatLng();
    if (!mounted || point == null) return;
    context.read<OrderRouteSelectionCubit>().setPickupFromDeviceLocation(
          point,
          label: translate('order_current_location'),
        );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
