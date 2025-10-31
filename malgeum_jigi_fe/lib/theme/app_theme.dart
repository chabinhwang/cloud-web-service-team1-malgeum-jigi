import 'package:flutter/material.dart';

class AppTheme {
  // ========== Light Mode Colors ==========
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

  // Material 3 Surface Colors (Light)
  static const Color surfaceColor = Colors.white;
  static const Color surfaceDim = Color(0xFFF7F7FB); // Figma Light Gray
  static const Color surfaceBright = Colors.white;

  // Neutral Colors (Light)
  static const Color backgroundColor = Color(0xFFF7F7FB); // Figma Background
  static const Color borderColor = Color(0xFFE5E5EF); // Figma Border
  static const Color borderColorLight = Color(0xFFE5E5EF); // Figma Border Light
  static const Color textPrimary = Color(0xFF1E1B39); // Figma Black
  static const Color textSecondary = Color(0xFF9291A5); // Figma Gray 400
  static const Color textTertiary = Color(0xFF615E83); // Figma Gray Text

  // ========== Dark Mode Colors ==========
  // Dark Mode - Deep Navy/Purple Theme
  static const Color darkPrimaryBlue = Color(0xFF6D5FFF); // Lighter purple for dark mode
  static const Color darkLightBlue = Color(0xFF2E2560); // Dark blue background
  static const Color darkAccentBlue = Color(0xFF5A4DFF); // Accent blue for dark mode
  static const Color darkActiveTabBackgroundColor = Color(0x6606B6D4); // Cyan color (60% transparent) for active tab background in dark mode

  // Dark Mode Status Colors
  static const Color darkGoodGreen = Color(0xFF26D926); // Lighter green for dark mode
  static const Color darkLightGreen = Color(0xFF1B4D1E); // Dark green background
  static const Color darkCautionYellow = Color(0xFFFFD700); // Brighter yellow for dark mode
  static const Color darkLightYellow = Color(0xFF332E00); // Dark yellow background
  static const Color darkBadRed = Color(0xFFFF9DB5); // Lighter red for dark mode
  static const Color darkLightRed = Color(0xFF4D1A2E); // Dark red background

  // Dark Mode Surface Colors
  static const Color darkSurfaceColor = Color(0xFF2A2354); // Slightly lighter purple for better contrast
  static const Color darkSurfaceDim = Color(0xFF33295F); // Slightly lighter navy
  static const Color darkSurfaceBright = Color(0xFF3A3370); // Lighter variant

  // Dark Mode Neutral Colors
  static const Color darkBackgroundColor = Color(0xFF1a1a3e); // Very deep navy background
  static const Color darkBorderColor = Color(0xFF3a3a66); // Navy border
  static const Color darkBorderColorLight = Color(0xFF4a4a7f); // Lighter navy border
  static const Color darkTextPrimary = Color(0xFFF0F0F0); // Light gray text
  static const Color darkTextSecondary = Color(0xFFA0A0C0); // Medium gray text
  static const Color darkTextTertiary = Color(0xFF8080A0); // Darker gray text

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

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkPrimaryBlue,
      primary: darkPrimaryBlue,
      secondary: darkAccentBlue,
      surface: darkSurfaceColor,
      surfaceDim: darkSurfaceDim,
      error: darkBadRed,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurfaceColor,
      foregroundColor: darkTextPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    // Material 3 Card Theme
    cardTheme: CardThemeData(
      color: darkSurfaceColor,
      elevation: 2,
      shadowColor: const Color(0x1A000000), // Dark shadow
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
        backgroundColor: darkPrimaryBlue,
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
        foregroundColor: darkPrimaryBlue,
        side: const BorderSide(color: darkPrimaryBlue, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkPrimaryBlue,
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
        color: darkTextPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: darkTextPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: darkTextPrimary,
      ),
      headlineLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: darkTextPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: darkTextPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkTextPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: darkTextPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: darkTextPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: darkTextSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkTextPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkTextSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: darkTextSecondary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurfaceColor,
      selectedItemColor: darkPrimaryBlue,
      unselectedItemColor: darkBackgroundColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  // ========== Dynamic Color Getters (for Dark Mode Support) ==========

  /// Secondary Text Color (다크 모드에서는 더 밝은 회색, 라이트 모드에서는 그레이)
  static Color getSecondaryTextColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextSecondary : textSecondary;
  }

