import 'package:flutter/material.dart';

class AppCores {
  // --- Cores da Marca ---
  static const Color primaria = Color(0xFF1565C0); 
  static const Color secundaria = Color(0xFF263238);
  
  // --- Cores de Status (O.S) ---
  static const Color pendente = Colors.orange;
  static const Color emAndamento = Colors.blue;
  static const Color concluido = Colors.green;
  static const Color cancelado = Colors.red;
  static const Color ausente = Colors.purple;
  
  // --- Cores de UI (Tema Claro) ---
  static const Color fundo = Color(0xFFF5F5F5);
  static const Color textoPrincipal = Color(0xFF212121);
  static const Color textoSecundario = Colors.grey;

  // --- Cores de UI (Tema Dark / Login) - ADICIONADAS PARA CORRIGIR O ERRO ---
  static const Color fundoEscuro = Color(0xFF03070C);
  static const Color cardEscuro = Color(0xFF0D121D);
  static const Color bordaEscura = Colors.white10;
  static const Color textoBranco = Colors.white;
  static const Color textoCinza = Colors.white60;
}
