import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/custom_snack_bar.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/order/data/services/nominatim_place_search_service.dart';
import 'package:wasel/features/order/data/services/order_osrm_route_service.dart';
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

class _OrderSelectRouteScreenState extends State<OrderSelectRouteScreen> {
  static const int _totalSteps = 5;
  static const double _sheetInitial = 0.5;
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
    _pickupCtrl = TextEditingController(
      text: translate('order_current_location'),
    );
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
    final route = s.routePoints?.first;
    final bounds = (route != null)
        ? LatLngBounds.fromPoints([route])
        : LatLngBounds(s.pickup, s.dropoff);
    final cameraFit = CameraFit.bounds(
      bounds: bounds,
      padding: EdgeInsets.only(
        left: 48,
        right: 48,
        top: 120,
        bottom: bottomPad,
      ),
    );

    final impl = _mapController as MapControllerImpl;
    try {
      final fitted = cameraFit.fit(impl.camera);
      impl.moveAnimatedRaw(
        fitted.center,
        fitted.zoom,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
        hasGesture: false,
        source: MapEventSource.mapController,
      );
    } catch (_) {
      _mapController.fitCamera(cameraFit);
    }
  }

  List<SavedAddress> _savedAddressesFromProfile(ProfileState profileState) {
    if (profileState is ProfileLoaded) {
      return profileState.user.savedAddresses;
    }
    if (profileState is ProfileUpdating && profileState.user != null) {
      return profileState.user!.savedAddresses;
    }
    if (profileState is ProfileUpdateSuccess) {
      return profileState.authModel.user?.savedAddresses ?? const [];
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return BlocProvider(
      create: (context) => OrderRouteSelectionCubit(
        NominatimPlaceSearchService(),
        OrderOsrmRouteService(),
        initialPickup: OrderRouteDefaults.pickup,
        initialDropoff: OrderRouteDefaults.dropoff,
        initialPickupLabel: translate('order_current_location'),
      ),
      child: _BootstrapPickupFromGps(
        child: BlocListener<OrderRouteSelectionCubit, OrderRouteSelectionState>(
          listenWhen: (p, c) =>
              c.selectionRevision != p.selectionRevision ||
              p.pickup != c.pickup ||
              p.dropoff != c.dropoff ||
              p.routePoints != c.routePoints,
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
                      p.pickup != c.pickup ||
                      p.dropoff != c.dropoff ||
                      p.routePoints != c.routePoints,
                  builder: (context, state) {
                    final h = MediaQuery.sizeOf(context).height;
                    return Positioned.fill(
                      child: OrderRouteMapView(
                        isDark: isDark,
                        mapController: _mapController,
                        pickup: state.pickup,
                        dropoff: state.dropoff,
                        routePoints: state.routePoints,
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
                      return BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, profileState) {
                          final saved = _savedAddressesFromProfile(
                            profileState,
                          );
                          return BlocBuilder<
                            OrderRouteSelectionCubit,
                            OrderRouteSelectionState
                          >(
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
                                      translate(
                                        'order_select_dropoff_required',
                                      ),
                                    );
                                    return;
                                  }
                                  context
                                      .read<OrderRouteSelectionCubit>()
                                      .dismissSuggestions();
                                  // Step 2 — wire navigation when ready
                                },
                                savedAddresses: saved,
                                onSavedAddressSelected: (address) => context
                                    .read<OrderRouteSelectionCubit>()
                                    .applySavedAddressToDropoff(address),
                              );
                            },
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
