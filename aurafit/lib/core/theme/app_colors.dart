// AuraFit Color System — matching Figma design
import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0D0F17);
  static const Color backgroundAlt = Color(0xFF121520);
  static const Color surface = Color(0xFF1E2235);
  static const Color surfaceAlt = Color(0xFF181B2A);
  static const Color border = Color(0xFF2E354F);
  static const Color borderLight = Color(0xFF3D4666);

  // Primary — Neon Cyan
  static const Color primary = Color(0xFF00F0FF);
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color primaryDark = Color(0xFF0099BB);

  // Secondary — Electric Purple
  static const Color secondary = Color(0xFFA855F7);
  static const Color secondaryDark = Color(0xFF7C3AED);

  // Accent — Lime Green
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentGreenDark = Color(0xFF10B981);

  // Accent — Coral / Orange
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentRed = Color(0xFFEF4444);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F0FF), Color(0xFF0099BB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanPurpleGradient = LinearGradient(
    colors: [Color(0xFF00F0FF), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkSurfaceGradient = LinearGradient(
    colors: [Color(0xFF1E2235), Color(0xFF181B2A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient chatAiGradient = LinearGradient(
    colors: [Color(0xFF0099BB), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
