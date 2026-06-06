import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Chronicle app theme. Designed for dark mode first to match the Figma.
class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        surface: AppColors.background,
        primary: AppColors.gold,
        onPrimary: AppColors.textOnGold,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkRipple.splashFactory,
      textTheme: GoogleFonts.interTextTheme(
        base.textTheme,
      ).copyWith(bodyMedium: const TextStyle(color: AppColors.textPrimary)),
    );
  }
}
