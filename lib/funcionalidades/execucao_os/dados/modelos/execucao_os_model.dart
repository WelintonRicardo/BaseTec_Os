class ExecucaoOS {
  final String id;
  final String ordemServicoId;
  final String tecnicoId;

  final String statusExecucao;

  final DateTime? inicioExecucao;
  final DateTime? fimExecucao;

  final double? latitudeInicio;
  final double? longitudeInicio;

  final double? latitudeFim;
  final double? longitudeFim;

  final String? observacoes;

  final List<dynamic>? checklist;

  final String? assinaturaCliente;

  ExecucaoOS({
    required this.id,
    required this.ordemServicoId,
    required this.tecnicoId,
    required this.statusExecucao,
    this.inicioExecucao,
    this.fimExecucao,
    this.latitudeInicio,
    this.longitudeInicio,
    this.latitudeFim,
    this.longitudeFim,
    this.observacoes,
    this.checklist,
    this.assinaturaCliente,
  });

  factory ExecucaoOS.fromMap(Map<String, dynamic> map) {
    return ExecucaoOS(
      id: map['id'],
      ordemServicoId: map['ordem_servico_id'],
      tecnicoId: map['tecnico_id'],
      statusExecucao: map['status_execucao'],
      inicioExecucao: map['inicio_execucao'] != null
          ? DateTime.parse(map['inicio_execucao'])
          : null,
      fimExecucao: map['fim_execucao'] != null
          ? DateTime.parse(map['fim_execucao'])
          : null,
      latitudeInicio: map['latitude_inicio'],
      longitudeInicio: map['longitude_inicio'],
      latitudeFim: map['latitude_fim'],
      longitudeFim: map['longitude_fim'],
      observacoes: map['observacoes'],
      checklist: map['checklist'],
      assinaturaCliente: map['assinatura_cliente'],
    );
  }
}