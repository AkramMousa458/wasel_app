import 'package:dartz/dartz.dart';
import 'package:wasel/core/error/failure.dart';
import 'package:wasel/features/order/data/data_sources/order_remote_data_source.dart';
import 'package:wasel/features/order/data/models/create_order_response.dart';
import 'package:wasel/features/order/data/models/orders_list_response.dart';

class OrderRepoImpl {
  OrderRepoImpl({required this.remoteDataSource});

  final OrderRemoteDataSource remoteDataSource;

  Future<Either<ApiFailure, CreateOrderResponse>> createOrder(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await remoteDataSource.createOrder(body);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<ApiFailure, OrdersListResponse>> getOrders({
    int limit = 50,
    int skip = 0,
  }) async {
    try {
      final result = await remoteDataSource.getOrders(limit: limit, skip: skip);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
