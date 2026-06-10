import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

import '../dominio/modelos/lancamento_model.dart';

class ModalNovoLancamento extends StatefulWidget {
  final Function(LancamentoModel)
  onSalvar;

  const ModalNovoLancamento({
    super.key,
    required this.onSalvar,
  });

  @override
  State<ModalNovoLancamento>
  createState() =>
      _ModalNovoLancamentoState();
}

class _ModalNovoLancamentoState
    extends State<ModalNovoLancamento> {
  // =========================================================
  // CONTROLLERS
  // =========================================================

  final tituloController =
      TextEditingController();

  final descricaoController =
      TextEditingController();

  final valorController =
      TextEditingController();

  final categoriaController =
      TextEditingController();

  final observacaoController =
      TextEditingController();

  // =========================================================
  // ESTADOS
  // =========================================================

  TipoLancamento tipo =
      TipoLancamento.receita;

  StatusLancamento status =
      StatusLancamento.pendente;

  bool recorrente = false;

  DateTime dataLancamento =
      DateTime.now();

  String formaPagamento = 'PIX';

  // =========================================================
  // SALVAR
  // =========================================================

  void salvar() {
    final valor = double.tryParse(
      valorController.text
          .replaceAll(',', '.'),
    );

    if (tituloController.text.isEmpty ||
        valor == null) {
      return;
    }

    final lancamento =
        LancamentoModel(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),

      titulo:
          tituloController.text.trim(),

      descricao:
          descricaoController.text.trim(),

      valor: valor,

      tipo: tipo,

      categoria:
          categoriaController.text
                  .trim()
                  .isEmpty
              ? 'Geral'
              : categoriaController.text
                    .trim(),

      dataLancamento:
          dataLancamento,

      status: status,

      formaPagamento:
          formaPagamento,

      recorrente: recorrente,

      observacoes:
          observacaoController.text
              .trim(),
    );

    widget.onSalvar(lancamento);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      child: Container(
        width: 650,

        padding:
            const EdgeInsets.all(28),

        decoration: BoxDecoration(
          gradient:
              AppCores.gradienteCard,

          borderRadius:
              BorderRadius.circular(30),

          border: Border.all(
            color:
                AppCores.bordaEscura,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(
                0.45,
              ),

              blurRadius: 40,

              offset:
                  const Offset(0, 20),
            ),
          ],
        ),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            mainAxisSize:
                MainAxisSize.min,

            children: [
              // ===================================================
              // TITULO
              // ===================================================

              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(
                      12,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          AppCores.primaria
                              .withOpacity(
                        0.15,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),

                    child: const Icon(
                      Icons
                          .account_balance_wallet_rounded,

                      color:
                          AppCores.primaria,
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Text(
                      'Novo Lançamento',

                      style: TextStyle(
                        color:
                            AppCores
                                .textoBranco,

                        fontSize: 24,

                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ===================================================
              // TIPO
              // ===================================================

              Row(
                children: [
                  Expanded(
                    child:
                        _cardTipoLancamento(
                      titulo: 'Receita',

                      icon:
                          Icons
                              .trending_up_rounded,

                      ativo:
                          tipo ==
                          TipoLancamento
                              .receita,

                      cor:
                          AppCores.receita,

                      onTap: () {
                        setState(() {
                          tipo =
                              TipoLancamento
                                  .receita;
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child:
                        _cardTipoLancamento(
                      titulo: 'Despesa',

                      icon:
                          Icons
                              .trending_down_rounded,

                      ativo:
                          tipo ==
                          TipoLancamento
                              .despesa,

                      cor:
                          AppCores.despesa,

                      onTap: () {
                        setState(() {
                          tipo =
                              TipoLancamento
                                  .despesa;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ===================================================
              // CAMPOS
              // ===================================================

              _campo(
                controller:
                    tituloController,

                label: 'Título',

                icon:
                    Icons.title_rounded,
              ),

              const SizedBox(height: 18),

              _campo(
                controller:
                    descricaoController,

                label: 'Descrição',

                icon:
                    Icons.notes_rounded,
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: _campo(
                      controller:
                          valorController,

                      label: 'Valor',

                      icon: Icons
                          .attach_money_rounded,
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: _campo(
                      controller:
                          categoriaController,

                      label:
                          'Categoria',

                      icon: Icons
                          .category_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ===================================================
              // FORMA PAGAMENTO
              // ===================================================

              DropdownButtonFormField<
                  String>(
                value: formaPagamento,

                dropdownColor:
                    AppCores.cardEscuro,

                decoration:
                    _inputDecoration(
                  'Forma de pagamento',

                  Icons
                      .credit_card_rounded,
                ),

                style: const TextStyle(
                  color:
                      AppCores.textoBranco,
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'PIX',
                    child: Text('PIX'),
                  ),

                  DropdownMenuItem(
                    value: 'Cartão',
                    child: Text('Cartão'),
                  ),

                  DropdownMenuItem(
                    value: 'Dinheiro',
                    child:
                        Text('Dinheiro'),
                  ),

                  DropdownMenuItem(
                    value: 'Boleto',
                    child: Text('Boleto'),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    formaPagamento =
                        value!;
                  });
                },
              ),

              const SizedBox(height: 18),

              // ===================================================
              // RECORRÊNCIA
              // ===================================================

              SwitchListTile(
                value: recorrente,

                activeColor:
                    AppCores.primaria,

                title: const Text(
                  'Lançamento recorrente',

                  style: TextStyle(
                    color:
                        AppCores
                            .textoBranco,
                  ),
                ),

                onChanged: (value) {
                  setState(() {
                    recorrente = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              _campo(
                controller:
                    observacaoController,

                label: 'Observações',

                icon:
                    Icons.edit_note_rounded,

                maxLines: 4,
              ),

              const SizedBox(height: 30),

              // ===================================================
              // BOTÕES
              // ===================================================

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },

                      style:
                          OutlinedButton.styleFrom(
                        minimumSize:
                            const Size(
                          double.infinity,
                          55,
                        ),

                        side: BorderSide(
                          color: Colors.white
                              .withOpacity(
                            0.08,
                          ),
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      child: const Text(
                        'Cancelar',

                        style: TextStyle(
                          color: AppCores
                              .textoBranco,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: salvar,

                      icon: const Icon(
                        Icons
                            .save_rounded,
                      ),

                      label: const Text(
                        'Salvar',
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppCores.primaria,

                        foregroundColor:
                            Colors.white,

                        minimumSize:
                            const Size(
                          double.infinity,
                          55,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // CAMPO
  // =========================================================

  Widget _campo({
    required TextEditingController
    controller,

    required String label,

    required IconData icon,

    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,

      maxLines: maxLines,

      style: const TextStyle(
        color: AppCores.textoBranco,
      ),

      decoration:
          _inputDecoration(label, icon),
    );
  }

  // =========================================================
  // INPUT DECORATION
  // =========================================================

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,

      labelStyle: const TextStyle(
        color: AppCores.textoCinza,
      ),

      prefixIcon: Icon(
        icon,
        color: AppCores.primaria,
      ),

      filled: true,

      fillColor:
          Colors.white.withOpacity(0.03),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide(
          color:
              Colors.white.withOpacity(
            0.05,
          ),
        ),
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide(
          color:
              Colors.white.withOpacity(
            0.05,
          ),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: const BorderSide(
          color: AppCores.primaria,
        ),
      ),
    );
  }

  // =========================================================
  // CARD TIPO
  // =========================================================

  Widget _cardTipoLancamento({
    required String titulo,

    required IconData icon,

    required bool ativo,

    required Color cor,

    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(20),

      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 250),

        padding:
            const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color:
              ativo
                  ? cor.withOpacity(0.12)
                  : Colors.white
                      .withOpacity(0.03),

          borderRadius:
              BorderRadius.circular(20),

          border: Border.all(
            color:
                ativo
                    ? cor
                    : Colors.white
                        .withOpacity(
                        0.05,
                      ),
          ),
        ),

        child: Column(
          children: [
            Icon(
              icon,
              color: cor,
              size: 30,
            ),

            const SizedBox(height: 10),

            Text(
              titulo,

              style: TextStyle(
                color:
                    ativo
                        ? cor
                        : AppCores
                            .textoBranco,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}