import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors (Figma Design)
  static const Color primaryBlue = Color(0xFF4A3AFF); // Figma Purple
  static const Color lightBlue = Color(0xFFE5EAFC); // Figma Light Blue
  static const Color accentBlue = Color(0xFF2D5BFF); // Figma Blue 400

  // Status Colors
  static const Color goodGreen = Color(0xFF04CE00); // Figma Green 400
  static const Color lightGreen = Color(0xFFE1F6E3); // Figma Green 100
  static const Color cautionYellow = Color(0xFFEAB308); // yellow-500
  static const Color lightYellow = Color(0xFFFEFCE8); // yellow-50
  static const Color badRed = Color(0xFFFF718B); // Figma Red 400
  static const Color lightRed = Color(0xFFFCB5C3); // Figma Red 300

  // Material 3 Surface Colors
  static const Color surfaceColor = Colors.white;
  static const Color surfaceDim = Color(0xFFF7F7FB); // Figma Light Gray
  static const Color surfaceBright = Colors.white;

  // Neutral Colors
  static const Color backgroundColor = Color(0xFFF7F7FB); // Figma Background
  static const Color borderColor = Color(0xFFE5E5EF); // Figma Border
  static const Color borderColorLight = Color(0xFFE5E5EF); // Figma Border Light
  static const Color textPrimary = Color(0xFF1E1B39); // Figma Black
  static const Color textSecondary = Color(0xFF9291A5); // Figma Gray 400
  static const Color textTertiary = Color(0xFF615E83); // Figma Gray Text

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
      elevation: 2,
      shadowColor: const Color(0x140D0A2C), // Figma shadow: rgba(13,10,44,0.08)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
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
