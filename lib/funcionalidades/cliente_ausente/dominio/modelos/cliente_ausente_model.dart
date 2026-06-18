class ClienteAusenteModel {
  final String ordemServicoId;

  final String tecnicoId;

  final String observacoes;

  final String? contato1;
  final String? resultadoContato1;

  final String? contato2;
  final String? resultadoContato2;

  final String? fotoUrl;

  final double? latitude;
  final double? longitude;

  // ==========================================
  // EMPRESA RESPONSÁVEL
  // ==========================================

  final String? empresaNome;

  final String? empresaLogoUrl;

  // ==========================================
  // PDF E LINK PÚBLICO
  // ==========================================

  final String? pdfUrl;

  final String? linkPublico;

  final DateTime dataRegistro;

  const ClienteAusenteModel({
    required this.ordemServicoId,
    required this.tecnicoId,
    required this.observacoes,
    required this.dataRegistro,

    this.contato1,
    this.resultadoContato1,

    this.contato2,
    this.resultadoContato2,

    this.fotoUrl,

    this.latitude,
    this.longitude,

    this.empresaNome,
    this.empresaLogoUrl,

    this.pdfUrl,
    this.linkPublico,
  });

  Map<String, dynamic> toMap() {
    return {
      'ordem_servico_id': ordemServicoId,

      'tecnico_id': tecnicoId,

      'observacoes': observacoes,

      'contato_1': contato1,
      'resultado_contato_1': resultadoContato1,

      'contato_2': contato2,
      'resultado_contato_2': resultadoContato2,

      'foto_url': fotoUrl,

      'latitude': latitude,
      'longitude': longitude,

      'empresa_nome': empresaNome,
      'empresa_logo_url': empresaLogoUrl,

      'pdf_url': pdfUrl,

      'link_publico': linkPublico,

      'criado_em': dataRegistro.toIso8601String(),
    };
  }

  factory ClienteAusenteModel.fromMap(Map<String, dynamic> map) {
    return ClienteAusenteModel(
      ordemServicoId: map['ordem_servico_id'] ?? '',

      tecnicoId: map['tecnico_id'] ?? '',

      observacoes: map['observacoes'] ?? '',

      contato1: map['contato_1'],

      resultadoContato1: map['resultado_contato_1'],

      contato2: map['contato_2'],

      resultadoContato2: map['resultado_contato_2'],

      fotoUrl: map['foto_url'],

      latitude: map['latitude']?.toDouble(),

      longitude: map['longitude']?.toDouble(),

      empresaNome: map['empresa_nome'],

      empresaLogoUrl: map['empresa_logo_url'],

      pdfUrl: map['pdf_url'],

      linkPublico: map['link_publico'],

      dataRegistro: DateTime.parse(map['criado_em']),
    );
  }
}
