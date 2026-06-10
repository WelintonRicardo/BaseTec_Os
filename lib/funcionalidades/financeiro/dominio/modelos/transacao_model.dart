class Transacao {
  final String id;
  final String descricao;
  final double valor;
  final DateTime data;
  final bool isReceita;
  final String categoria;

  Transacao({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.isReceita,
    required this.categoria,
  });
}
