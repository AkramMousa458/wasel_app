class OrderPackageDetailsDraft {
  const OrderPackageDetailsDraft({
    required this.details,
    required this.packageSize,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.imagePath,
  });

  final String details;
  final String packageSize;
  final String pickupAddress;
  final String dropoffAddress;
  final String? imagePath;
}
