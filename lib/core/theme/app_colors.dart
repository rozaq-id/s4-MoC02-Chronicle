import 'package:flutter/material.dart';

/// Color tokens extracted from the Chronicle Figma design.
/// All hex values are taken directly from the design specs.
class AppColors {
  AppColors._();

  // Surfaces / backgrounds
  static const Color background = Color(0xFF181309); // main dark canvas
  static const Color surfaceDark = Color(0xFF181309); // login bg
  static const Color cardDark = Color(0xFF241F14); // main card
  static const Color cardAlt = Color(0xFF201B11); // related card
  static const Color customSurface = Color(0xFF1C2128); // stitch custom-surface
  static const Color inputBg = Color(0xFF2F291E);
  static const Color border = Color(0xFF504532);
  static const Color customBorder = Color(0xFF30363D); // stitch custom-border
  static const Color borderAlpha = Color(0x4D504532); // rgba(80,69,50,0.3)

  // Text
  static const Color textPrimary = Color(0xFFEDE1D0);
  static const Color textSecondary = Color(0xFFD4C5AB);
  static const Color onSurfaceVariant = Color(
    0xFFB5B0A1,
  ); // stitch on-surface-variant
  static const Color textAccent = Color(0xFFFFE2AB);
  static const Color textOnGold = Color(0xFF402D00);
  static const Color placeholder = Color(0xFF6B7280);

  // Brand
  static const Color gold = Color(0xFFFFBF00); // primary action
  static const Color goldDeep = Color(0xFFFFBF00); // year badge / outline

  // Semantic overlays
  static Color frostedOverlay = const Color(0x80241F14); // backdrop blur tint
}
