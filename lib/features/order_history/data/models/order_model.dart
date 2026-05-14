import 'package:equatable/equatable.dart';

enum OrderStatus {
  created,
  accepted,
  courierAssigned,
  pickedUp,
  inTransit,
  delivered,
  cancelled,
  disputed,
}

enum OrderType {
  delivery,
  pickup,
}

class DriverModel extends Equatable {
  final String id;
  final String name;
  final String image;

  const DriverModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory DriverModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverModel(
      id: json['_id']?.toString() ?? '',

      name:
          json['name']?['ar']?.toString() ??
          json['name']?['en']?.toString() ??
          '',

      image: json['image']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        image,
      ];
}

class OrderModel extends Equatable {
  final String id;

  /// CUSTOMER
  final String customerName;
  final String customerImage;

  /// DRIVER
  final DriverModel? driver;

  /// ORDER INFO
  final String title;
  final String description;
  final String notes;

  /// LOCATIONS
  final String pickupAddress;
  final String dropoffAddress;

  /// FINANCIAL
  final double total;
  final double deliveryFee;
  final double subTotal;

  /// STATUS
  final OrderStatus status;
  final OrderType type;

  /// PAYMENT
  final String paymentMethod;
  final String paymentStatus;

  /// SLA
  final int? slaMinutes;

  /// DISTANCE
  final double distanceKm;

  /// ITEMS
  final int itemsCount;

  /// TIME
  final DateTime? createdAt;

  const OrderModel({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.driver,
    required this.title,
    required this.description,
    required this.notes,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.total,
    required this.deliveryFee,
    required this.subTotal,
    required this.status,
    required this.type,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.distanceKm,
    required this.itemsCount,
    this.slaMinutes,
    this.createdAt,
  });

  bool get hasDriver => driver != null;

  @override
  List<Object?> get props => [
        id,
        customerName,
        customerImage,
        driver,
        title,
        description,
        notes,
        pickupAddress,
        dropoffAddress,
        total,
        deliveryFee,
        subTotal,
        status,
        type,
        paymentMethod,
        paymentStatus,
        distanceKm,
        itemsCount,
        slaMinutes,
        createdAt,
      ];
}