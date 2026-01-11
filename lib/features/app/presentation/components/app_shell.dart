import 'package:flutter/material.dart';
import 'package:wasel/features/app/presentation/components/app_gate.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppGate(child: child);
  }
}
