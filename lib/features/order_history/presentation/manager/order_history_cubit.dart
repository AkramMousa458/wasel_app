import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/features/order_history/data/models/order_model.dart';
import 'package:wasel/features/order_history/presentation/manager/order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit() : super(OrderHistoryInitial());

  void loadOrders() async {
    emit(OrderHistoryLoading());
    try {
      // API Simulation
      await Future.delayed(const Duration(seconds: 1));

      final activeOrders = [
        const OrderModel(
          id: '4421',
          storeName: 'Star Coffee',
          description: 'Order #4421 • Group Order',
          imageUrl:
              'https://images.unsplash.com/photo-1559496417-e7f25cb247f3?auto=format&fit=crop&w=100&q=80', // Coffee image
          status: OrderStatus.inTransit,
          type: OrderType.delivery,
          arrivalTime: '12m',
          profileImages: [
            'https://randomuser.me/api/portraits/women/44.jpg',
            'https://randomuser.me/api/portraits/men/32.jpg',
          ],
          newItemCount: 2,
        ),
        const OrderModel(
          id: '5532',
          storeName: 'IKEA Package',
          description: 'Courier Assigned • Pickup at 4:00 PM',
          imageUrl:
              'https://images.unsplash.com/photo-1595246140625-573b715d1128?auto=format&fit=crop&w=100&q=80', // Box image
          status: OrderStatus.courierAssigned,
          type: OrderType.pickup,
          arrivalTime: '4:00 PM',
          price: 24.50,
        ),
      ];

      final pastOrders = [
        const OrderModel(
          id: '1234',
          storeName: 'Legal Documents',
          description: 'Delivered',
          imageUrl:
              'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&w=100&q=80', // Document image
          status: OrderStatus.delivered,
          type: OrderType.delivery,
          arrivalTime: '',
        ),
        const OrderModel(
          id: '5678',
          storeName: 'Burger King',
          description: 'Cancelled',
          imageUrl:
              'https://images.unsplash.com/photo-1571091718767-18b5b1457add?auto=format&fit=crop&w=100&q=80', // Burger image
          status: OrderStatus.cancelled,
          type: OrderType.delivery,
          arrivalTime: '',
        ),
      ];

      if (!isClosed) {
        emit(
          OrderHistoryLoaded(
            activeOrders: activeOrders,
            pastOrders: pastOrders,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) emit(const OrderHistoryError('Failed to load orders'));
    }
  }
}
