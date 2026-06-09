import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemeLight {

  static ThemeData theme = ThemeData.light().copyWith(

    scaffoldBackgroundColor:
        AppColors.fundoLight,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cardLight,
      elevation: 0,
    ),

    cardColor: AppColors.cardLight,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaria,
    ),
  );
}