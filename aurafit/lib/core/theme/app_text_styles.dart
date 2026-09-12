import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStylesExtension extends ThemeExtension<AppTextStylesExtension> {
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle h4;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle caption;
  final TextStyle button;
  final TextStyle buttonSmall;

  const AppTextStylesExtension({
    required this.displayLarge,
    required this.displayMedium,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.caption,
    required this.button,
    required this.buttonSmall,
  });

  @override
  ThemeExtension<AppTextStylesExtension> copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? caption,
    TextStyle? button,
    TextStyle? buttonSmall,
  }) {
    return AppTextStylesExtension(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      caption: caption ?? this.caption,
      button: button ?? this.button,
      buttonSmall: buttonSmall ?? this.buttonSmall,
    );
  }

  @override
  ThemeExtension<AppTextStylesExtension> lerp(
      covariant ThemeExtension<AppTextStylesExtension>? other, double t) {
    if (other is! AppTextStylesExtension) {
      return this;
    }
    return AppTextStylesExtension(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      h4: TextStyle.lerp(h4, other.h4, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      buttonSmall: TextStyle.lerp(buttonSmall, other.buttonSmall, t)!,
    );
  }

  factory AppTextStylesExtension.fromColors(AppColorsExtension colors) {
    return AppTextStylesExtension(
      displayLarge: GoogleFonts.syne(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: colors.textPrimary,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.syne(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -0.3,
      ),
      h1: GoogleFonts.syne(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -0.3,
      ),
      h2: GoogleFonts.syne(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -0.2,
      ),
      h3: GoogleFonts.syne(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      h4: GoogleFonts.syne(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.textPrimary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colors.textSecondary,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colors.textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: colors.textMuted,
        letterSpacing: 0.5,
      ),
      caption: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: colors.textMuted,
      ),
      button: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: colors.background,
        letterSpacing: 0.2,
      ),
      buttonSmall: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.background,
      ),
    );
  }
}

// Extension to easily access text styles from BuildContext
extension AppTextStylesExtensionHelper on BuildContext {
  AppTextStylesExtension get textStyles => Theme.of(this).extension<AppTextStylesExtension>()!;
}

/// Static alias that stays in sync with the current theme.
class AppTextStyles {
  static AppTextStylesExtension _current =
      AppTextStylesExtension.fromColors(AppColorsExtension.dark);

  static void update(bool isDarkMode) {
    final colors = isDarkMode ? AppColorsExtension.dark : AppColorsExtension.light;
    _current = AppTextStylesExtension.fromColors(colors);
  }

  static TextStyle get displayLarge => _current.displayLarge;
  static TextStyle get displayMedium => _current.displayMedium;
  static TextStyle get h1 => _current.h1;
  static TextStyle get h2 => _current.h2;
  static TextStyle get h3 => _current.h3;
  static TextStyle get h4 => _current.h4;
  static TextStyle get bodyLarge => _current.bodyLarge;
  static TextStyle get bodyMedium => _current.bodyMedium;
  static TextStyle get bodySmall => _current.bodySmall;
  static TextStyle get labelLarge => _current.labelLarge;
  static TextStyle get labelMedium => _current.labelMedium;
  static TextStyle get labelSmall => _current.labelSmall;
  static TextStyle get caption => _current.caption;
  static TextStyle get button => _current.button;
  static TextStyle get buttonSmall => _current.buttonSmall;
}
