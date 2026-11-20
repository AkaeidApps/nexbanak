import 'package:flutter/material.dart';

/// Exact NEXBANK corporate palette from the brand specification.
class AppColors {
  static const Color primaryNavy = Color(0xFF0B1F3A);
  static const Color secondaryBlue = Color(0xFF1D4ED8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF1F5F9);
  static const Color success = Color(0xFF059669);
  static const Color error = Color(0xFFDC2626);
  static const Color gold = Color(0xFFC9A227);

  static const Color darkNavy = Color(0xFF071629);
  static const Color lightBlue = Color(0xFFEFF6FF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF172033);
  static const Color textSecondary = Color(0xFF64748B);

  // Dark theme surfaces
  static const Color darkSurface = Color(0xFF0F2139);
  static const Color darkSurfaceAlt = Color(0xFF142941);
  static const Color darkBackground = Color(0xFF071629);
  static const Color darkBorder = Color(0xFF24405F);
  static const Color darkText = Color(0xFFE8EEF7);
  static const Color darkTextSecondary = Color(0xFF9AAFC8);

  static const Color warning = Color(0xFFD95706);
  static const Color info = Color(0xFF0284C7);

  static Color surface(bool isDark) => isDark ? darkSurface : white;
  static Color canvas(bool isDark) => isDark ? darkBackground : background;
  static Color outline(bool isDark) => isDark ? darkBorder : border;
  static Color bodyText(bool isDark) => isDark ? darkText : textPrimary;
  static Color mutedText(bool isDark) => isDark ? darkTextSecondary : textSecondary;
}
