import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

import '../../aplicacao/lancamentos_controller.dart';
import '../../aplicacao/financeiro_controller.dart';
import '../../dominio/modelos/transacao_model.dart';

import '../../widgets/card_resumo.dart';
import '../../widgets/fluxo_caixa.dart';
import '../../widgets/grafico_pizza.dart';
import '../../widgets/lista_transacoes.dart';
import '../../widgets/proximas_contas.dart';
import '../../widgets/ranking_despesas.dart';
import '../../widgets/saldo_meta.dart';

import '../../aplicacao/lancamentos_controller.dart';

import '../../dominio/modelos/lancamento_model.dart';

import '../../widgets/modal_novo_lancamento.dart';

class TelaFinanceiro extends StatelessWidget {
  const TelaFinanceiro({super.key});

  TextStyle get tituloSecao => const TextStyle(
    color: AppCores.textoBranco,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final financeiroController = FinanceiroController();
    final lancamentosController = LancamentosController();

    lancamentosController.carregarDadosMock();
    // =========================================================
    // DADOS EXEMPLO
    // =========================================================

    financeiroController.adicionarTransacao(
      Transacao(
        id: '1',
        descricao: 'Supermercado',
        valor: 250,
        data: DateTime.now(),
        isReceita: false,
        categoria: 'Alimentação',
      ),
    );

    financeiroController.adicionarTransacao(
      Transacao(
        id: '2',
        descricao: 'Aluguel',
        valor: 1200,
        data: DateTime.now(),
        isReceita: false,
        categoria: 'Moradia',
      ),
    );

    financeiroController.adicionarTransacao(
      Transacao(
        id: '3',
        descricao: 'Salário',
        valor: 5000,
        data: DateTime.now(),
        isReceita: true,
        categoria: 'Receita',
      ),
    );

    financeiroController.adicionarTransacao(
      Transacao(
        id: '4',
        descricao: 'Freelance',
        valor: 2000,
        data: DateTime(2026, 5, 10),
        isReceita: true,
        categoria: 'Receita',
      ),
    );

    financeiroController.adicionarTransacao(
      Transacao(
        id: '5',
        descricao: 'Viagem',
        valor: 800,
        data: DateTime(2026, 4, 20),
        isReceita: false,
        categoria: 'Lazer',
      ),
    );

    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      // =======================================================
      // APP BAR
      // =======================================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: const Text(
          'Dashboard Financeiro',
          style: TextStyle(
            color: AppCores.textoBranco,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),

            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,

                  builder: (_) => ModalNovoLancamento(
                    onSalvar: (LancamentoModel lancamento) {
                      lancamentosController.adicionarLancamento(lancamento);
                    },
                  ),
                );
              },

              icon: const Icon(Icons.add_rounded),

              label: const Text('Novo lançamento'),

              style: ElevatedButton.styleFrom(
                backgroundColor: AppCores.primaria,

                foregroundColor: Colors.white,

                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),

      // =======================================================
      // BODY
      // =======================================================
      body: Container(
        decoration: const BoxDecoration(gradient: AppCores.gradienteFundo),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1600),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool mobile = constraints.maxWidth < 1200;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===================================================
                        // CARDS SUPERIORES
                        // ===================================================
                        mobile
                            ? Column(
                                children: [
                                  CardResumo(
                                    titulo: 'Receitas',
                                    valor:
                                        '+ R\$ ${financeiroController.totalReceitas.toStringAsFixed(2)}',
                                    cor: AppCores.receita,
                                  ),

                                  const SizedBox(height: 20),

                                  CardResumo(
                                    titulo: 'Despesas',
                                    valor:
                                        '- R\$ ${financeiroController.totalDespesas.toStringAsFixed(2)}',
                                    cor: AppCores.despesa,
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: CardResumo(
                                      titulo: 'Receitas',
                                      valor:
                                          '+ R\$ ${financeiroController.totalReceitas.toStringAsFixed(2)}',
                                      cor: AppCores.receita,
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  Expanded(
                                    child: CardResumo(
                                      titulo: 'Despesas',
                                      valor:
                                          '- R\$ ${financeiroController.totalDespesas.toStringAsFixed(2)}',
                                      cor: AppCores.despesa,
                                    ),
                                  ),
                                ],
                              ),

                        const SizedBox(height: 28),

                        // ===================================================
                        // GRID PRINCIPAL
                        // ===================================================
                        mobile
                            ? Column(
                                children: [
                                  // SALDO
                                  SaldoMeta(
                                    controller: financeiroController,
                                    metaMensal: 15000,
                                  ),

                                  const SizedBox(height: 24),

                                  // GRAFICO
                                  _secao(
                                    titulo: 'Visão Geral de Gastos',
                                    child: GraficoPizza(
                                      controller: financeiroController,
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // TRANSAÇÕES
                                  _secao(
                                    titulo: 'Últimas Transações',
                                    child: ListaTransacoes(
                                      transacoes:
                                          financeiroController.transacoes,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SaldoMeta(
                                      controller: financeiroController,
                                      metaMensal: 15000,
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  Expanded(
                                    child: _secao(
                                      titulo: 'Visão Geral de Gastos',
                                      child: GraficoPizza(
                                        controller: financeiroController,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  Expanded(
                                    child: _secao(
                                      titulo: 'Últimas Transações',
                                      child: ListaTransacoes(
                                        transacoes:
                                            financeiroController.transacoes,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                        const SizedBox(height: 28),

                        // ===================================================
                        // LINHA INFERIOR
                        // ===================================================
                        mobile
                            ? Column(
                                children: [
                                  _secao(
                                    titulo: 'Próximas Contas',
                                    child: ProximasContas(
                                      contas: [
                                        {
                                          'descricao': 'Conta de Luz',
                                          'valor': 300.0,
                                          'data': '15/06/2026',
                                        },
                                        {
                                          'descricao': 'Internet',
                                          'valor': 120.0,
                                          'data': '20/06/2026',
                                        },
                                        {
                                          'descricao': 'Cartão de Crédito',
                                          'valor': 1500.0,
                                          'data': '25/06/2026',
                                        },
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  _secao(
                                    titulo: 'Ranking de Despesas',
                                    child: RankingDespesas(
                                      controller: financeiroController,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _secao(
                                      titulo: 'Próximas Contas',
                                      child: ProximasContas(
                                        contas: [
                                          {
                                            'descricao': 'Conta de Luz',
                                            'valor': 300.0,
                                            'data': '15/06/2026',
                                          },
                                          {
                                            'descricao': 'Internet',
                                            'valor': 120.0,
                                            'data': '20/06/2026',
                                          },
                                          {
                                            'descricao': 'Cartão de Crédito',
                                            'valor': 1500.0,
                                            'data': '25/06/2026',
                                          },
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  Expanded(
                                    child: _secao(
                                      titulo: 'Ranking de Despesas',
                                      child: RankingDespesas(
                                        controller: financeiroController,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                        const SizedBox(height: 28),

                        // ===================================================
                        // FLUXO DE CAIXA
                        // ===================================================
                        _secao(
                          titulo: 'Fluxo de Caixa',
                          child: SizedBox(
                            height: 380,
                            child: FluxoCaixa(controller: financeiroController),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // CONTAINER PADRÃO
  // ===========================================================

  Widget _secao({required String titulo, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        gradient: AppCores.gradienteCard,

        borderRadius: BorderRadius.circular(28),

        border: Border.all(color: AppCores.bordaEscura),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: tituloSecao),

          const SizedBox(height: 24),

          child,
        ],
      ),
    );
  }
}
