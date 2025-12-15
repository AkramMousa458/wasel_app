import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';

/// A service class for handling API requests with Dio.
/// Supports GET, POST, PUT (update), and DELETE methods.
/// Uses Logger package for comprehensive logging.
class ApiService {
  final String _baseUrl;
  final Dio _dio;
  String? _token;
  final Logger _logger;

  /// Creates an [ApiService] instance.
  ///
  /// [dio] is the Dio HTTP client instance.
  /// [logger] is an optional Logger instance (will create one if not provided).
  /// [baseUrl] is the API base URL (optional, can be set via constructor).
  ApiService(this._dio, {Logger? logger, String? baseUrl})
    : _baseUrl = baseUrl ?? '',
      _logger =
          logger ??
          Logger(
            printer: PrettyPrinter(
              methodCount: 0,
              errorMethodCount: 5,
              lineLength: 50,
              colors: true,
              printEmojis: true,
            ),
          ) {
    // Initialize Dio with default settings
    _dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
    );
  }

  /// Initializes the service by loading the authentication token.
  Future<void> _initialize() async {
    _token = locator<LocalStorage>().authToken;
    if (_token == null) {
      // final prefs = await SharedPreferences.getInstance();
      _token = locator<LocalStorage>().authToken ?? '';
      _logger.i(
        'Token initialized $_token',
        error: _token?.isNotEmpty ?? false ? 'Token exists' : 'Empty token',
      );
    }
  }

  /// Makes a GET request to the specified endpoint.
  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _initialize();
    final uri = _buildUri(endPoint);

    _logRequest('GET', uri, queryParameters: queryParameters);

    try {
      final response = await _dio.get(
        uri.toString(),
        queryParameters: queryParameters,
        options: Options(
          headers: _buildHeaders(contentType: 'application/json'),
        ),
      );

      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    } catch (e) {
      _logger.e(
        'Unexpected error in GET request',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  /// Makes a POST request to the specified endpoint.
  Future<Map<String, dynamic>> post({
    required String endPoint,
    required dynamic data,
    bool isMultipart = false,
  }) async {
    await _initialize();
    final uri = _buildUri(endPoint);

    _logRequest('POST', uri, data: data);

    try {
      final response = await _dio.post(
        uri.toString(),
        data: data,
        options: Options(
          headers: _buildHeaders(
            contentType: isMultipart
                ? 'multipart/form-data'
                : 'application/json',
          ),
        ),
      );

      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    }
  }

  /// Makes a PUT (update) request to the specified endpoint.
  Future<Map<String, dynamic>> update({
    required String endPoint,
    required dynamic data,
  }) async {
    await _initialize();
    final uri = _buildUri(endPoint);

    _logRequest('PUT', uri, data: data);

    try {
      final response = await _dio.put(
        uri.toString(),
        data: data,
        options: Options(
          headers: _buildHeaders(contentType: 'application/json'),
        ),
      );

      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    }
  }

  /// Makes a DELETE request to the specified endpoint.
  Future<Map<String, dynamic>> delete({required String endPoint}) async {
    await _initialize();
    final uri = _buildUri(endPoint);

    _logRequest('DELETE', uri);

    try {
      final response = await _dio.delete(
        uri.toString(),
        options: Options(
          headers: _buildHeaders(contentType: 'application/json'),
        ),
      );

      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    }
  }

  // ========== PRIVATE HELPER METHODS ========== //

  Uri _buildUri(String endPoint) {
    if (endPoint.startsWith('http')) {
      return Uri.parse(endPoint);
    }
    return Uri.parse(
      '$_baseUrl${endPoint.startsWith('/') ? endPoint.substring(1) : endPoint}',
    );
  }

  Map<String, dynamic> _buildHeaders({required String contentType}) {
    final headers = <String, dynamic>{
      'Content-Type': contentType,
      'Accept': 'application/json',
      'language': 'ar',
    };

    if (_token?.isNotEmpty ?? false) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  void _logRequest(
    String method,
    Uri uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    _logger.d({
      'type': 'API Request',
      'method': method,
      'path': uri.path,
      'fullUrl': uri.toString(),
      if (queryParameters != null) 'queryParams': queryParameters,
      if (data != null) 'body': data,
    });
  }

  void _logResponse(Response response) {
    _logger.i({
      'type': 'API Response',
      'url': response.realUri.toString(),
      'data': response.data,
    });
  }

  void _logError(DioException error, Uri uri) {
    _logger.e({
      'type': 'API Error',
      'url': uri.toString(),
      'response': error.response?.data,
    });
  }
}
