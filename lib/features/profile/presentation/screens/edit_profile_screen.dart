import 'package:flutter/material.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/theme_utils.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/profile/presentation/widgets/edit_profile_body.dart';

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/edit-profile';
  final UserModel? user;

  const EditProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkScaffold
          : AppColors.lightScaffold,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: BackButton(color: isDark ? Colors.white : Colors.black),
      //   title: Text(
      //     'Edit Profile', // TODO: Translate
      //     style: TextStyle(
      //       color: isDark ? Colors.white : Colors.black,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      body: EditProfileBody(user: user),
    );
  }
}
