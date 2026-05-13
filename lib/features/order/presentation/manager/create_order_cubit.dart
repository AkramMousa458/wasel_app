import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/order/data/create_order_request_builder.dart';
import 'package:wasel/features/order/data/models/order_draft_model.dart';
import 'package:wasel/features/order/data/repo/order_repo_impl.dart';
import 'package:wasel/features/order/presentation/manager/create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  CreateOrderCubit(this._orderRepo) : super(const CreateOrderInitial());

  final OrderRepoImpl _orderRepo;

  Future<void> submit(OrderDraftModel draft) async {
    final storage = locator<LocalStorage>();
    final lang = storage.language ?? 'en';
    final user = storage.getUserProfile();

    if (draft.pickupLatitude == null ||
        draft.pickupLongitude == null ||
        draft.dropoffLatitude == null ||
        draft.dropoffLongitude == null) {
      emit(const CreateOrderFailure('order_submit_missing_coordinates'));
      return;
    }

    emit(const CreateOrderLoading());

    final deviceId = await storage.getOrCreateCustomerDeviceId();
    final body = buildCreateOrderRequestBody(
      draft: draft,
      user: user,
      customerDeviceId: deviceId,
      languageCode: lang,
    );

    final result = await _orderRepo.createOrder(body);
    result.fold(
      (failure) => emit(CreateOrderFailure(failure.message)),
      (response) => emit(CreateOrderSuccess(response)),
    );
  }
}
