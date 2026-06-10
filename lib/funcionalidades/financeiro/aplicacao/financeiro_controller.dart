import '../dominio/modelos/transacao_model.dart';

class FinanceiroController {
  final List<Transacao> _transacoes = [];

  List<Transacao> get transacoes => _transacoes;

  void adicionarTransacao(Transacao transacao) {
    _transacoes.add(transacao);
  }

  double get totalReceitas =>
      _transacoes.where((t) => t.isReceita).fold(0, (s, t) => s + t.valor);

  double get totalDespesas =>
      _transacoes.where((t) => !t.isReceita).fold(0, (s, t) => s + t.valor);

  double get saldo => totalReceitas - totalDespesas;

  /// Novo método para calcular percentuais por categoria
  Map<String, double> calcularPercentuaisPorCategoria() {
    final total = totalDespesas;
    if (total == 0) return {};

    final categorias = <String, double>{};
    for (var t in _transacoes.where((t) => !t.isReceita)) {
      categorias[t.categoria] = (categorias[t.categoria] ?? 0) + t.valor;
    }

    return categorias.map((k, v) => MapEntry(k, (v / total) * 100));
  }

  Map<int, double> agruparPorMes({required bool receitas}) {
  final dados = <int, double>{};
  for (var t in _transacoes.where((t) => t.isReceita == receitas)) {
    final mes = t.data.month;
    dados[mes] = (dados[mes] ?? 0) + t.valor;
  }
  return dados;
}

Map<String, double> agruparPorCategoria() {
  final dados = <String, double>{};
  for (var t in _transacoes.where((t) => !t.isReceita)) {
    final categoria = t.categoria;
    dados[categoria] = (dados[categoria] ?? 0) + t.valor;
  }
  return dados;
}

}
