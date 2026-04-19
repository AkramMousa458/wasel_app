import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:wasel/features/order/data/models/order_place_suggestion.dart';

enum OrderRouteSearchField { pickup, dropoff }

class OrderRouteSelectionState extends Equatable {
  final LatLng pickup;
  final LatLng dropoff;
  final String pickupCommittedLabel;
  final String dropoffCommittedLabel;
  final List<OrderPlaceSuggestion> suggestions;
  final bool isSearching;
  final String? searchError;
  final OrderRouteSearchField? activeSearchField;
  /// Bumps when a place is committed so UI can sync [TextEditingController]s.
  final int selectionRevision;
  final bool dropoffUserConfirmed;
  /// Road geometry from OSRM; `null` means show straight fallback until loaded or on error.
  final List<LatLng>? routePoints;
  /// Driving distance from OSRM in kilometers.
  final double? routeDistanceKm;

  const OrderRouteSelectionState({
    required this.pickup,
    required this.dropoff,
    required this.pickupCommittedLabel,
    required this.dropoffCommittedLabel,
    this.suggestions = const [],
    this.isSearching = false,
    this.searchError,
    this.activeSearchField,
    this.selectionRevision = 0,
    this.dropoffUserConfirmed = false,
    this.routePoints,
    this.routeDistanceKm,
  });

  OrderRouteSelectionState copyWith({
    LatLng? pickup,
    LatLng? dropoff,
    String? pickupCommittedLabel,
    String? dropoffCommittedLabel,
    List<OrderPlaceSuggestion>? suggestions,
    bool? isSearching,
    String? searchError,
    bool clearSearchError = false,
    OrderRouteSearchField? activeSearchField,
    bool clearActiveSearchField = false,
    int? selectionRevision,
    bool? dropoffUserConfirmed,
    List<LatLng>? routePoints,
    bool clearRoutePoints = false,
    double? routeDistanceKm,
    bool clearRouteDistance = false,
  }) {
    return OrderRouteSelectionState(
      pickup: pickup ?? this.pickup,
      dropoff: dropoff ?? this.dropoff,
      pickupCommittedLabel: pickupCommittedLabel ?? this.pickupCommittedLabel,
      dropoffCommittedLabel:
          dropoffCommittedLabel ?? this.dropoffCommittedLabel,
      suggestions: suggestions ?? this.suggestions,
      isSearching: isSearching ?? this.isSearching,
      searchError: clearSearchError
          ? null
          : (searchError ?? this.searchError),
      activeSearchField: clearActiveSearchField
          ? null
          : (activeSearchField ?? this.activeSearchField),
      selectionRevision: selectionRevision ?? this.selectionRevision,
      dropoffUserConfirmed: dropoffUserConfirmed ?? this.dropoffUserConfirmed,
      routePoints: clearRoutePoints ? null : (routePoints ?? this.routePoints),
      routeDistanceKm: clearRouteDistance
          ? null
          : (routeDistanceKm ?? this.routeDistanceKm),
    );
  }

  @override
  List<Object?> get props => [
    pickup,
    dropoff,
    pickupCommittedLabel,
    dropoffCommittedLabel,
    suggestions,
    isSearching,
    searchError,
    activeSearchField,
    selectionRevision,
    dropoffUserConfirmed,
    routePoints,
    routeDistanceKm,
  ];
}
