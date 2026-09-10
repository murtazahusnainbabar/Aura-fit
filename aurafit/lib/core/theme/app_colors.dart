import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color background;
  final Color backgroundAlt;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color borderLight;
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryDark;
  final Color accentGreen;
  final Color accentGreenDark;
  final Color accentOrange;
  final Color accentRed;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;
  
  final LinearGradient primaryGradient;
  final LinearGradient purpleGradient;
  final LinearGradient cyanPurpleGradient;
  final LinearGradient greenGradient;
  final LinearGradient orangeGradient;
  final LinearGradient surfaceGradient;
  final LinearGradient chatAiGradient;

  const AppColorsExtension({
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.borderLight,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryDark,
    required this.accentGreen,
    required this.accentGreenDark,
    required this.accentOrange,
    required this.accentRed,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.primaryGradient,
    required this.purpleGradient,
    required this.cyanPurpleGradient,
    required this.greenGradient,
    required this.orangeGradient,
    required this.surfaceGradient,
    required this.chatAiGradient,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? background,
    Color? backgroundAlt,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? borderLight,
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? secondary,
    Color? secondaryDark,
    Color? accentGreen,
    Color? accentGreenDark,
    Color? accentOrange,
    Color? accentRed,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textDisabled,
    LinearGradient? primaryGradient,
    LinearGradient? purpleGradient,
    LinearGradient? cyanPurpleGradient,
    LinearGradient? greenGradient,
    LinearGradient? orangeGradient,
    LinearGradient? surfaceGradient,
    LinearGradient? chatAiGradient,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      backgroundAlt: backgroundAlt ?? this.backgroundAlt,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      secondary: secondary ?? this.secondary,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      accentGreen: accentGreen ?? this.accentGreen,
      accentGreenDark: accentGreenDark ?? this.accentGreenDark,
      accentOrange: accentOrange ?? this.accentOrange,
      accentRed: accentRed ?? this.accentRed,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      purpleGradient: purpleGradient ?? this.purpleGradient,
      cyanPurpleGradient: cyanPurpleGradient ?? this.cyanPurpleGradient,
      greenGradient: greenGradient ?? this.greenGradient,
      orangeGradient: orangeGradient ?? this.orangeGradient,
      surfaceGradient: surfaceGradient ?? this.surfaceGradient,
      chatAiGradient: chatAiGradient ?? this.chatAiGradient,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
      covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      backgroundAlt: Color.lerp(backgroundAlt, other.backgroundAlt, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryDark: Color.lerp(secondaryDark, other.secondaryDark, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      accentGreenDark: Color.lerp(accentGreenDark, other.accentGreenDark, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      accentRed: Color.lerp(accentRed, other.accentRed, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      purpleGradient: LinearGradient.lerp(purpleGradient, other.purpleGradient, t)!,
      cyanPurpleGradient: LinearGradient.lerp(cyanPurpleGradient, other.cyanPurpleGradient, t)!,
      greenGradient: LinearGradient.lerp(greenGradient, other.greenGradient, t)!,
      orangeGradient: LinearGradient.lerp(orangeGradient, other.orangeGradient, t)!,
      surfaceGradient: LinearGradient.lerp(surfaceGradient, other.surfaceGradient, t)!,
      chatAiGradient: LinearGradient.lerp(chatAiGradient, other.chatAiGradient, t)!,
    );
  }

  // --- Dark Theme Palette ---
  static const dark = AppColorsExtension(
    background: Color(0xFF0D0F17),
    backgroundAlt: Color(0xFF121520),
    surface: Color(0xFF1E2235),
    surfaceAlt: Color(0xFF181B2A),
    border: Color(0xFF2E354F),
    borderLight: Color(0xFF3D4666),
    primary: Color(0xFF00F0FF),
    primaryLight: Color(0xFF38BDF8),
    primaryDark: Color(0xFF0099BB),
    secondary: Color(0xFFA855F7),
    secondaryDark: Color(0xFF7C3AED),
    accentGreen: Color(0xFF22C55E),
    accentGreenDark: Color(0xFF10B981),
    accentOrange: Color(0xFFF97316),
    accentRed: Color(0xFFEF4444),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    textDisabled: Color(0xFF475569),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF00F0FF), Color(0xFF0099BB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    purpleGradient: LinearGradient(
      colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cyanPurpleGradient: LinearGradient(
      colors: [Color(0xFF00F0FF), Color(0xFFA855F7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    greenGradient: LinearGradient(
      colors: [Color(0xFF22C55E), Color(0xFF10B981)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    orangeGradient: LinearGradient(
      colors: [Color(0xFFF97316), Color(0xFFEF4444)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    surfaceGradient: LinearGradient(
      colors: [Color(0xFF1E2235), Color(0xFF181B2A)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    chatAiGradient: LinearGradient(
      colors: [Color(0xFF0099BB), Color(0xFF7C3AED)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  // --- Light Theme Palette ---
  static const light = AppColorsExtension(
    background: Color(0xFFF8FAFC), // Slate 50
    backgroundAlt: Color(0xFFF1F5F9), // Slate 100
    surface: Color(0xFFFFFFFF), // White
    surfaceAlt: Color(0xFFF8FAFC),
    border: Color(0xFFE2E8F0), // Slate 200
    borderLight: Color(0xFFCBD5E1), // Slate 300
    primary: Color(0xFF0EA5E9), // Sky 500
    primaryLight: Color(0xFF38BDF8), // Sky 400
    primaryDark: Color(0xFF0284C7), // Sky 600
    secondary: Color(0xFF8B5CF6), // Violet 500
    secondaryDark: Color(0xFF6D28D9), // Violet 700
    accentGreen: Color(0xFF10B981), // Emerald 500
    accentGreenDark: Color(0xFF059669), // Emerald 600
    accentOrange: Color(0xFFF97316),
    accentRed: Color(0xFFEF4444),
    textPrimary: Color(0xFF0F172A), // Slate 900
    textSecondary: Color(0xFF64748B), // Slate 500
    textMuted: Color(0xFF94A3B8), // Slate 400
    textDisabled: Color(0xFFCBD5E1), // Slate 300
    primaryGradient: LinearGradient(
      colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    purpleGradient: LinearGradient(
      colors: [Color(0xFFA855F7), Color(0xFF6D28D9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cyanPurpleGradient: LinearGradient(
      colors: [Color(0xFF0EA5E9), Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    greenGradient: LinearGradient(
      colors: [Color(0xFF34D399), Color(0xFF059669)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    orangeGradient: LinearGradient(
      colors: [Color(0xFFFB923C), Color(0xFFEA580C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    surfaceGradient: LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    chatAiGradient: LinearGradient(
      colors: [Color(0xFF0EA5E9), Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

// Extension to easily access colors from BuildContext
extension AppColorsExtensionHelper on BuildContext {
  AppColorsExtension get colors => Theme.of(this).extension<AppColorsExtension>()!;
}

/// Static dark-palette alias for screens that still use `AppColors.*` in const widgets.
class AppColors {
  static void update(bool isDarkMode) {
    // Theme-aware colors live on ThemeExtension / context.colors.
  }

  static const Color background = Color(0xFF0D0F17);
  static const Color backgroundAlt = Color(0xFF121520);
  static const Color surface = Color(0xFF1E2235);
  static const Color surfaceAlt = Color(0xFF181B2A);
  static const Color border = Color(0xFF2E354F);
  static const Color borderLight = Color(0xFF3D4666);
  static const Color primary = Color(0xFF00F0FF);
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color primaryDark = Color(0xFF0099BB);
  static const Color secondary = Color(0xFFA855F7);
  static const Color secondaryDark = Color(0xFF7C3AED);
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentGreenDark = Color(0xFF10B981);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);
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
  static const LinearGradient surfaceGradient = LinearGradient(
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
