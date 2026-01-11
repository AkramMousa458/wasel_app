// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/auth/data/repos/auth_repo_impl.dart';
import 'package:wasel/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:wasel/features/auth/presentation/widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login-screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(locator<AuthRepoImpl>()),
      child: const Scaffold(body: LoginScreenBody()),
    );
  }
}
