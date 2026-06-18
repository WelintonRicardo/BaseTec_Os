import 'dart:math';

import '../dominio/modelos/lancamento_model.dart';

class LancamentosController {
  // =========================================================
  // LISTA PRINCIPAL
  // =========================================================
  static final LancamentosController _instance =
      LancamentosController._internal();

  factory LancamentosController() {
    return _instance;
  }

  LancamentosController._internal();

  List<LancamentoModel> get lancamentos => List.unmodifiable(_lancamentos);
  final List<LancamentoModel> _lancamentos = [];

  // =========================================================
  // CRUD
  // =========================================================

  void adicionarLancamento(LancamentoModel lancamento) {
    _lancamentos.add(lancamento);
  }

  void removerLancamento(String id) {
    _lancamentos.removeWhere((item) => item.id == id);
  }

  void atualizarLancamento(LancamentoModel lancamentoAtualizado) {
    final index = _lancamentos.indexWhere(
      (item) => item.id == lancamentoAtualizado.id,
    );

    if (index != -1) {
      _lancamentos[index] = lancamentoAtualizado;
    }
  }

  // =========================================================
  // BUSCAS
  // =========================================================

  LancamentoModel? buscarPorId(String id) {
    try {
      return _lancamentos.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  List<LancamentoModel> buscarPorCategoria(String categoria) {
    return _lancamentos.where((item) {
      return item.categoria.toLowerCase() == categoria.toLowerCase();
    }).toList();
  }

  List<LancamentoModel> buscarPorStatus(StatusLancamento status) {
    return _lancamentos.where((item) {
      return item.status == status;
    }).toList();
  }

  List<LancamentoModel> buscarReceitas() {
    return _lancamentos.where((item) {
      return item.tipo == TipoLancamento.receita;
    }).toList();
  }

  List<LancamentoModel> buscarDespesas() {
    return _lancamentos.where((item) {
      return item.tipo == TipoLancamento.despesa;
    }).toList();
  }

  List<LancamentoModel> buscarRecorrentes() {
    return _lancamentos.where((item) {
      return item.recorrente;
    }).toList();
  }

  // =========================================================
  // TOTAIS
  // =========================================================

  double get totalReceitas {
    return buscarReceitas().fold(0, (total, item) => total + item.valor);
  }

  double get totalDespesas {
    return buscarDespesas().fold(0, (total, item) => total + item.valor);
  }

  double get saldoAtual {
    return totalReceitas - totalDespesas;
  }

  double get totalPendente {
    return _lancamentos
        .where((item) => item.status == StatusLancamento.pendente)
        .fold(0, (total, item) => total + item.valor);
  }

  double get totalVencido {
    return _lancamentos
        .where((item) => item.status == StatusLancamento.vencido)
        .fold(0, (total, item) => total + item.valor);
  }

  // =========================================================
  // AGRUPAMENTOS
  // =========================================================

  Map<String, double> agruparPorCategoria() {
    final Map<String, double> mapa = {};

    for (final item in _lancamentos) {
      mapa[item.categoria] = (mapa[item.categoria] ?? 0) + item.valor;
    }

    return mapa;
  }

  Map<int, double> agruparPorMes({required bool receitas}) {
    final Map<int, double> dados = {};

    final lista = receitas ? buscarReceitas() : buscarDespesas();

    for (final item in lista) {
      final mes = item.dataLancamento.month;

      dados[mes] = (dados[mes] ?? 0) + item.valor;
    }

    return dados;
  }

  // =========================================================
  // FILTROS
  // =========================================================

  List<LancamentoModel> filtrarPorPeriodo({
    required DateTime inicio,
    required DateTime fim,
  }) {
    return _lancamentos.where((item) {
      return item.dataLancamento.isAfter(
            inicio.subtract(const Duration(days: 1)),
          ) &&
          item.dataLancamento.isBefore(fim.add(const Duration(days: 1)));
    }).toList();
  }

  // =========================================================
  // INDICADORES
  // =========================================================

  double get percentualDespesas {
    if (totalReceitas <= 0) {
      return 0;
    }

    return (totalDespesas / totalReceitas) * 100;
  }

  double get percentualLucro {
    if (totalReceitas <= 0) {
      return 0;
    }

    return (saldoAtual / totalReceitas) * 100;
  }

  // =========================================================
  // AUTOMAÇÃO FUTURA
  // =========================================================

  List<LancamentoModel> detectarContasVencidas() {
    final agora = DateTime.now();

    return _lancamentos.where((item) {
      if (item.dataVencimento == null) {
        return false;
      }

      return item.status != StatusLancamento.pago &&
          item.dataVencimento!.isBefore(agora);
    }).toList();
  }

  List<LancamentoModel> detectarLancamentosAutomaticos() {
    return _lancamentos.where((item) {
      return item.geradoAutomaticamente;
    }).toList();
  }

  // =========================================================
  // GERADOR ID
  // =========================================================

  String gerarId() {
    final random = Random();

    return DateTime.now().millisecondsSinceEpoch.toString() +
        random.nextInt(9999).toString();
  }

  // =========================================================
  // MOCK INICIAL
  // =========================================================

  void carregarDadosMock() {
    if (_lancamentos.isNotEmpty) {
      return;
    }

    adicionarLancamento(
      LancamentoModel(
        id: gerarId(),

        titulo: 'Recebimento OS #102',

        valor: 1800,

        tipo: TipoLancamento.receita,

        categoria: 'Serviços',

        dataLancamento: DateTime.now(),

        status: StatusLancamento.pago,

        formaPagamento: 'PIX',
      ),
    );

    adicionarLancamento(
      LancamentoModel(
        id: gerarId(),

        titulo: 'Conta de Energia',

        valor: 320,

        tipo: TipoLancamento.despesa,

        categoria: 'Operacional',

        dataLancamento: DateTime.now(),

        dataVencimento: DateTime.now().add(const Duration(days: 5)),

        status: StatusLancamento.pendente,

        recorrente: true,

        frequenciaRecorrencia: 'Mensal',
      ),
    );

    adicionarLancamento(
      LancamentoModel(
        id: gerarId(),

        titulo: 'Internet Empresa',

        valor: 149.90,

        tipo: TipoLancamento.despesa,

        categoria: 'Internet',

        dataLancamento: DateTime.now(),

        status: StatusLancamento.pago,

        recorrente: true,

        frequenciaRecorrencia: 'Mensal',
      ),
    );

    adicionarLancamento(
      LancamentoModel(
        id: gerarId(),

        titulo: 'Contrato Manutenção',

        valor: 2500,

        tipo: TipoLancamento.receita,

        categoria: 'Contrato',

        dataLancamento: DateTime.now(),

        status: StatusLancamento.pago,

        geradoAutomaticamente: true,

        origemAutomacao: 'OS Finalizada',
      ),
    );
  }
}
