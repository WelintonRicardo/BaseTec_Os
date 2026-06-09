import 'package:flutter/material.dart';

enum NivelAcesso { tecnico, adm, gestor }

class RegrasAcesso {
  /// Retorna se o usuário tem permissão para ver a área Administrativa
  /// Regra: Apenas ADM e GESTOR
  static bool podeAcessarAdm(NivelAcesso nivel) {
    return nivel == NivelAcesso.adm || nivel == NivelAcesso.gestor;
  }

  /// Retorna se o usuário tem permissão para ver a área Financeira
  /// Regra: Apenas GESTOR
  static bool podeAcessarFinanceiro(NivelAcesso nivel) {
    return nivel == NivelAcesso.gestor;
  }

  /// Retorna se o usuário tem permissão para a área Técnica (Campo)
  /// Regra: Todos podem ver, mas o foco é o TECNICO
  static bool podeAcessarTecnico(NivelAcesso nivel) {
    return true; 
  }

  /// Converte a String que vem do Banco de Dados para o Enum
  static NivelAcesso converterStringParaEnum(String nivel) {
    switch (nivel.toUpperCase()) {
      case 'ADM':
        return NivelAcesso.adm;
      case 'GESTOR':
        return NivelAcesso.gestor;
      default:
        return NivelAcesso.tecnico;
    }
  }
}
