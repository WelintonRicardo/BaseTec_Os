class RegrasOS {

  // ==========================================
  // STATUS INICIAIS
  // ==========================================

  static const List<String> statusIniciais = [
    'PENDENTE',
    'GARANTIA',
    'RETORNO_CONCLUSAO',
  ];

  // ==========================================
  // STATUS EXECUÇÃO
  // ==========================================

  static const List<String> statusExecucao = [
    'EM_EXECUCAO',
  ];

  // ==========================================
  // STATUS FINAIS
  // ==========================================

  static const List<String> statusFinais = [
    'CONCLUIDO',
    'AGUARDANDO PECA',
    'CLIENTE AUSENTE',
  ];

  // ==========================================
  // PODE INICIAR EXECUÇÃO
  // ==========================================

  static bool podeIniciarExecucao(
    String? status,
  ) {

    if (status == null) {
      return false;
    }

    return !statusFinais.contains(
      status.toUpperCase(),
    );
  }

  // ==========================================
  // STATUS FINAL
  // ==========================================

  static bool isStatusFinal(
    String? status,
  ) {

    if (status == null) {
      return false;
    }

    return statusFinais.contains(
      status.toUpperCase(),
    );
  }

  // ==========================================
  // STATUS EXECUÇÃO
  // ==========================================

  static bool isEmExecucao(
    String? status,
  ) {

    if (status == null) {
      return false;
    }

    return status.toUpperCase() ==
        'EM_EXECUCAO';
  }
}