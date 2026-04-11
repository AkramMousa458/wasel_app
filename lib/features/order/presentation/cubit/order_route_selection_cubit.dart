import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/order/data/models/order_place_suggestion.dart';
import 'package:wasel/features/order/data/services/nominatim_place_search_service.dart';
import 'package:wasel/features/order/presentation/cubit/order_route_selection_state.dart';

class OrderRouteSelectionCubit extends Cubit<OrderRouteSelectionState> {
  OrderRouteSelectionCubit(
    this._searchService, {
    required LatLng initialPickup,
    required LatLng initialDropoff,
    required String initialPickupLabel,
    String initialDropoffLabel = '',
  }) : super(
         OrderRouteSelectionState(
           pickup: initialPickup,
           dropoff: initialDropoff,
           pickupCommittedLabel: initialPickupLabel,
           dropoffCommittedLabel: initialDropoffLabel,
         ),
       );

  final NominatimPlaceSearchService _searchService;
  Timer? _debounce;

  static const Duration _debounceDelay = Duration(milliseconds: 450);

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  void focusPickupField() {
    emit(state.copyWith(activeSearchField: OrderRouteSearchField.pickup));
  }

  void focusDropoffField() {
    emit(state.copyWith(activeSearchField: OrderRouteSearchField.dropoff));
  }

  void dismissSuggestions() {
    emit(
      state.copyWith(
        suggestions: const [],
        isSearching: false,
        clearActiveSearchField: true,
      ),
    );
  }

  void onPickupQueryChanged(String query) {
    _scheduleSearch(query, OrderRouteSearchField.pickup);
  }

  void onDropoffQueryChanged(String query) {
    _scheduleSearch(query, OrderRouteSearchField.dropoff);
  }

  void _scheduleSearch(String query, OrderRouteSearchField field) {
    _debounce?.cancel();
    emit(
      state.copyWith(
        activeSearchField: field,
        clearSearchError: true,
      ),
    );

    final q = query.trim();
    if (q.length < 3) {
      emit(
        state.copyWith(
          suggestions: const [],
          isSearching: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isSearching: true));

    _debounce = Timer(_debounceDelay, () async {
      try {
        final results = await _searchService.search(q);
        if (isClosed) return;
        if (state.activeSearchField != field) return;
        if (results.isEmpty) {
          emit(
            state.copyWith(
              suggestions: const [],
              isSearching: false,
              searchError: 'order_no_results',
            ),
          );
        } else {
          emit(
            state.copyWith(
              suggestions: results,
              isSearching: false,
              clearSearchError: true,
            ),
          );
        }
      } catch (_) {
        if (isClosed) return;
        if (state.activeSearchField != field) return;
        emit(
          state.copyWith(
            suggestions: const [],
            isSearching: false,
            searchError: 'order_search_failed',
          ),
        );
      }
    });
  }

  /// Sets pickup to the device GPS point (e.g. on screen open). Keeps [label] when omitted.
  void setPickupFromDeviceLocation(LatLng point, {String? label}) {
    _debounce?.cancel();
    emit(
      state.copyWith(
        pickup: point,
        pickupCommittedLabel: label ?? state.pickupCommittedLabel,
        suggestions: const [],
        isSearching: false,
        clearActiveSearchField: true,
        selectionRevision: state.selectionRevision + 1,
      ),
    );
  }

  void selectSuggestion(OrderPlaceSuggestion suggestion) {
    final field = state.activeSearchField;
    if (field == null) return;
    _debounce?.cancel();
    final point = LatLng(suggestion.lat, suggestion.lon);
    if (field == OrderRouteSearchField.pickup) {
      emit(
        state.copyWith(
          pickup: point,
          pickupCommittedLabel: suggestion.displayName,
          suggestions: const [],
          isSearching: false,
          clearActiveSearchField: true,
          selectionRevision: state.selectionRevision + 1,
        ),
      );
    } else {
      emit(
        state.copyWith(
          dropoff: point,
          dropoffCommittedLabel: suggestion.displayName,
          suggestions: const [],
          isSearching: false,
          clearActiveSearchField: true,
          selectionRevision: state.selectionRevision + 1,
          dropoffUserConfirmed: true,
        ),
      );
    }
  }

  /// Applies a saved profile address to **drop-off** (typical for Home / Work).
  void applySavedAddressToDropoff(SavedAddress address) {
    _debounce?.cancel();
    final c = address.location.coordinates;
    if (c.length < 2) return;
    final lng = c[0];
    final lat = c[1];
    final label = _formatSavedAddressLine(address);
    emit(
      state.copyWith(
        dropoff: LatLng(lat, lng),
        dropoffCommittedLabel: label,
        suggestions: const [],
        isSearching: false,
        clearActiveSearchField: true,
        selectionRevision: state.selectionRevision + 1,
        dropoffUserConfirmed: true,
      ),
    );
  }

  String _formatSavedAddressLine(SavedAddress address) {
    final parts = <String>[
      address.label,
      address.address.street,
      address.address.city,
    ].where((e) => e.trim().isNotEmpty).toList();
    return parts.take(3).join(', ');
  }

  /// Returns `true` if drop-off was set from search or a saved place.
  bool validateForNextStep() {
    return state.dropoffUserConfirmed &&
        state.dropoffCommittedLabel.trim().isNotEmpty;
  }
}
