import 'package:flutter/material.dart';

/// Inter typography scale. Font files are bundled in assets/fonts so the brand
/// typeface renders identically offline and on every platform.
class AppTextStyles {
  static const String fontFamily = 'Inter';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily, fontSize: 36, height: 1.15, fontWeight: FontWeight.w600,
  );
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily, fontSize: 28, height: 1.2, fontWeight: FontWeight.w600,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily, fontSize: 22, height: 1.25, fontWeight: FontWeight.w600,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily, fontSize: 18, height: 1.3, fontWeight: FontWeight.w600,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily, fontSize: 16, height: 1.35, fontWeight: FontWeight.w600,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily, fontSize: 15, height: 1.5, fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily, fontSize: 14, height: 1.45, fontWeight: FontWeight.w400,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily, fontSize: 12, height: 1.45, fontWeight: FontWeight.w400,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily, fontSize: 14, height: 1.3, fontWeight: FontWeight.w600,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily, fontSize: 11, height: 1.3, fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
  );
  static const TextStyle numeric = TextStyle(
    fontFamily: fontFamily, fontSize: 26, height: 1.2, fontWeight: FontWeight.w600,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );
}
