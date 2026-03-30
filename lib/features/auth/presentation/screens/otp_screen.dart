import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:wasel/features/auth/presentation/manager/otp_cubit/otp_cubit.dart';
import 'package:wasel/features/auth/presentation/widgets/otp_screen_body.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.phone, required this.authCubit});

  static const String routeName = '/otp-screen';

  final String phone;
  final AuthCubit authCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: OtpScreenBody(phone: phone, authCubit: authCubit),
      ),
    );
  }
}
