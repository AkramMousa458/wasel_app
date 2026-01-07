import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel/features/app/presentation/components/app_gate.dart';
import 'package:wasel/features/app/presentation/manager/app_cubit.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..checkAuth(),
      child: AppGate(child: child),
    );
  }
}
