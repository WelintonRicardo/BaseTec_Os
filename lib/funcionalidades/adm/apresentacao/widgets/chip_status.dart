import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

/// Chip genérico para status da OS
Widget chipStatus(String? status) {
  if (status == null || status.isEmpty) {
    return const SizedBox.shrink();
  }

  Color corTexto;
  Color corFundo;

  switch (status.toLowerCase()) {
    case 'pendente':
      corTexto = AppCores.pendente;
      corFundo = AppCores.pendente.withOpacity(0.12);
      break;
    case 'agendada':
    case 'em_execucao':
      corTexto = AppCores.emAndamento;
      corFundo = AppCores.emAndamento.withOpacity(0.12);
      break;
    case 'aguardando_peca':
      corTexto = AppCores.ausente;
      corFundo = AppCores.ausente.withOpacity(0.12);
      break;
    case 'retorno':
      corTexto = AppCores.secundaria;
      corFundo = AppCores.secundaria.withOpacity(0.12);
      break;
    case 'concluida':
      corTexto = AppCores.concluido;
      corFundo = AppCores.concluido.withOpacity(0.12);
      break;
    case 'cancelada':
      corTexto = AppCores.cancelado;
      corFundo = AppCores.cancelado.withOpacity(0.12);
      break;
    default:
      corTexto = AppCores.primaria;
      corFundo = AppCores.primaria.withOpacity(0.12);
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // ✅ menor
    decoration: BoxDecoration(
      color: corFundo,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: corTexto,
        fontSize: 10, // ✅ fonte menor
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
