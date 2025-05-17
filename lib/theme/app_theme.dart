import 'package:flutter/material.dart';

class AppTheme {
  // Primary color palette
  static const Color primaryColor = Color(0xFFE65100); // Deep Orange
  static const Color secondaryColor = Color(0xFFFFA000); // Amber
  static const Color accentColor = Color(0xFF8D6E63); // Brown
  static const Color backgroundColor = Color(0xFFFAF7F2); // Soft Off-White
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF3E2723); // Dark Brown
  static const Color textSecondaryColor = Color(0xFF5D4037); // Medium Brown

  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'NotoSerifKannada',
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    fontSize: 24,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontFamily: 'NotoSerifKannada',
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    fontSize: 20,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'NotoSerifKannada',
    color: textSecondaryColor,
    fontSize: 16,
  );

  static const TextStyle kannadaLetterStyle = TextStyle(
    fontFamily: 'NotoSerifKannada',
    fontWeight: FontWeight.bold,
    color: primaryColor,
    fontSize: 96,
  );

  // Card decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Button style
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );

  // Theme data
  static ThemeData getThemeData() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSerifKannada',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor, 
        background: backgroundColor,
        surface: cardColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headingStyle,
      ),
      textTheme: const TextTheme(
        displayLarge: kannadaLetterStyle,
        titleLarge: headingStyle,
        titleMedium: subheadingStyle,
        bodyLarge: TextStyle(fontSize: 18, color: textSecondaryColor),
        bodyMedium: bodyStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButtonStyle,
      ),
      iconTheme: const IconThemeData(
        color: primaryColor,
        size: 24,
      ),
    );
  }
}