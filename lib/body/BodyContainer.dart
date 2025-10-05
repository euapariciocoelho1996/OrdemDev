import 'package:flutter/material.dart';

class BodyContainer extends StatelessWidget {
  final Widget child;
  const BodyContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
      ),
      child: SafeArea(child: child),
    );
  }
}
