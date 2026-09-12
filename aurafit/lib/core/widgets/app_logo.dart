import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      // Fallback if image not found during development
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.directions_run_rounded,
          size: size,
          color: const Color(0xFFC6FF00),
        );
      },
    );
  }
}
