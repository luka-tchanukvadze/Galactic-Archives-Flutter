import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.gold,
        secondary: AppColors.cyan,
        surface: AppColors.panel,
        error: AppColors.red,
      ),
      textTheme: GoogleFonts.shareTechMonoTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textLight,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.panel,
        foregroundColor: AppColors.gold,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  // Orbitron style used for big titles.
  static TextStyle title(double size, {Color color = AppColors.gold}) {
    return GoogleFonts.orbitron(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: 2,
    );
  }
}
