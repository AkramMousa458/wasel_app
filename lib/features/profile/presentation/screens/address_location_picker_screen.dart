import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:latlong2/latlong.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/order/data/models/order_place_suggestion.dart';
import 'package:wasel/features/order/data/services/nominatim_place_search_service.dart';
import 'package:wasel/features/order/presentation/constants/order_map_config.dart';
import 'package:wasel/features/order/presentation/widgets/order_route_search_suggestions.dart';
import 'dart:async';

class AddressLocationPickerScreen extends StatefulWidget {
  const AddressLocationPickerScreen({super.key, required this.initialLocation});

  final LatLng initialLocation;

  @override
  State<AddressLocationPickerScreen> createState() =>
      _AddressLocationPickerScreenState();
}

class _AddressLocationPickerScreenState
    extends State<AddressLocationPickerScreen> {
  late final MapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  final NominatimPlaceSearchService _searchService =
      NominatimPlaceSearchService();
  late LatLng _pickedLocation;
  Timer? _searchDebounce;
  List<OrderPlaceSuggestion> _suggestions = const [];
  bool _isSearching = false;
  String? _searchErrorKey;
  int _searchRequestId = 0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pickedLocation = widget.initialLocation;
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    final query = value.trim();
    if (query.length < 3) {
      setState(() {
        _isSearching = false;
        _searchErrorKey = null;
        _suggestions = const [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchErrorKey = null;
    });
    _searchDebounce = Timer(const Duration(milliseconds: 450), () async {
      final requestId = ++_searchRequestId;
      try {
        final results = await _searchService.search(query);
        if (!mounted || requestId != _searchRequestId) return;
        setState(() {
          _isSearching = false;
          _suggestions = results;
          _searchErrorKey = results.isEmpty ? 'order_no_results' : null;
        });
      } catch (_) {
        if (!mounted || requestId != _searchRequestId) return;
        setState(() {
          _isSearching = false;
          _suggestions = const [];
          _searchErrorKey = 'order_search_failed';
        });
      }
    });
  }

  void _selectSuggestion(OrderPlaceSuggestion suggestion) {
    final point = LatLng(suggestion.lat, suggestion.lon);
    setState(() {
      _pickedLocation = point;
      _searchController.text = suggestion.displayName;
      _suggestions = const [];
      _searchErrorKey = null;
      _isSearching = false;
    });
    _mapController.move(point, 16);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final template = OrderMapConfig.urlTemplate(isDark);
    final subdomains = OrderMapConfig.subdomainsForTemplate(isDark);

    return Scaffold(
      appBar: AppBar(title: Text(translate('location_from_map'))),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _pickedLocation,
              initialZoom: 15,
              minZoom: 3,
              maxZoom: 18,
              onTap: (_, point) {
                setState(() => _pickedLocation = point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: template,
                subdomains: subdomains,
                userAgentPackageName: 'com.example.wasel',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _pickedLocation,
                    width: 42,
                    height: 42,
                    child: const Icon(
                      Icons.location_pin,
                      color: AppColors.primary,
                      size: 42,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 12.w,
            right: 12.w,
            top: 12.h,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: translate('search_pickup_hint'),
                      prefixIcon: const Icon(Icons.search_rounded),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  if (_isSearching ||
                      _searchErrorKey != null ||
                      _suggestions.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    OrderRouteSearchSuggestions(
                      isDark: isDark,
                      suggestions: _suggestions,
                      isSearching: _isSearching,
                      errorTranslateKey: _searchErrorKey,
                      onSelect: _selectSuggestion,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 20.h,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(_pickedLocation),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                translate('set_on_map'),
                style: AppStyles.textstyle14.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
