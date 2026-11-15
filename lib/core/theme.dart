import 'package:flutter/material.dart';

class AppColors {
  static const Color navy = Color(0xFF0B1F3A);
  static const Color navyLight = Color(0xFF16345C);
  static const Color teal = Color(0xFF14B8A6);
  static const Color surface = Color(0xFFF4F7FA);
  static const Color textMuted = Color(0xFF5B6B7F);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.teal,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.navy,
    secondary: AppColors.teal,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.navy,
      foregroundColor: Colors.white,
    ),
  );
}
