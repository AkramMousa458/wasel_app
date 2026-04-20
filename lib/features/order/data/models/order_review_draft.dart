import 'package:wasel/features/order/data/models/order_package_details_draft.dart';

class OrderReviewDraft {
  const OrderReviewDraft({
    required this.packageDraft,
    required this.paymentMethodId,
    required this.paymentMethodLabel,
    required this.deliveryFee,
    required this.serviceFee,
    required this.estimatedWeightKg,
  });

  final OrderPackageDetailsDraft packageDraft;
  final String paymentMethodId;
  final String paymentMethodLabel;
  final double deliveryFee;
  final double serviceFee;
  final double estimatedWeightKg;

  double get total => deliveryFee + serviceFee;
}
