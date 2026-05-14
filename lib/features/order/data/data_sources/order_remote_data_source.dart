import 'package:dio/dio.dart';
import 'package:wasel/core/error/failure.dart';
import 'package:wasel/core/services/api_service.dart';
import 'package:wasel/core/utils/endpoint.dart';
import 'package:wasel/features/order/data/models/create_order_response.dart';
import 'package:wasel/features/order/data/models/orders_list_response.dart';

class OrderRemoteDataSource {
  OrderRemoteDataSource({required this.apiService});

  final ApiService apiService;

  Future<CreateOrderResponse> createOrder(Map<String, dynamic> body) async {
    try {
      final response = await apiService.post(
        endPoint: Endpoint.orders,
        data: body,
      );
      final parsed = CreateOrderResponse.fromJson(response);
      final orderId = parsed.order?.id ?? '';
      if (!parsed.success || orderId.isEmpty) {
        final msg = response['message']?.toString();
        throw ServerFailure(
          message: (msg != null && msg.isNotEmpty)
              ? msg
              : 'Order could not be created',
          data: response,
        );
      }
      return parsed;
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }

  Future<OrdersListResponse> getOrders({
    int limit = 50,
    int skip = 0,
  }) async {
    try {
      final response = await apiService.get(
        endPoint: Endpoint.orders,
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );
      final parsed = OrdersListResponse.fromJson(response);
      if (!parsed.success) {
        final msg = response['message']?.toString();
        throw ServerFailure(
          message: (msg != null && msg.isNotEmpty)
              ? msg
              : 'Could not load orders',
          data: response,
        );
      }
      return parsed;
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }
}
