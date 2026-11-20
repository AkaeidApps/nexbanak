import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        scaffold: AppColors.background,
        surface: AppColors.white,
        text: AppColors.textPrimary,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scaffold: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        text: AppColors.darkText,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color scaffold,
    required Color surface,
    required Color text,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.secondaryBlue,
      primary: AppColors.primaryNavy,
      onPrimary: AppColors.white,
      secondary: AppColors.secondaryBlue,
      onSecondary: AppColors.white,
      surface: surface,
      onSurface: text,
      error: AppColors.error,
      onError: AppColors.white,
      brightness: brightness,
    ).copyWith(
      primaryContainer: isDark ? AppColors.darkSurfaceAlt : AppColors.lightBlue,
      onPrimaryContainer: isDark ? AppColors.darkText : AppColors.primaryNavy,
      secondaryContainer: isDark ? AppColors.darkSurfaceAlt : AppColors.lightBlue,
      outline: AppColors.outline(isDark),
    );

    final TextTheme base = Typography.material2021().black.apply(
          bodyColor: text,
          displayColor: text,
          fontFamily: AppTextStyles.fontFamily,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      fontFamily: AppTextStyles.fontFamily,
      textTheme: base.copyWith(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: text),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: text),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: text),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: text),
        titleLarge: AppTextStyles.headlineSmall.copyWith(color: text),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: text),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: text),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: text),
        bodySmall: AppTextStyles.bodySmall
            .copyWith(color: AppColors.mutedText(isDark)),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: text),
        labelSmall: AppTextStyles.labelSmall
            .copyWith(color: AppColors.mutedText(isDark)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(color: text),
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.outline(isDark)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.outline(isDark),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryNavy,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceAlt : AppColors.lightBlue,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.outline(isDark)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.outline(isDark)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: TextStyle(color: AppColors.mutedText(isDark)),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: scaffold,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.secondaryBlue,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: AppColors.lightBlue,
        labelTextStyle: WidgetStateProperty.all(AppTextStyles.labelSmall),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.outline(isDark),
        space: 1,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: AppColors.outline(isDark)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
