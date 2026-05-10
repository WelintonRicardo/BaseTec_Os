class OSFotoModel {
  final String id;
  final String osId;
  final String url;
  final String tipo; // 'antes' ou 'depois'
  final DateTime criadoEm;

  OSFotoModel({
    required this.id,
    required this.osId,
    required this.url,
    required this.tipo,
    required this.criadoEm,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'os_id': osId,
      'url': url,
      'tipo': tipo,
      'criado_em': criadoEm.toIso8601String(),
    };
  }
}
  