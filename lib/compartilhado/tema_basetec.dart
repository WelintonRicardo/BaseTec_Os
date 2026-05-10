// lib/compartilhado/tema_basetec.dart
import 'package:flutter/material.dart';
import 'tema_cores.dart'; 

class TemaBaseTec {
  static ThemeData get temaClaro {
    return ThemeData(
      useMaterial3: true,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppCores.primaria,
        primary: AppCores.primaria,
        secondary: AppCores.secundaria,
      ),

      scaffoldBackgroundColor: AppCores.fundo,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppCores.primaria,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),

      // CORREÇÃO AQUI: Usamos CardThemeData em vez de CardTheme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.primaria,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
