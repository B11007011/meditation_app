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