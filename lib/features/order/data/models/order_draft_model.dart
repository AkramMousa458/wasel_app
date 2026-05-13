class OrderDraftModel {
  const OrderDraftModel({
    this.pickupAddress,
    this.dropoffAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.details,
    this.packageSize,
    this.imagePath,
    this.paymentMethodId,
    this.paymentMethodLabel,
    this.deliveryFee,
    this.serviceFee,
    this.estimatedWeightKg,
  });

  final String? pickupAddress;
  final String? dropoffAddress;

  /// WGS84 latitude for pickup (required to submit order to API).
  final double? pickupLatitude;
  /// WGS84 longitude for pickup.
  final double? pickupLongitude;
  final double? dropoffLatitude;
  final double? dropoffLongitude;

  final String? details;
  final String? packageSize;
  final String? imagePath;

  final String? paymentMethodId;
  final String? paymentMethodLabel;
  final double? deliveryFee;
  final double? serviceFee;
  final double? estimatedWeightKg;

  double get total => (deliveryFee ?? 0) + (serviceFee ?? 0);

  OrderDraftModel copyWith({
    String? pickupAddress,
    String? dropoffAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    double? dropoffLatitude,
    double? dropoffLongitude,
    String? details,
    String? packageSize,
    String? imagePath,
    String? paymentMethodId,
    String? paymentMethodLabel,
    double? deliveryFee,
    double? serviceFee,
    double? estimatedWeightKg,
  }) {
    return OrderDraftModel(
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      dropoffLatitude: dropoffLatitude ?? this.dropoffLatitude,
      dropoffLongitude: dropoffLongitude ?? this.dropoffLongitude,
      details: details ?? this.details,
      packageSize: packageSize ?? this.packageSize,
      imagePath: imagePath ?? this.imagePath,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      paymentMethodLabel: paymentMethodLabel ?? this.paymentMethodLabel,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      serviceFee: serviceFee ?? this.serviceFee,
      estimatedWeightKg: estimatedWeightKg ?? this.estimatedWeightKg,
    );
  }
}
