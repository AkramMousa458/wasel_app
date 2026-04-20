class OrderPackageDetailsDraft {
  const OrderPackageDetailsDraft({
    required this.details,
    required this.packageSize,
    this.imagePath,
  });

  final String details;
  final String packageSize;
  final String? imagePath;
}
