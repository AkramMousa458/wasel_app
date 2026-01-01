import 'package:equatable/equatable.dart';

enum OrderStatus { inTransit, courierAssigned, delivered, cancelled }

enum OrderType { delivery, pickup }

class OrderModel extends Equatable {
  final String id;
  final String storeName;
  final String description; // "Order #4421 • Group Order"
  final String imageUrl;
  final OrderStatus status;
  final OrderType type;
  final String arrivalTime; // "Arriving in 12m" or "Pickup at 4:00 PM"
  final double? price;
  final List<String> profileImages; // For group orders
  final int newItemCount; // "+2"

  const OrderModel({
    required this.id,
    required this.storeName,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.type,
    required this.arrivalTime,
    this.price,
    this.profileImages = const [],
    this.newItemCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    storeName,
    description,
    imageUrl,
    status,
    type,
    arrivalTime,
    price,
    profileImages,
    newItemCount,
  ];
}
