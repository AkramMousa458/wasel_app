import 'package:dio/dio.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/order/data/models/order_place_suggestion.dart';

/// Forward geocoding via [Nominatim](https://nominatim.org/release-docs/latest/api/Search/).
/// Uses a dedicated [Dio] instance (no app auth headers).
class NominatimPlaceSearchService {
  NominatimPlaceSearchService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://nominatim.openstreetmap.org',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              headers: const {
                // Required by Nominatim usage policy
                'User-Agent': 'WaselApp/1.0 (com.example.wasel)',
              },
            ),
          );

  final Dio _dio;

  /// Minimum query length enforced by callers; empty returns [].
  Future<List<OrderPlaceSuggestion>> search(String query) async {
    final q = query.trim();
    if (q.length < 3) return [];

    final lang = locator<LocalStorage>().language ?? 'en';
    final response = await _dio.get<List<dynamic>>(
      '/search',
      queryParameters: <String, dynamic>{
        'q': q,
        'format': 'json',
        'limit': 8,
        'addressdetails': 1,
      },
      options: Options(
        headers: <String, dynamic>{'Accept-Language': lang},
      ),
    );

    final data = response.data;
    if (data == null) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(OrderPlaceSuggestion.fromNominatimJson)
        .where((e) => e.displayName.isNotEmpty && e.lat != 0 && e.lon != 0)
        .toList();
  }
}
