import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodySmall,
        titleLarge: AppTextStyles.heading,
        titleMedium: AppTextStyles.subheading,
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
    );
  }
}