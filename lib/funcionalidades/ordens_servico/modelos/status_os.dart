import 'package:flutter/material.dart';
import '../../../compartilhado/tema_cores.dart';

enum StatusOS {
  pendente('pendente'),
  emAtendimento('em_atendimento'),
  concluida('concluida'),
  cancelada('cancelada'),
  clienteAusente('cliente_ausente'); // Novo Status

  final String chave;
  const StatusOS(this.chave);

  static StatusOS deString(String valor) {
    return StatusOS.values.firstWhere(
      (e) => e.chave == valor,
      orElse: () => StatusOS.pendente,
    );
  }

  String get nome {
    switch (this) {
      case StatusOS.pendente: return 'AGUARDANDO';
      case StatusOS.emAtendimento: return 'EM ANDAMENTO';
      case StatusOS.concluida: return 'CONCLUÍDA';
      case StatusOS.cancelada: return 'CANCELADA';
      case StatusOS.clienteAusente: return 'CLIENTE AUSENTE';
    }
  }

  Color get cor {
    switch (this) {
      case StatusOS.pendente: return AppCores.pendente;
      case StatusOS.emAtendimento: return AppCores.emAndamento;
      case StatusOS.concluida: return AppCores.concluido;
      case StatusOS.cancelada: return AppCores.cancelado;
      case StatusOS.clienteAusente: return AppCores.ausente;
    }
  }

  IconData get icone {
    switch (this) {
      case StatusOS.pendente: return Icons.schedule;
      case StatusOS.emAtendimento: return Icons.engineering;
      case StatusOS.concluida: return Icons.verified_user;
      case StatusOS.cancelada: return Icons.cancel_outlined;
      case StatusOS.clienteAusente: return Icons.person_off_outlined;
    }
  }
}
