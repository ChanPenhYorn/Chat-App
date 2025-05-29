import 'package:flutter/material.dart';
import 'app_colors.dart'; // Import your AppColors class

class AppThemes {
  // Define a custom light theme.
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: _lightColorScheme, // Use the light color scheme
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: _getTextTheme(false),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryLight,
      titleTextStyle: TextStyle(
          color: AppColors.onPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    ),
  );

  // Define a custom dark theme.
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme, // Use the dark color scheme
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: _getTextTheme(true),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      titleTextStyle: TextStyle(
          color: AppColors.onPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    ),
  );

  // Define the ColorScheme for the light theme.
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryLight,
    onPrimary: AppColors.onPrimaryLight,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.onPrimaryLight,
    error: AppColors.errorLight,
    onError: AppColors.onErrorLight,
    // ignore: deprecated_member_use
    background: AppColors.backgroundLight,
    // ignore: deprecated_member_use
    onBackground: AppColors.onBackgroundLight,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.onSurfaceLight,
  );

  // Define the ColorScheme for the dark theme.
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.onPrimaryDark,
    secondary: AppColors.secondaryDark,
    onSecondary: AppColors.onPrimaryDark,
    error: AppColors.errorDark,
    onError: AppColors.onErrorDark,
    // ignore: deprecated_member_use
    background: AppColors.backgroundDark,
    // ignore: deprecated_member_use
    onBackground: AppColors.onBackgroundDark,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.onSurfaceDark,
  );

  static TextTheme _getTextTheme(bool isDark) {
    double fontSize = 16;
    final color = isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight;
    return TextTheme(
      displayLarge: TextStyle(fontSize: fontSize + 41, color: color),
      displayMedium: TextStyle(fontSize: fontSize + 29, color: color),
      displaySmall: TextStyle(fontSize: fontSize + 20, color: color),
      headlineLarge: TextStyle(fontSize: fontSize + 16, color: color),
      headlineMedium: TextStyle(fontSize: fontSize + 12, color: color),
      headlineSmall: TextStyle(fontSize: fontSize + 8, color: color),
      titleLarge: TextStyle(fontSize: fontSize + 6, color: color),
      titleMedium: TextStyle(fontSize: fontSize, color: color),
      titleSmall: TextStyle(fontSize: fontSize - 2, color: color),
      bodyLarge: TextStyle(fontSize: fontSize, color: color),
      bodyMedium: TextStyle(fontSize: fontSize - 2, color: color),
      bodySmall: TextStyle(fontSize: fontSize - 4, color: color),
      labelLarge: TextStyle(fontSize: fontSize - 2, color: color),
      labelMedium: TextStyle(fontSize: fontSize - 4, color: color),
      labelSmall: TextStyle(fontSize: fontSize - 5, color: color),
    );
  }
}
