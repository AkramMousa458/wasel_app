// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:wasel/features/auth/presentation/widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login-screen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginScreenBody(),
    );
  }
}
