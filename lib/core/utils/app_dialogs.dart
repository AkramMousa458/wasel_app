import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/features/app/presentation/manager/app_cubit.dart';

class AppDialogs {
  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate('confirm_logout')),
        content: Text(translate('logout_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              context.read<AppCubit>().logout();
            },
            child: Text(
              translate('log_out'),
              style: TextStyle(color: AppColors.error500),
            ),
          ),
        ],
      ),
    );
  }
}
