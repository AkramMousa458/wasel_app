import 'package:equatable/equatable.dart';

/// Single result from forward geocoding (e.g. Nominatim).
class OrderPlaceSuggestion extends Equatable {
  final String displayName;
  final double lat;
  final double lon;

  const OrderPlaceSuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory OrderPlaceSuggestion.fromNominatimJson(Map<String, dynamic> json) {
    final latRaw = json['lat'];
    final lonRaw = json['lon'];
    return OrderPlaceSuggestion(
      displayName: (json['display_name'] as String?)?.trim() ?? '',
      lat: latRaw is num ? latRaw.toDouble() : double.tryParse('$latRaw') ?? 0,
      lon: lonRaw is num ? lonRaw.toDouble() : double.tryParse('$lonRaw') ?? 0,
    );
  }

  @override
  List<Object?> get props => [displayName, lat, lon];
}
