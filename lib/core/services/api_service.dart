import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:wasel/core/router/app_router.dart';
import 'package:wasel/core/utils/endpoint.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/auth/presentation/screens/login_screen.dart';

/// A service class for handling API requests with Dio.
/// Supports GET, POST, PUT (update), PATCH and DELETE methods.
/// Uses a QueuedInterceptorsWrapper for silent 401 token refresh.
class ApiService {
  final String _baseUrl;
  final Dio _dio;
  String? _token;
  String? _language;
  final Logger _logger;

  bool _isRefreshing = false;

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
    _dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          final bool isUnauthorized = _isUnauthorizedError(error);

          if (isUnauthorized) {
            final bool refreshed = await _attemptRefresh();
            if (refreshed) {
              try {
                final requestOptions = error.requestOptions;
                requestOptions.headers['Authorization'] = 'Bearer $_token';
                final response = await _dio.fetch(requestOptions);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            } else {
              _token = null;
              await locator<LocalStorage>().logout();
              AppRouter.router.go(LoginScreen.routeName);
              return handler.reject(error);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  bool _isUnauthorizedError(DioException error) {
    if (error.response?.statusCode == 401) return true;
    if (error.response?.data is Map) {
      final message = (error.response!.data as Map)['message'];
      if (message == 'Invalid token' || message == 'jwt expired') return true;
    }
    return false;
  }

  Future<bool> _attemptRefresh() async {
    final refreshToken = locator<LocalStorage>().refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return false;
    if (_isRefreshing) return false;

    _isRefreshing = true;
    try {
      final uri = _buildUri(Endpoint.refreshToken);
      final refreshDio = Dio();
      final response = await refreshDio.post(
        uri.toString(),
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (_language != null) 'x-lang': _language,
            'x-country': 'EG',
          },
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final newToken = data['accessToken'] as String?;
        if (newToken != null && newToken.isNotEmpty) {
          _token = newToken;
          await locator<LocalStorage>().saveAuthToken(newToken);

          final newRefresh = data['refreshToken'] as String?;
          if (newRefresh != null && newRefresh.isNotEmpty) {
            await locator<LocalStorage>().saveRefreshToken(newRefresh);
          }
          _isRefreshing = false;
          log('ApiService: Access token refreshed silently.');
          return true;
        }
      }
    } catch (e) {
      _logger.e('ApiService: Silent token refresh failed', error: e);
    }

    _isRefreshing = false;
    return false;
  }

  /// Initializes the service by loading the latest token and language.
  Future<void> _initialize() async {
    _token = locator<LocalStorage>().authToken ?? '';
    _language = locator<LocalStorage>().language ?? 'ar';
  }

  /// Makes a GET request.
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
        options: Options(headers: _buildHeaders()),
      );
      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    } catch (e) {
      _logger.e('Unexpected GET error', error: e);
      rethrow;
    }
  }

  /// Makes a POST request.
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
            contentType: isMultipart ? 'multipart/form-data' : 'application/json',
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

  /// Makes a PUT request.
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
        options: Options(headers: _buildHeaders()),
      );
      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    }
  }

  /// Makes a PATCH request.
  Future<Map<String, dynamic>> patch({
    required String endPoint,
    required dynamic data,
    bool isMultipart = false,
  }) async {
    await _initialize();
    final uri = _buildUri(endPoint);
    _logRequest('PATCH', uri, data: data);
    try {
      final response = await _dio.patch(
        uri.toString(),
        data: data,
        options: Options(
          headers: _buildHeaders(
            contentType: isMultipart ? 'multipart/form-data' : 'application/json',
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

  /// Makes a DELETE request.
  Future<Map<String, dynamic>> delete({required String endPoint}) async {
    await _initialize();
    final uri = _buildUri(endPoint);
    _logRequest('DELETE', uri);
    try {
      final response = await _dio.delete(
        uri.toString(),
        options: Options(headers: _buildHeaders()),
      );
      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    }
  }

  // ========== PRIVATE HELPERS ========== //

  Uri _buildUri(String endPoint) {
    if (endPoint.startsWith('http')) return Uri.parse(endPoint);
    return Uri.parse(
      '$_baseUrl${endPoint.startsWith('/') ? endPoint.substring(1) : endPoint}',
    );
  }

  Map<String, dynamic> _buildHeaders({
    String contentType = 'application/json',
  }) {
    final headers = <String, dynamic>{
      'Content-Type': contentType,
      'Accept': 'application/json',
      'x-lang': _language ?? 'ar',
      'x-country': 'EG',
    };
    if (_token != null && _token!.isNotEmpty) {
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
