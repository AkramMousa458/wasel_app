import 'package:wasel/core/utils/app_string.dart';
import 'package:wasel/features/order_history/data/models/order_model.dart';

class SplitOrdersForHistory {
  const SplitOrdersForHistory({
    required this.activeOrders,
    required this.pastOrders,
  });

  final List<OrderModel> activeOrders;
  final List<OrderModel> pastOrders;
}

SplitOrdersForHistory mapApiOrdersToHistoryModels(
  List<Map<String, dynamic>> rawOrders,
) {
  final active = <OrderModel>[];
  final past = <OrderModel>[];

  for (final json in rawOrders) {
    final order = orderModelFromApiOrder(json);

    if (_isPastApiStatus(
      json['status']?.toString() ?? '',
    )) {
      past.add(order);
    } else {
      active.add(order);
    }
  }

  return SplitOrdersForHistory(
    activeOrders: active,
    pastOrders: past,
  );
}

bool _isPastApiStatus(String status) {
  final s = status.toLowerCase();

  return s == 'delivered' ||
      s == 'cancelled' ||
      s == 'refunded';
}

OrderModel orderModelFromApiOrder(
  Map<String, dynamic> json,
) {
  final customer = json['customer'] is Map
      ? Map<String, dynamic>.from(
          json['customer'],
        )
      : <String, dynamic>{};

  final pickup = json['pickup'] is Map
      ? Map<String, dynamic>.from(
          json['pickup'],
        )
      : <String, dynamic>{};

  final dropoff = json['dropoff'] is Map
      ? Map<String, dynamic>.from(
          json['dropoff'],
        )
      : <String, dynamic>{};

  final items = json['items'] is List
      ? List<Map<String, dynamic>>.from(
          json['items'],
        )
      : <Map<String, dynamic>>[];

  final firstItem = items.isNotEmpty
      ? items.first
      : <String, dynamic>{};

  final driverJson = json['driver'];

  final imagePath =
      customer['image']?.toString();

  final distanceMeters =
      (json['distanceMeters'] as num?)
              ?.toDouble() ??
          0;

  return OrderModel(
    id: json['_id']?.toString() ?? '',

    /// CUSTOMER
    customerName:
        customer['name']?['ar']
                ?.toString() ??
            customer['name']?['en']
                ?.toString() ??
            '',

    customerImage:
        _resolveMediaUrl(imagePath),

    /// DRIVER
    driver: driverJson != null
        ? DriverModel.fromJson(
            Map<String, dynamic>.from(
              driverJson,
            ),
          )
        : null,

    /// ORDER
    title:
        firstItem['title']?.toString() ??
            'Order',

    description: _routeDescription(
      pickup['address']?.toString() ?? '',
      dropoff['address']?.toString() ?? '',
    ),

    notes:
        json['notes']?.toString() ?? '',

    /// LOCATIONS
    pickupAddress:
        pickup['address']?.toString() ??
            '',

    dropoffAddress:
        dropoff['address']?.toString() ??
            '',

    /// FINANCIAL
    total:
        (json['total'] as num?)
                ?.toDouble() ??
            0,

    deliveryFee:
        (json['deliveryFee'] as num?)
                ?.toDouble() ??
            0,

    subTotal:
        (json['subTotal'] as num?)
                ?.toDouble() ??
            0,

    /// STATUS
    status: orderStatusFromApiString(
      json['status']?.toString() ?? '',
    ),

    type: _mapOrderType(
      json['requestType']
              ?.toString() ??
          '',
    ),

    /// PAYMENT
    paymentMethod:
        json['paymentMethod']
                ?.toString() ??
            '',

    paymentStatus:
        json['paymentStatus']
                ?.toString() ??
            '',

    /// DISTANCE
    distanceKm:
        distanceMeters / 1000,

    /// ITEMS
    itemsCount: items.length,

    /// SLA
    slaMinutes: _asInt(
      json['slaPromisedMinutes'],
    ),

    /// TIME
    createdAt: DateTime.tryParse(
      json['createdAt']?.toString() ??
          '',
    ),
  );
}

OrderType _mapOrderType(String type) {
  if (type
      .toLowerCase()
      .contains('pickup')) {
    return OrderType.pickup;
  }

  return OrderType.delivery;
}

String _routeDescription(
  String pickup,
  String dropoff,
) {
  if (pickup.isEmpty &&
      dropoff.isEmpty) {
    return '';
  }

  if (pickup.isEmpty) {
    return dropoff;
  }

  if (dropoff.isEmpty) {
    return pickup;
  }

  return '$pickup → $dropoff';
}

String _resolveMediaUrl(String? path) {
  if (path == null || path.isEmpty) {
    return '';
  }

  if (path.startsWith('http')) {
    return path;
  }

  final base =
      AppString.baseUrl.replaceAll(
    RegExp(r'/+$'),
    '',
  );

  final p = path.startsWith('/')
      ? path.substring(1)
      : path;

  return '$base/$p';
}

int? _asInt(dynamic v) {
  if (v == null) return null;

  if (v is int) return v;

  if (v is num) return v.toInt();

  return int.tryParse(v.toString());
}

OrderStatus orderStatusFromApiString(
  String status,
) {
  final s =
      status.toLowerCase().trim();

  switch (s) {
    case 'accepted':
      return OrderStatus.accepted;

    case 'driver_assigned':
    case 'assigned':
      return OrderStatus.courierAssigned;

    case 'picked_up':
      return OrderStatus.pickedUp;

    case 'in_transit':
      return OrderStatus.inTransit;

    case 'delivered':
      return OrderStatus.delivered;

    case 'cancelled':
    case 'canceled':
      return OrderStatus.cancelled;

    case 'disputed':
      return OrderStatus.disputed;

    case 'created':
    default:
      return OrderStatus.created;
  }
}