/// Tile configuration for the order flow map.
///
/// Official `tile.openstreetmap.org` does not support `{s}` subdomains (see OSM
/// tile usage policy). To use **`mt0`–`mt3`** as in your spec, host an
/// OSM-compatible raster endpoint such as:
/// `https://{s}.your-cdn.com/tiles/{z}/{x}/{y}.png`
/// and set [useCustomMirror] to `true` plus [customMirrorHost].
abstract final class OrderMapConfig {
  /// Subdomains you requested for round-robin tile loading.
  static const List<String> tileSubdomains = ['mt0', 'mt1', 'mt2', 'mt3'];

  /// When `true`, tiles load from `https://{s}.[customMirrorHost]/{z}/{x}/{y}.png`
  /// using [tileSubdomains]. Deploy your mirror before enabling.
  static const bool useCustomMirror = false;

  /// Host only (no scheme), e.g. `tiles.mycompany.com`.
  static const String customMirrorHost = '';

  /// Carto OSM-derived tiles (light) — works without a private mirror.
  static const String _cartoLight =
      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';

  /// Carto OSM-derived tiles (dark).
  // static const String _cartoDark =
  //     'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

  static const List<String> _cartoSubdomains = ['a', 'b', 'c', 'd'];

  static String urlTemplate(bool isDark) {
    if (useCustomMirror && customMirrorHost.isNotEmpty) {
      return 'https://{s}.$customMirrorHost/{z}/{x}/{y}.png';
    }
    return _cartoLight;
    // return isDark ? _cartoDark : _cartoLight;
  }

  /// Subdomains passed to [TileLayer]. Must match `{s}` in [urlTemplate].
  static List<String> subdomainsForTemplate(bool isDark) {
    if (useCustomMirror && customMirrorHost.isNotEmpty) {
      return tileSubdomains;
    }
    if (urlTemplate(isDark).contains('{s}')) {
      return _cartoSubdomains;
    }
    return const [];
  }
}
