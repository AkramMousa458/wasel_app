import 'package:equatable/equatable.dart';
import 'package:wasel/features/order/data/models/create_order_response.dart';

sealed class CreateOrderState extends Equatable {
  const CreateOrderState();

  @override
  List<Object?> get props => [];
}

class CreateOrderInitial extends CreateOrderState {
  const CreateOrderInitial();
}

class CreateOrderLoading extends CreateOrderState {
  const CreateOrderLoading();
}

class CreateOrderSuccess extends CreateOrderState {
  const CreateOrderSuccess(this.response);

  final CreateOrderResponse response;

  @override
  List<Object?> get props => [response];
}

class CreateOrderFailure extends CreateOrderState {
  const CreateOrderFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
