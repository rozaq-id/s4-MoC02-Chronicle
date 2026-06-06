import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens aligned with the Chronicle design.
/// - Headings: Libre Caslon Text (display serif)
/// - Body / UI: Inter (sans-serif)
class AppTextStyles {
  AppTextStyles._();

  static TextStyle display({FontWeight weight = FontWeight.bold}) =>
      GoogleFonts.libreCaslonText(fontWeight: weight);

  static TextStyle ui({FontWeight weight = FontWeight.normal}) =>
      GoogleFonts.inter(fontWeight: weight);

  // Common presets
  static final TextStyle yearBadge = display(weight: FontWeight.bold).copyWith(
    fontSize: 48,
    color: const Color(0xFFF0A500),
    letterSpacing: -0.96,
  );

  static final TextStyle h1 = display(
    weight: FontWeight.bold,
  ).copyWith(fontSize: 28, color: const Color(0xFFEDE1D0), height: 36 / 28);

  static final TextStyle h2 = display(
    weight: FontWeight.bold,
  ).copyWith(fontSize: 28, color: const Color(0xFFEDE1D0), height: 36 / 28);

  static final TextStyle h3 = display().copyWith(
    fontSize: 24,
    color: const Color(0xFFFFE2AB),
    height: 32 / 24,
  );

  static final TextStyle body = ui().copyWith(
    fontSize: 18,
    color: const Color(0xFFEDE1D0),
    height: 29.25 / 18,
  );

  static final TextStyle label = ui(
    weight: FontWeight.w600,
  ).copyWith(fontSize: 14, color: const Color(0xFFEDE1D0), letterSpacing: 0.7);

  static final TextStyle button = ui(
    weight: FontWeight.bold,
  ).copyWith(fontSize: 14, letterSpacing: 0.7);

  static final TextStyle caption = ui(
    weight: FontWeight.w500,
  ).copyWith(fontSize: 12, color: const Color(0xFFD4C5AB));

  static final TextStyle placeholder = ui().copyWith(
    fontSize: 16,
    color: const Color(0xFF6B7280),
  );
}
