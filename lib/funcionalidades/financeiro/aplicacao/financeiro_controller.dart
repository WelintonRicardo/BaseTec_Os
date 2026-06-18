import 'package:flutter/foundation.dart';

import '../dominio/modelos/transacao_model.dart';

class FinanceiroController extends ChangeNotifier {
  // =========================================================
  // LISTA PRINCIPAL
  // =========================================================

  final List<Transacao> _transacoes = [];

  List<Transacao> get transacoes => List.unmodifiable(_transacoes);

  // =========================================================
  // ADICIONAR
  // =========================================================

  void adicionarTransacao(Transacao transacao) {
    _transacoes.add(transacao);

    notifyListeners();
  }

  // =========================================================
  // CARREGAR DO SUPABASE
  // =========================================================

  void carregarTransacoes(List<Transacao> lista) {
    _transacoes
      ..clear()
      ..addAll(lista);

    notifyListeners();
  }

  // =========================================================
  // ATUALIZAR
  // =========================================================

  void atualizarTransacao(Transacao transacao) {
    final index = _transacoes.indexWhere((item) => item.id == transacao.id);

    if (index != -1) {
      _transacoes[index] = transacao;

      notifyListeners();
    }
  }

  // =========================================================
  // REMOVER
  // =========================================================

  void removerTransacao(String id) {
    _transacoes.removeWhere((item) => item.id == id);

    notifyListeners();
  }

  // =========================================================
  // BUSCAR POR ID
  // =========================================================

  Transacao? buscarPorId(String id) {
    try {
      return _transacoes.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  // =========================================================
  // LIMPAR
  // =========================================================

  void limpar() {
    _transacoes.clear();

    notifyListeners();
  }

  // =========================================================
  // TOTAIS
  // =========================================================

  double get totalReceitas => _transacoes
      .where((t) => t.isReceita)
      .fold(0, (total, t) => total + t.valor);

  double get totalDespesas => _transacoes
      .where((t) => !t.isReceita)
      .fold(0, (total, t) => total + t.valor);

  double get saldo => totalReceitas - totalDespesas;

  // =========================================================
  // PERCENTUAL POR CATEGORIA
  // =========================================================

  Map<String, double> calcularPercentuaisPorCategoria() {
    final total = totalDespesas;

    if (total == 0) {
      return {};
    }

    final categorias = <String, double>{};

    for (final t in _transacoes.where((t) => !t.isReceita)) {
      categorias[t.categoria] = (categorias[t.categoria] ?? 0) + t.valor;
    }

    return categorias.map((categoria, valor) {
      return MapEntry(categoria, (valor / total) * 100);
    });
  }

  // =========================================================
  // AGRUPAR POR MÊS
  // =========================================================

  Map<int, double> agruparPorMes({required bool receitas}) {
    final dados = <int, double>{};

    for (final t in _transacoes.where((t) => t.isReceita == receitas)) {
      final mes = t.data.month;

      dados[mes] = (dados[mes] ?? 0) + t.valor;
    }

    return dados;
  }

  // =========================================================
  // AGRUPAR POR CATEGORIA
  // =========================================================

  Map<String, double> agruparPorCategoria() {
    final dados = <String, double>{};

    for (final t in _transacoes.where((t) => !t.isReceita)) {
      dados[t.categoria] = (dados[t.categoria] ?? 0) + t.valor;
    }

    return dados;
  }

  // =========================================================
  // INDICADORES
  // =========================================================

  double get percentualLucro {
    if (totalReceitas == 0) {
      return 0;
    }

    return (saldo / totalReceitas) * 100;
  }

  int get quantidadeLancamentos => _transacoes.length;
}