  /// Location/Time Text Color
  static Color getLocationTimeTextColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextTertiary : (Colors.grey[600] ?? const Color(0xFF757575));
  }

  /// Reason/Description Text Color (더 진한 회색 대체)
  static Color getReasonTextColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextTertiary : (Colors.grey[700] ?? const Color(0xFF616161));
  }

  // ========== Sidebar & Navigation Bar Colors ==========

  /// Sidebar/Navigation Bar Background Color
  static Color getSidebarBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkSurfaceColor : Colors.white;
  }

  /// Sidebar/Navigation Bar Shadow Color
  static Color getSidebarShadowColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.1);
  }

  /// Sidebar/Navigation Bar Border/Divider Color
  static Color getSidebarBorderColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkBorderColor
        : (Colors.grey[200] ?? const Color(0xFFEEEEEE));
  }

  /// Active Tab/Item Background Color
  static Color getActiveTabBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkActiveTabBackgroundColor : lightBlue;
  }

  /// Inactive Icon/Text Color
  static Color getInactiveItemColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextSecondary : textSecondary;
  }

  /// Active Icon/Text Color (for selected menu items)
  static Color getActiveItemColor(Brightness brightness) {
    return brightness == Brightness.dark ? Colors.white : primaryBlue;
  }

  /// Unnecessary/Disabled Item Background Color
  static Color getUnnecessaryBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkSurfaceDim : Color(0xFFFAFAFA); // Colors.grey[50]
  }

  /// Unnecessary/Disabled Item Badge Background Color
  static Color getUnnecessaryBadgeBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkBorderColor : Color(0xFFEEEEEE); // Colors.grey[200]
  }

  /// Recommendation Item Text Color (needs better contrast)
  static Color getRecommendationTextColor(Brightness brightness) {
    return brightness == Brightness.dark ? const Color(0xFF2E2560) : getSecondaryTextColor(brightness);
  }

  /// Tab Content Background Color
  static Color getTabContentBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? const Color(0xFF0f0f2e) : Colors.white;
  }

  // ========== Air Quality Color Helpers ==========

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

  // ========== Activity Status Border & Background Colors ==========

  // Light Mode Activity Status Colors
  static const Color activityRecommendedBorder = Color(0xFFBBF7D0); // green-200
  static const Color activityOptimalBorder = Color(0xFF93C5FD);    // blue-300
  static const Color activityCautionBorder = Color(0xFFFDE68A);    // yellow-200
  static const Color activityProhibitedBorder = Color(0xFFFECACA); // red-200

  // Light Mode Activity Status Text Colors
  static const Color activityCautionText = Color(0xFFA16207); // yellow-700

  // Dark Mode Activity Status Border Colors
  static const Color darkActivityRecommendedBorder = Color(0xFF1B5E20); // dark-green-700
  static const Color darkActivityOptimalBorder = Color(0xFF0D47A1);     // dark-blue-800
  static const Color darkActivityCautionBorder = Color(0xFF4D3500);     // dark-yellow-800
  static const Color darkActivityProhibitedBorder = Color(0xFF5B1D1D);  // dark-red-800

  // Dark Mode Activity Status Text Colors
  static const Color darkActivityCautionText = Color(0xFFFFD700); // gold

  // ========== Special Background Colors ==========

  /// Tips Section Background Color (라이트 모드)
  static const Color tipsBackgroundColor = Color(0xFFFAF5FF);

  /// Tips Section Background Color (다크 모드)
  static const Color darkTipsBackgroundColor = Color(0xFF2A1F4D);

  /// Get activity border color based on status and brightness
  static Color getActivityBorderColor(String status, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (status) {
      case 'recommended':
        return isDark ? darkActivityRecommendedBorder : activityRecommendedBorder;
      case 'optimal':
        return isDark ? darkActivityOptimalBorder : activityOptimalBorder;
      case 'caution':
        return isDark ? darkActivityCautionBorder : activityCautionBorder;
      case 'prohibited':
        return isDark ? darkActivityProhibitedBorder : activityProhibitedBorder;
      default:
        return isDark ? darkActivityOptimalBorder : activityOptimalBorder;
    }
  }

  /// Get activity text color for caution status
  static Color getActivityCautionTextColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkActivityCautionText : activityCautionText;
  }
}
