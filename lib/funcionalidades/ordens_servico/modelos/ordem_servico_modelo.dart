class OrdemServicoModelo {
  final String id;
  final String empresaId;
  final String tecnicoId;
  final String numeroAssistencia;
  final String nomeSegurado;
  final String status;
  final DateTime janelaInicioAgendada;
  final DateTime janelaFimAgendada;
  final DateTime? horarioChegadaReal;
  final DateTime? horarioSaidaReal;
  final double? latitudeLocal;
  final double? longitudeLocal;

  OrdemServicoModelo({
    required this.id,
    required this.empresaId,
    required this.tecnicoId,
    required this.numeroAssistencia,
    required this.nomeSegurado,
    required this.status,
    required this.janelaInicioAgendada,
    required this.janelaFimAgendada,
    this.horarioChegadaReal,
    this.horarioSaidaReal,
    this.latitudeLocal,
    this.longitudeLocal,
  });

  // ESTA É A FUNÇÃO QUE ESTAVA FALTANDO
  factory OrdemServicoModelo.fromMap(Map<String, dynamic> mapa) {
    return OrdemServicoModelo(
      id: mapa['id'].toString(),
      empresaId: mapa['empresa_id'].toString(),
      tecnicoId: mapa['tecnico_id'].toString(),
      numeroAssistencia: mapa['numero_assistencia'] ?? '',
      nomeSegurado: mapa['nome_segurado'] ?? '',
      status: mapa['status'] ?? 'pendente',
      janelaInicioAgendada: DateTime.parse(mapa['janela_inicio_agendada']),
      janelaFimAgendada: DateTime.parse(mapa['janela_fim_agendada']),
      horarioChegadaReal: mapa['horario_chegada_real'] != null 
          ? DateTime.parse(mapa['horario_chegada_real']) : null,
      horarioSaidaReal: mapa['horario_saida_real'] != null 
          ? DateTime.parse(mapa['horario_saida_real']) : null,
      latitudeLocal: mapa['latitude_local']?.toDouble(),
      longitudeLocal: mapa['longitude_local']?.toDouble(),
    );
  }
}
