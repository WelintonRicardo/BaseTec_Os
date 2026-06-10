import 'package:flutter/material.dart';

class AppCores {
  // =========================================================
  // IDENTIDADE VISUAL PRINCIPAL
  // =========================================================

  static const Color primaria = Color(0xFF3B82F6);
  static const Color secundaria = Color(0xFF8B5CF6);

  // =========================================================
  // BACKGROUND / SUPERFÍCIES
  // =========================================================

  static const Color fundo = Color(0xFFF5F7FA);

  // Fundo principal dark premium
  static const Color fundoEscuro = Color(0xFF050816);

  // Cards
  static const Color cardEscuro = Color(0xFF0F172A);

  // Containers internos
  static const Color superficie = Color(0xFF111827);

  // AppBar / Sidebar
  static const Color navbar = Color(0xFF0B1120);

  // =========================================================
  // BORDAS / GLASS
  // =========================================================

  static const Color bordaEscura = Color(0x1FFFFFFF);

  static const Color glass = Color(0x0DFFFFFF);

  static const Color sombra = Color(0x66000000);

  // =========================================================
  // TEXTOS
  // =========================================================

  static const Color textoPrincipal = Color(0xFFF8FAFC);

  static const Color textoSecundario = Color(0xFF94A3B8);

  static const Color textoCinza = Color(0xFF64748B);

  static const Color textoBranco = Colors.white;

  // =========================================================
  // CORES FINANCEIRAS
  // =========================================================

  static const Color receita = Color(0xFF22C55E);

  static const Color despesa = Color(0xFFFF5C5C);

  static const Color lucro = Color(0xFF4ADE80);

  static const Color alerta = Color(0xFFF59E0B);

  // =========================================================
  // CORES DOS GRÁFICOS
  // =========================================================

  static const Color graficoAzul = Color(0xFF38BDF8);

  static const Color graficoRoxo = Color(0xFFA855F7);

  static const Color graficoVerde = Color(0xFF4ADE80);

  static const Color graficoLaranja = Color(0xFFFFA726);

  static const Color graficoRosa = Color(0xFFEC4899);

  // =========================================================
  // STATUS O.S
  // =========================================================

  static const Color pendente = Color(0xFFF59E0B);

  static const Color emAndamento = Color(0xFF3B82F6);

  static const Color concluido = Color(0xFF22C55E);

  static const Color cancelado = Color(0xFFEF4444);

  static const Color ausente = Color(0xFFA855F7);

  // =========================================================
  // GRADIENTES PREMIUM
  // =========================================================

  static const LinearGradient gradienteFundo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF050816),
      Color(0xFF0F172A),
      Color(0xFF111827),
    ],
  );

  static const LinearGradient gradienteReceita = LinearGradient(
    colors: [
      Color(0xFF16A34A),
      Color(0xFF22C55E),
    ],
  );

  static const LinearGradient gradienteDespesa = LinearGradient(
    colors: [
      Color(0xFFDC2626),
      Color(0xFFFF5C5C),
    ],
  );

  static const LinearGradient gradienteCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF111827),
      Color(0xFF0F172A),
    ],
  );

  // =========================================================
  // SHADOWS
  // =========================================================

  static List<BoxShadow> sombraCard = [
    BoxShadow(
      color: Colors.black.withOpacity(0.35),
      blurRadius: 25,
      offset: const Offset(0, 10),
    ),
  ];
}