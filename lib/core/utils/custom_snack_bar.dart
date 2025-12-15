// Function to display a SnackBar message

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showSnackBar(BuildContext context, String text, bool status) {
  if (status == true) {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: translate(text),
        backgroundColor: AppColors.primary,
        textStyle: AppStyles.textstyle14Bold.copyWith(color: Colors.white),
      ),
    );
  } else {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: translate(text)),
    );
  }
}
