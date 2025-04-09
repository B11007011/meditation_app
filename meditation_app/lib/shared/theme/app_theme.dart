import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF8E97FD);
  static const Color textPrimary = Color(0xFF3F414E);
  static const Color textSecondary = Color(0xFFA1A4B2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAF8F5);
  static const Color accent = Color(0xFF7680FC);
  static const Color black = Color(0xFF000000);
  
  // Welcome screen colors
  static const Color welcomeYellow = Color(0xFFFFECCC);
  static const Color welcomeLight = Color(0xFFEBEAEC);
  static const Color welcomePurpleLight = Color(0xFFB4BAFF);
  static const Color welcomePurpleMedium = Color(0xFF9EA6FF);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'HelveticaNeue',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: 'HelveticaNeue',
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.65,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'HelveticaNeue',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.05,
    height: 1.08,
  );

  static const TextStyle logo = TextStyle(
    fontFamily: 'Airbnb Cereal App',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.24,
    height: 1.302,
    color: AppColors.textPrimary,
  );
}

class AppTheme {
  static const Color primaryColor = Color(0xFF8E97FD);
  static const Color secondaryColor = Color(0xFF3F414E);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Color(0xFF3F414E);
  static const Color subtitleColor = Color(0xFFA1A4B2);
  static const Color errorColor = Colors.red;

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
} 