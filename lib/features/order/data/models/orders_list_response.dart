/// Response from `GET api/v1/orders?limit=&skip=`.
class OrdersListResponse {
  const OrdersListResponse({
    required this.success,
    required this.orders,
    this.meta,
  });

  final bool success;
  final List<Map<String, dynamic>> orders;
  final OrdersListMeta? meta;

  factory OrdersListResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['orders'];
    final list = <Map<String, dynamic>>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map<String, dynamic>) {
          list.add(e);
        } else if (e is Map) {
          list.add(Map<String, dynamic>.from(e));
        }
      }
    }
    return OrdersListResponse(
      success: json['success'] == true,
      orders: list,
      meta: json['meta'] is Map<String, dynamic>
          ? OrdersListMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : (json['meta'] is Map
                ? OrdersListMeta.fromJson(
                    Map<String, dynamic>.from(json['meta'] as Map),
                  )
                : null),
    );
  }
}

class OrdersListMeta {
  const OrdersListMeta({
    this.totalCount,
    this.limit,
    this.skip,
    this.hasNextPage,
    this.hasPrevPage,
    this.currentPage,
  });

  final int? totalCount;
  final int? limit;
  final int? skip;
  final bool? hasNextPage;
  final bool? hasPrevPage;
  final int? currentPage;

  factory OrdersListMeta.fromJson(Map<String, dynamic> json) {
    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    return OrdersListMeta(
      totalCount: asInt(json['totalCount'] ?? json['total']),
      limit: asInt(json['limit']),
      skip: asInt(json['skip']),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPrevPage: json['hasPrevPage'] as bool?,
      currentPage: asInt(json['currentPage'] ?? json['page']),
    );
  }
}
