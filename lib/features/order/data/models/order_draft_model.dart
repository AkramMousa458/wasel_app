class OrderDraftModel {
  const OrderDraftModel({
    this.pickupAddress,
    this.dropoffAddress,
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
