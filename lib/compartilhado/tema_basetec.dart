// lib/compartilhado/tema_basetec.dart
import 'package:flutter/material.dart';

class TemaBaseTec { // <-- Verifique se este nome está correto
  static const Color azulPrincipal = Color(0xFF0D47A1);
  static const Color fundoCinza = Color(0xFFF5F5F5);

  static ThemeData get temaClaro {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: azulPrincipal,
      scaffoldBackgroundColor: fundoCinza,
      appBarTheme: const AppBarTheme(
        backgroundColor: azulPrincipal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }
}
