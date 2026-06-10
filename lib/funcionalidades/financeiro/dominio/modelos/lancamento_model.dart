enum TipoLancamento {
  receita,
  despesa,
}

enum StatusLancamento {
  pendente,
  pago,
  vencido,
  cancelado,
}

class LancamentoModel {
  final String id;

  // =========================================================
  // INFORMAÇÕES PRINCIPAIS
  // =========================================================

  final String titulo;

  final String? descricao;

  final double valor;

  final TipoLancamento tipo;

  final String categoria;

  // =========================================================
  // DATAS
  // =========================================================

  final DateTime dataLancamento;

  final DateTime? dataVencimento;

  final DateTime? dataPagamento;

  // =========================================================
  // STATUS
  // =========================================================

  final StatusLancamento status;

  // =========================================================
  // PAGAMENTO
  // =========================================================

  final String? formaPagamento;

  // =========================================================
  // RECORRÊNCIA
  // =========================================================

  final bool recorrente;

  final String? frequenciaRecorrencia;

  // =========================================================
  // AUTOMAÇÃO FUTURA
  // =========================================================

  final bool geradoAutomaticamente;

  final String? origemAutomacao;

  // =========================================================
  // RELACIONAMENTOS FUTUROS
  // =========================================================

  final String? clienteId;

  final String? tecnicoId;

  final String? ordemServicoId;

  // =========================================================
  // OBSERVAÇÕES
  // =========================================================

  final String? observacoes;

  const LancamentoModel({
    required this.id,
    required this.titulo,
    required this.valor,
    required this.tipo,
    required this.categoria,
    required this.dataLancamento,
    required this.status,

    this.descricao,
    this.dataVencimento,
    this.dataPagamento,
    this.formaPagamento,

    this.recorrente = false,
    this.frequenciaRecorrencia,

    this.geradoAutomaticamente = false,
    this.origemAutomacao,

    this.clienteId,
    this.tecnicoId,
    this.ordemServicoId,

    this.observacoes,
  });

  // =========================================================
  // COPY WITH
  // =========================================================

  LancamentoModel copyWith({
    String? id,
    String? titulo,
    String? descricao,
    double? valor,
    TipoLancamento? tipo,
    String? categoria,
    DateTime? dataLancamento,
    DateTime? dataVencimento,
    DateTime? dataPagamento,
    StatusLancamento? status,
    String? formaPagamento,
    bool? recorrente,
    String? frequenciaRecorrencia,
    bool? geradoAutomaticamente,
    String? origemAutomacao,
    String? clienteId,
    String? tecnicoId,
    String? ordemServicoId,
    String? observacoes,
  }) {
    return LancamentoModel(
      id: id ?? this.id,

      titulo: titulo ?? this.titulo,

      descricao: descricao ?? this.descricao,

      valor: valor ?? this.valor,

      tipo: tipo ?? this.tipo,

      categoria: categoria ?? this.categoria,

      dataLancamento:
          dataLancamento ??
          this.dataLancamento,

      dataVencimento:
          dataVencimento ??
          this.dataVencimento,

      dataPagamento:
          dataPagamento ??
          this.dataPagamento,

      status: status ?? this.status,

      formaPagamento:
          formaPagamento ??
          this.formaPagamento,

      recorrente:
          recorrente ??
          this.recorrente,

      frequenciaRecorrencia:
          frequenciaRecorrencia ??
          this.frequenciaRecorrencia,

      geradoAutomaticamente:
          geradoAutomaticamente ??
          this.geradoAutomaticamente,

      origemAutomacao:
          origemAutomacao ??
          this.origemAutomacao,

      clienteId:
          clienteId ?? this.clienteId,

      tecnicoId:
          tecnicoId ?? this.tecnicoId,

      ordemServicoId:
          ordemServicoId ??
          this.ordemServicoId,

      observacoes:
          observacoes ??
          this.observacoes,
    );
  }

  // =========================================================
  // TO MAP
  // =========================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'titulo': titulo,

      'descricao': descricao,

      'valor': valor,

      'tipo': tipo.name,

      'categoria': categoria,

      'data_lancamento':
          dataLancamento.toIso8601String(),

      'data_vencimento':
          dataVencimento?.toIso8601String(),

      'data_pagamento':
          dataPagamento?.toIso8601String(),

      'status': status.name,

      'forma_pagamento':
          formaPagamento,

      'recorrente': recorrente,

      'frequencia_recorrencia':
          frequenciaRecorrencia,

      'gerado_automaticamente':
          geradoAutomaticamente,

      'origem_automacao':
          origemAutomacao,

      'cliente_id': clienteId,

      'tecnico_id': tecnicoId,

      'ordem_servico_id':
          ordemServicoId,

      'observacoes': observacoes,
    };
  }

  // =========================================================
  // FROM MAP
  // =========================================================

  factory LancamentoModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return LancamentoModel(
      id: map['id'] ?? '',

      titulo: map['titulo'] ?? '',

      descricao: map['descricao'],

      valor:
          (map['valor'] ?? 0)
              .toDouble(),

      tipo:
          map['tipo'] == 'receita'
              ? TipoLancamento.receita
              : TipoLancamento.despesa,

      categoria:
          map['categoria'] ?? '',

      dataLancamento:
          DateTime.parse(
        map['data_lancamento'],
      ),

      dataVencimento:
          map['data_vencimento'] != null
              ? DateTime.parse(
                  map['data_vencimento'],
                )
              : null,

      dataPagamento:
          map['data_pagamento'] != null
              ? DateTime.parse(
                  map['data_pagamento'],
                )
              : null,

      status: StatusLancamento.values
          .firstWhere(
        (e) => e.name == map['status'],
      ),

      formaPagamento:
          map['forma_pagamento'],

      recorrente:
          map['recorrente'] ?? false,

      frequenciaRecorrencia:
          map['frequencia_recorrencia'],

      geradoAutomaticamente:
          map['gerado_automaticamente'] ??
              false,

      origemAutomacao:
          map['origem_automacao'],

      clienteId:
          map['cliente_id'],

      tecnicoId:
          map['tecnico_id'],

      ordemServicoId:
          map['ordem_servico_id'],

      observacoes:
          map['observacoes'],
    );
  }
}