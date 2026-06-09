import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

class CardStatus extends StatelessWidget {
  final bool reparoEfetuado;

  final String statusFinal;

  final ValueChanged<bool>
      onReparoAlterado;

  final ValueChanged<String>
      onStatusAlterado;

  const CardStatus({
    super.key,
    required this.reparoEfetuado,
    required this.statusFinal,
    required this.onReparoAlterado,
    required this.onStatusAlterado,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 20),

        // =====================================
        // STATUS FINAL
        // =====================================

        Card(
          color: AppCores.cardEscuro,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),

          child: Padding(
            padding:
                const EdgeInsets.all(
              16,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                const Text(
                  'Status Final',

                  style: TextStyle(
                    color: AppCores
                        .textoBranco,

                    fontWeight:
                        FontWeight
                            .bold,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                DropdownButtonFormField<
                    String>(
                  value:
                      statusFinal,

                  dropdownColor:
                      AppCores
                          .cardEscuro,

                  style:
                      const TextStyle(
                    color: AppCores
                        .textoBranco,
                  ),

                  decoration:
                      InputDecoration(
                    filled: true,

                    fillColor:
                        AppCores
                            .fundoEscuro,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value:
                          'concluido',

                      child: Text(
                        'Concluído',
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          'aguardando_peca',

                      child: Text(
                        'Aguardando peça',
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          'cliente_ausente',

                      child: Text(
                        'Cliente ausente',
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          'retorno_tecnico',

                      child: Text(
                        'Retorno técnico',
                      ),
                    ),
                  ],

                  onChanged: (
                    value,
                  ) {
                    if (value != null) {
                      onStatusAlterado(
                        value,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}