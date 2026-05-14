import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/features/order/data/repo/order_repo_impl.dart';
import 'package:wasel/features/order_history/data/mappers/api_order_list_mapper.dart';
import 'package:wasel/features/order_history/presentation/manager/order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit(this._orderRepo) : super(OrderHistoryInitial());

  final OrderRepoImpl _orderRepo;

  Future<void> loadOrders({int limit = 50, int skip = 0}) async {
    emit(OrderHistoryLoading());

    final result = await _orderRepo.getOrders(limit: limit, skip: skip);
    result.fold(
      (failure) {
        if (!isClosed) emit(OrderHistoryError(failure.message));
      },
      (response) {
        final split = mapApiOrdersToHistoryModels(response.orders);
        if (!isClosed) {
          emit(
            OrderHistoryLoaded(
              activeOrders: split.activeOrders,
              pastOrders: split.pastOrders,
            ),
          );
        }
      },
    );
  }
}
