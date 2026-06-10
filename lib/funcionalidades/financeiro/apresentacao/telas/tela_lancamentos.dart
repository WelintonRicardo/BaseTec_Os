import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

import '../../aplicacao/lancamentos_controller.dart';

import '../../dominio/modelos/lancamento_model.dart';

import '../../widgets/modal_novo_lancamento.dart';

class TelaLancamentos extends StatefulWidget {
  const TelaLancamentos({super.key});

  @override
  State<TelaLancamentos> createState() => _TelaLancamentosState();
}

class _TelaLancamentosState extends State<TelaLancamentos> {
  // =========================================================
  // CONTROLLER
  // =========================================================

  final LancamentosController controller = LancamentosController();

  // =========================================================
  // FILTROS
  // =========================================================

  String busca = '';

  TipoLancamento? filtroTipo;

  StatusLancamento? filtroStatus;

  @override
  void initState() {
    super.initState();

    controller.carregarDadosMock();
  }

  // =========================================================
  // LISTA FILTRADA
  // =========================================================

  List<LancamentoModel> get lancamentosFiltrados {
    return controller.lancamentos.where((item) {
      final matchBusca =
          item.titulo.toLowerCase().contains(busca.toLowerCase()) ||
          item.categoria.toLowerCase().contains(busca.toLowerCase());

      final matchTipo = filtroTipo == null || item.tipo == filtroTipo;

      final matchStatus = filtroStatus == null || item.status == filtroStatus;

      return matchBusca && matchTipo && matchStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.transparent,

        title: const Text(
          'Lançamentos Financeiros',

          style: TextStyle(
            color: AppCores.textoBranco,

            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),

            child: ElevatedButton.icon(
              onPressed: () async {
                await showDialog(
                  context: context,

                  builder: (_) => ModalNovoLancamento(
                    onSalvar: (lancamento) {
                      setState(() {
                        controller.adicionarLancamento(lancamento);
                      });
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

      body: Container(
        decoration: const BoxDecoration(gradient: AppCores.gradienteFundo),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                // ===================================================
                // FILTROS
                // ===================================================
                _filtros(),

                const SizedBox(height: 24),

                // ===================================================
                // TABELA
                // ===================================================
                Expanded(
                  child: Container(
                    width: double.infinity,

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

                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),

                      child: DataTable(
                        headingRowHeight: 60,

                        dataRowMinHeight: 70,

                        dataRowMaxHeight: 70,

                        headingTextStyle: const TextStyle(
                          color: AppCores.textoBranco,

                          fontWeight: FontWeight.bold,
                        ),

                        columns: const [
                          DataColumn(label: Text('Título')),

                          DataColumn(label: Text('Categoria')),

                          DataColumn(label: Text('Tipo')),

                          DataColumn(label: Text('Valor')),

                          DataColumn(label: Text('Status')),

                          DataColumn(label: Text('Recorrente')),

                          DataColumn(label: Text('Ações')),
                        ],

                        rows: lancamentosFiltrados.map((item) {
                          final cor = item.tipo == TipoLancamento.receita
                              ? AppCores.receita
                              : AppCores.despesa;

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  item.titulo,

                                  style: const TextStyle(
                                    color: AppCores.textoBranco,
                                  ),
                                ),
                              ),

                              DataCell(
                                Text(
                                  item.categoria,

                                  style: const TextStyle(
                                    color: AppCores.textoCinza,
                                  ),
                                ),
                              ),

                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,

                                    vertical: 6,
                                  ),

                                  decoration: BoxDecoration(
                                    color: cor.withOpacity(0.12),

                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  child: Text(
                                    item.tipo == TipoLancamento.receita
                                        ? 'Receita'
                                        : 'Despesa',

                                    style: TextStyle(
                                      color: cor,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              DataCell(
                                Text(
                                  'R\$ ${item.valor.toStringAsFixed(2)}',

                                  style: TextStyle(
                                    color: cor,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              DataCell(_statusChip(item.status)),

                              DataCell(
                                Icon(
                                  item.recorrente
                                      ? Icons.repeat_rounded
                                      : Icons.remove_rounded,

                                  color: item.recorrente
                                      ? AppCores.primaria
                                      : AppCores.textoCinza,
                                ),
                              ),

                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},

                                      icon: const Icon(
                                        Icons.edit_rounded,

                                        color: AppCores.primaria,
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          controller.removerLancamento(item.id);
                                        });
                                      },

                                      icon: const Icon(
                                        Icons.delete_rounded,

                                        color: AppCores.despesa,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // FILTROS
  // =========================================================

  Widget _filtros() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: AppCores.gradienteCard,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: AppCores.bordaEscura),
      ),

      child: Wrap(
        spacing: 18,
        runSpacing: 18,

        children: [
          SizedBox(
            width: 300,

            child: TextField(
              onChanged: (value) {
                setState(() {
                  busca = value;
                });
              },

              style: const TextStyle(color: AppCores.textoBranco),

              decoration: InputDecoration(
                hintText: 'Buscar lançamento...',

                hintStyle: const TextStyle(color: AppCores.textoCinza),

                prefixIcon: const Icon(
                  Icons.search_rounded,

                  color: AppCores.primaria,
                ),

                filled: true,

                fillColor: Colors.white.withOpacity(0.03),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),

                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          _dropdownTipo(),

          _dropdownStatus(),
        ],
      ),
    );
  }

  // =========================================================
  // DROPDOWN TIPO
  // =========================================================

  Widget _dropdownTipo() {
    return SizedBox(
      width: 220,

      child: DropdownButtonFormField<TipoLancamento?>(
        value: filtroTipo,

        dropdownColor: AppCores.cardEscuro,

        decoration: _inputDecoration('Tipo'),

        style: const TextStyle(color: AppCores.textoBranco),

        items: [
          const DropdownMenuItem(value: null, child: Text('Todos')),

          ...TipoLancamento.values.map((tipo) {
            return DropdownMenuItem(value: tipo, child: Text(tipo.name));
          }),
        ],

        onChanged: (value) {
          setState(() {
            filtroTipo = value;
          });
        },
      ),
    );
  }

  // =========================================================
  // DROPDOWN STATUS
  // =========================================================

  Widget _dropdownStatus() {
    return SizedBox(
      width: 220,

      child: DropdownButtonFormField<StatusLancamento?>(
        value: filtroStatus,

        dropdownColor: AppCores.cardEscuro,

        decoration: _inputDecoration('Status'),

        style: const TextStyle(color: AppCores.textoBranco),

        items: [
          const DropdownMenuItem(value: null, child: Text('Todos')),

          ...StatusLancamento.values.map((status) {
            return DropdownMenuItem(value: status, child: Text(status.name));
          }),
        ],

        onChanged: (value) {
          setState(() {
            filtroStatus = value;
          });
        },
      ),
    );
  }

  // =========================================================
  // STATUS CHIP
  // =========================================================

  Widget _statusChip(StatusLancamento status) {
    Color cor;

    switch (status) {
      case StatusLancamento.pago:
        cor = AppCores.receita;
        break;

      case StatusLancamento.pendente:
        cor = Colors.orange;
        break;

      case StatusLancamento.vencido:
        cor = AppCores.despesa;
        break;

      default:
        cor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: cor.withOpacity(0.12),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Text(
        status.name.toUpperCase(),

        style: TextStyle(color: cor, fontWeight: FontWeight.bold),
      ),
    );
  }

  // =========================================================
  // INPUT DECORATION
  // =========================================================

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,

      labelStyle: const TextStyle(color: AppCores.textoCinza),

      filled: true,

      fillColor: Colors.white.withOpacity(0.03),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),

        borderSide: BorderSide.none,
      ),
    );
  }
}
