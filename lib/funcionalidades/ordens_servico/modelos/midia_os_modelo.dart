class MidiaOSModelo {
  final String id;
  final String osId;
  final String url;
  final String tipo; // 'antes' ou 'depois'
  final DateTime dataCriacao;

  MidiaOSModelo({
    required this.id,
    required this.osId,
    required this.url,
    required this.tipo,
    required this.dataCriacao,
  });
}
