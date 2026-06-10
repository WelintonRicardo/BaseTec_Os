import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';
class Chips {
  // =========================================
  // CHIP GENÉRICO (INFO)
  // =========================================
  static Widget info(String label, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppCores.primaria.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppCores.primaria.withOpacity(0.25),
        ),
      ),
      child: Text(
        "$label: ${value ?? '---'}",
        style: const TextStyle(
          color: AppCores.textoCinza,
          fontSize: 10,
          height: 1,
        ),
      ),
    );
  }

  // =========================================
  // CHIP STATUS (USANDO SOMENTE AppCores)
  // =========================================
  static Widget status(String? status) {
    final s = status ?? 'pendente';

    Color color;

    switch (s) {
      case 'concluida':
        color = AppCores.concluido;
        break;
      case 'cancelada':
        color = AppCores.cancelado;
        break;
      case 'em_execucao':
        color = AppCores.emAndamento;
        break;
      case 'aguardando_peca':
        color = AppCores.ausente;
        break;
      case 'agendada':
        color = AppCores.emAndamento;
        break;
      case 'retorno':
        color = AppCores.ausente;
        break;
      case 'pendente':
      default:
        color = AppCores.pendente;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        s,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }

  // =========================================
  // CHIP SIMPLES
  // =========================================
  static Widget simple(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppCores.secundaria.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppCores.textoBranco,
          fontSize: 10,
          height: 1,
        ),
      ),
    );
  }
}