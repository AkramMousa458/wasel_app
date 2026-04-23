/// Arguments for [LiveDeliveryTrackingScreen] (from GoRouter `extra`).
class LiveDeliveryScreenArgs {
  const LiveDeliveryScreenArgs({
    required this.orderId,
    this.courierName,
    this.etaMinutes,
    this.courierAvatarUrl,
    this.currentStepIndex = 2,
  });

  final String orderId;
  final String? courierName;
  final int? etaMinutes;
  final String? courierAvatarUrl;

  /// Active timeline step: 0 assigned … 3 delivered.
  final int currentStepIndex;
}
