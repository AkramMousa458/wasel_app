/// Parsed success payload from `POST api/v1/orders`.
class CreateOrderResponse {
  const CreateOrderResponse({
    required this.success,
    this.order,
    this.sla,
  });

  final bool success;
  final CreatedOrder? order;
  final OrderSlaSummary? sla;

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      success: json['success'] == true,
      order: json['order'] is Map<String, dynamic>
          ? CreatedOrder.fromJson(json['order'] as Map<String, dynamic>)
          : null,
      sla: json['sla'] is Map<String, dynamic>
          ? OrderSlaSummary.fromJson(json['sla'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OrderSlaSummary {
  const OrderSlaSummary({
    this.tier,
    this.promisedBy,
    this.promisedMinutes,
  });

  final String? tier;
  final String? promisedBy;
  final int? promisedMinutes;

  factory OrderSlaSummary.fromJson(Map<String, dynamic> json) {
    final minutes = json['promisedMinutes'];
    return OrderSlaSummary(
      tier: json['tier']?.toString(),
      promisedBy: json['promisedBy']?.toString(),
      promisedMinutes: minutes is int
          ? minutes
          : (minutes is num ? minutes.toInt() : null),
    );
  }
}

/// Subset of the created order document used by the client after create.
class CreatedOrder {
  const CreatedOrder({
    required this.id,
    this.status,
    this.total,
    this.currency,
    this.paymentStatus,
    this.slaPromisedMinutes,
    this.slaPromisedBy,
  });

  final String id;
  final String? status;
  final num? total;
  final String? currency;
  final String? paymentStatus;
  final int? slaPromisedMinutes;
  final String? slaPromisedBy;

  factory CreatedOrder.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['_id']?.toString() ?? '';
    final minutes = json['slaPromisedMinutes'];
    return CreatedOrder(
      id: id,
      status: json['status']?.toString(),
      total: json['total'] as num?,
      currency: json['currency']?.toString(),
      paymentStatus: json['paymentStatus']?.toString(),
      slaPromisedMinutes: minutes is int
          ? minutes
          : (minutes is num ? minutes.toInt() : null),
      slaPromisedBy: json['slaPromisedBy']?.toString(),
    );
  }
}
