import 'package:equatable/equatable.dart';
import 'package:wasel/features/order_history/data/models/order_model.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<OrderModel> activeOrders;
  final List<OrderModel> pastOrders;

  const OrderHistoryLoaded({
    required this.activeOrders,
    required this.pastOrders,
  });

  @override
  List<Object> get props => [activeOrders, pastOrders];
}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  const OrderHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
