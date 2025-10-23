import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors (Material 3)
  static const Color primaryBlue = Color(0xFF2563EB); // blue-600
  static const Color lightBlue = Color(0xFFEFF6FF); // blue-50
  static const Color accentBlue = Color(0xFF3B82F6); // blue-500

  // Status Colors
  static const Color goodGreen = Color(0xFF22C55E); // green-600
  static const Color lightGreen = Color(0xFFF0FDF4); // green-50
  static const Color cautionYellow = Color(0xFFEAB308); // yellow-500
  static const Color lightYellow = Color(0xFFFEFCE8); // yellow-50
  static const Color badRed = Color(0xFFEF4444); // red-500
  static const Color lightRed = Color(0xFFFEF2F2); // red-50

  // Material 3 Surface Colors
  static const Color surfaceColor = Colors.white;
  static const Color surfaceDim = Color(0xFFF5F5F5); // gray-100
  static const Color surfaceBright = Colors.white;

  // Neutral Colors
  static const Color backgroundColor = Color(0xFFF9FAFB); // gray-50
  static const Color borderColor = Color(0xFFE5E7EB); // gray-200
  static const Color borderColorLight = Color(0xFFF3F4F6); // gray-100
  static const Color textPrimary = Color(0xFF111827); // gray-900
  static const Color textSecondary = Color(0xFF6B7280); // gray-600
  static const Color textTertiary = Color(0xFF9CA3AF); // gray-400

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: accentBlue,
      surface: surfaceColor,
      surfaceDim: surfaceDim,
      error: badRed,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    // Material 3 Card Theme
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: borderColorLight,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
    ),
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: const BorderSide(color: primaryBlue, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 96,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryBlue,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  // Helper method to get color based on air quality score
  static Color getScoreColor(int score) {
    if (score >= 70) return goodGreen;
    if (score >= 40) return cautionYellow;
    return badRed;
  }

  // Helper method to get background color based on air quality score
  static Color getScoreBackgroundColor(int score) {
    if (score >= 70) return lightGreen;
    if (score >= 40) return lightYellow;
    return lightRed;
  }

  // Helper method to get PM status color
  static Color getPMColor(double pm10Value) {
    if (pm10Value <= 30) return goodGreen; // 좋음
    if (pm10Value <= 80) return accentBlue; // 보통
    if (pm10Value <= 150) return cautionYellow; // 나쁨
    return badRed; // 매우나쁨
  }
}
