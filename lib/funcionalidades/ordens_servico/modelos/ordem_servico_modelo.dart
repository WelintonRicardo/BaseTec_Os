class OrdemServicoModelo {
  final String id;
  final String empresaId;
  final String tecnicoId;
  final String numeroAssistencia;
  final String nomeSegurado;
  final String status;

  // --- NOVOS CAMPOS PARA DETALHES DO SEGURADO ---
  final String? seguradora;
  final String? telefoneSegurado;
  final String endereco;
  final String numeroResidencia;
  final String? complemento;
  final String cidade;
  final String? servicoExecutar;

  // --- DATAS E HORÁRIOS ---
  final DateTime? janelaInicioAgendada;
  final DateTime? janelaFimAgendada;
  final DateTime? horarioChegadaReal;
  final DateTime? horarioSaidaReal;

  // --- GEOLOCALIZAÇÃO ---
  final double? latitudeLocal;
  final double? longitudeLocal;

  // --- FOTOS (ESSENCIAL PARA O MVP) ---
  final List<String> fotosAntes;
  final List<String> fotosDepois;

  OrdemServicoModelo({
    required this.id,
    required this.empresaId,
    required this.tecnicoId,
    required this.numeroAssistencia,
    required this.nomeSegurado,
    required this.status,
    this.seguradora,
    this.telefoneSegurado,
    required this.endereco,
    required this.numeroResidencia,
    this.complemento,
    required this.cidade,
    this.servicoExecutar,
    this.janelaInicioAgendada,
    this.janelaFimAgendada,
    this.horarioChegadaReal,
    this.horarioSaidaReal,
    this.latitudeLocal,
    this.longitudeLocal,
    this.fotosAntes = const [],
    this.fotosDepois = const [],
  });

  factory OrdemServicoModelo.fromMap(Map<String, dynamic> mapa) {
    return OrdemServicoModelo(
      id: mapa['id']?.toString() ?? '',
      empresaId: mapa['empresa_id']?.toString() ?? '',
      tecnicoId: mapa['tecnico_id']?.toString() ?? '',
      numeroAssistencia: mapa['numero_assistencia']?.toString() ?? '',
      nomeSegurado: mapa['nome_segurado']?.toString() ?? '',
      status: mapa['status']?.toString() ?? 'pendente',
      
      // Novos campos com tratamento de nulos
      seguradora: mapa['seguradora']?.toString(),
      telefoneSegurado: mapa['telefone_segurado']?.toString(),
      endereco: mapa['endereco']?.toString() ?? 'Endereço não informado',
      numeroResidencia: mapa['numero_residencia']?.toString() ?? 'S/N',
      complemento: mapa['complemento']?.toString(),
      cidade: mapa['cidade']?.toString() ?? '',
      servicoExecutar: mapa['servico_executar']?.toString(),
      
      janelaInicioAgendada: mapa['janela_inicio_agendada'] != null
          ? DateTime.tryParse(mapa['janela_inicio_agendada'].toString())
          : null,
      
      janelaFimAgendada: mapa['janela_fim_agendada'] != null
          ? DateTime.tryParse(mapa['janela_fim_agendada'].toString())
          : null,
      
      horarioChegadaReal: mapa['horario_chegada_real'] != null
          ? DateTime.tryParse(mapa['horario_chegada_real'].toString())
          : null,
      
      horarioSaidaReal: mapa['horario_saida_real'] != null
          ? DateTime.tryParse(mapa['horario_saida_real'].toString())
          : null,
      
      latitudeLocal: mapa['latitude_local'] != null
          ? double.tryParse(mapa['latitude_local'].toString())
          : null,
      
      longitudeLocal: mapa['longitude_local'] != null
          ? double.tryParse(mapa['longitude_local'].toString())
          : null,

      fotosAntes: mapa['fotos_antes'] != null 
          ? List<String>.from(mapa['fotos_antes']) 
          : const [],
      fotosDepois: mapa['fotos_depois'] != null 
          ? List<String>.from(mapa['fotos_depois']) 
          : const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'empresa_id': empresaId,
      'tecnico_id': tecnicoId,
      'numero_assistencia': numeroAssistencia,
      'nome_segurado': nomeSegurado,
      'status': status,
      'seguradora': seguradora,
      'telefone_segurado': telefoneSegurado,
      'endereco': endereco,
      'numero_residencia': numeroResidencia,
      'complemento': complemento,
      'cidade': cidade,
      'servico_executar': servicoExecutar,
      'janela_inicio_agendada': janelaInicioAgendada?.toIso8601String(),
      'janela_fim_agendada': janelaFimAgendada?.toIso8601String(),
      'horario_chegada_real': horarioChegadaReal?.toIso8601String(),
      'horario_saida_real': horarioSaidaReal?.toIso8601String(),
      'latitude_local': latitudeLocal,
      'longitude_local': longitudeLocal,
      'fotos_antes': fotosAntes,
      'fotos_depois': fotosDepois,
    };
  }
}
