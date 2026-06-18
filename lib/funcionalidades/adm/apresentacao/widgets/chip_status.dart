import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

/// ======================================================
/// CHIP DE STATUS DA OS
/// ======================================================
///
/// Responsável por:
/// - Definir cor do status
/// - Padronizar textos vindos do banco
/// - Exibir status amigável ao usuário
/// ======================================================

Widget chipStatus(String? status) {
  if (status == null || status.trim().isEmpty) {
    return const SizedBox.shrink();
  }

  final statusNormalizado = status.trim().toLowerCase();

  Color corTexto;
  Color corFundo;

  switch (statusNormalizado) {
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

    case 'concluido':
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
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 4,
    ),
    decoration: BoxDecoration(
      color: corFundo,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: corTexto.withOpacity(0.25),
      ),
    ),
    child: Text(
      _formatarStatus(statusNormalizado),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: corTexto,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

/// ======================================================
/// FORMATA STATUS
/// ======================================================

String _formatarStatus(String status) {
  switch (status) {
    case 'pendente':
      return 'Pendente';

    case 'agendada':
      return 'Agendada';

    case 'em_execucao':
      return 'Em execução';

    case 'aguardando_peca':
      return 'Aguardando peça';

    case 'retorno':
      return 'Retorno';

    case 'concluido':
    case 'concluida':
      return 'Concluído';

    case 'cancelada':
      return 'Cancelada';

    default:
      return status
          .replaceAll('_', ' ')
          .split(' ')
          .map(
            (e) => e.isEmpty
                ? e
                : '${e[0].toUpperCase()}${e.substring(1)}',
          )
          .join(' ');
  }
}