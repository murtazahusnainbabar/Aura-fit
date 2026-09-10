import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;

  const AppLogo({
    super.key,
    this.size = 72,
    this.showWordmark = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: colors.cyanPurpleGradient,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        Icons.bolt_rounded,
        color: Colors.white,
        size: size * 0.52,
      ),
    );

    if (!showWordmark) return mark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(height: 16),
        Text(
          'AuraFit',
          style: TextStyle(
            fontSize: size * 0.38,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
