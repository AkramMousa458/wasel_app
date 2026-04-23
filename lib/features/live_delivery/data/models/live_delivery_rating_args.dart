class LiveDeliveryRatingArgs {
  const LiveDeliveryRatingArgs({
    required this.orderId,
    required this.courierName,
    this.receiverName = 'Sarah',
    this.courierAvatarUrl,
    this.vehicle = 'Toyota Camry',
    this.initialRating = 4.9,
  });

  final String orderId;
  final String courierName;
  final String receiverName;
  final String? courierAvatarUrl;
  final String vehicle;
  final double initialRating;
}
