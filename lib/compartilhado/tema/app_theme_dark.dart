import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemeDark {

  static ThemeData theme = ThemeData.dark().copyWith(

    scaffoldBackgroundColor:
        AppColors.fundoDark,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cardDark,
      elevation: 0,
    ),

    cardColor: AppColors.cardDark,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaria,
    ),

    inputDecorationTheme: InputDecorationTheme(

      filled: true,
      fillColor: AppColors.cardDark,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.bordaDark,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.primaria,
          width: 1.5,
        ),
      ),

      labelStyle: const TextStyle(
        color: AppColors.cinza,
      ),
    ),
  );
}