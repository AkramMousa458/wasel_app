import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wasel/core/utils/custom_snack_bar.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/order/data/models/order_package_details_draft.dart';
import 'package:wasel/features/order/presentation/screens/order_step_three_pickup_details_screen.dart';
import 'package:wasel/features/order/presentation/widgets/order_step_two/order_step_two_footer_note.dart';
import 'package:wasel/features/order/presentation/widgets/order_step_two/order_step_two_form_card.dart';
import 'package:wasel/features/order/presentation/widgets/order_step_two/order_step_two_header.dart';

class OrderStepTwoPackageDetailsScreen extends StatefulWidget {
  const OrderStepTwoPackageDetailsScreen({super.key});

  static const String routeName = '/order/package-details';

  @override
  State<OrderStepTwoPackageDetailsScreen> createState() =>
      _OrderStepTwoPackageDetailsScreenState();
}

class _OrderStepTwoPackageDetailsScreenState
    extends State<OrderStepTwoPackageDetailsScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _detailsController = TextEditingController();

  String? _selectedSize = 'small';
  String? _selectedImagePath;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourcePicker() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(translate('camera')),
              onTap: () => context.pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: Text(translate('gallery')),
              onTap: () => context.pop(ImageSource.gallery),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );

    if (!mounted || source == null) return;

    final pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1600,
    );

    if (!mounted || pickedFile == null) return;
    setState(() => _selectedImagePath = pickedFile.path);
  }

  void _onContinue() {
    final isDetailsValid = _formKey.currentState?.validate() ?? false;
    if (!isDetailsValid) return;

    if (_selectedSize == null) {
      CustomSnackBar.showError(context, 'order_package_size_required');
      return;
    }

    final draft = OrderPackageDetailsDraft(
      details: _detailsController.text.trim(),
      packageSize: _selectedSize!,
      imagePath: _selectedImagePath,
    );

    context.push(OrderStepThreePickupDetailsScreen.routeName, extra: draft);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OrderStepTwoHeader(
              isDark: isDark,
              currentStep: 2,
              totalSteps: 4,
              title: translate('order_what_sending'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
                child: Column(
                  children: [
                    OrderStepTwoFormCard(
                      isDark: isDark,
                      selectedSize: _selectedSize,
                      detailsController: _detailsController,
                      formKey: _formKey,
                      imagePath: _selectedImagePath,
                      onSizeChanged: (size) =>
                          setState(() => _selectedSize = size),
                      onUploadTap: _showImageSourcePicker,
                      onContinueTap: _onContinue,
                    ),
                    SizedBox(height: 20.h),
                    const OrderStepTwoFooterNote(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
