import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controle/checklist_cubit.dart';
import '../../modelos/checklist_modelo.dart';

import '../widgets/modal_assinatura_widget.dart';

class TelaChecklistDinamico extends StatelessWidget {
  final String osId;

  const TelaChecklistDinamico({
    super.key,
    required this.osId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChecklistCubit(),

      child: Scaffold(
        appBar: AppBar(
          title: const Text("Finalizar Atendimento"),
          centerTitle: true,
        ),

        body: BlocConsumer<ChecklistCubit, ChecklistState>(
          listener: (context, state) {
            // =====================================
            // SUCESSO
            // =====================================

            if (state is ChecklistSucesso) {
              print('================================');
              print('CHECKLIST FINALIZADO COM SUCESSO');
              print('================================');

              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "O.S. Concluída com Sucesso!",
                  ),

                  backgroundColor: Colors.green,
                ),
              );
            }

            // =====================================
            // ERRO
            // =====================================

            if (state is ChecklistErro) {
              print('================================');
              print('ERRO CHECKLIST');
              print(state.mensagem);
              print('================================');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.mensagem),

                  backgroundColor: Colors.red,
                ),
              );
            }
          },

          builder: (context, state) {
            final cubit = context.read<ChecklistCubit>();

            return Column(
              children: [
                // =====================================
                // TOPO
                // =====================================

                const Padding(
                  padding: EdgeInsets.all(16.0),

                  child: Text(
                    "Responda ao checklist abaixo para liberar a finalização:",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),

                // =====================================
                // LISTA CHECKLIST
                // =====================================

                Expanded(
                  child: ListView.builder(
                    itemCount: cubit.perguntas.length,

                    itemBuilder: (context, index) {
                      final item = cubit.perguntas[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),

                        child: ListTile(
                          title: Text(
                            item.pergunta,

                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              _botaoEscolha(
                                context,
                                index,
                                "Sim",
                                item.resposta == "Sim",
                              ),

                              const SizedBox(width: 8),

                              _botaoEscolha(
                                context,
                                index,
                                "Não",
                                item.resposta == "Não",
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // =====================================
                // BOTAO FINALIZAR
                // =====================================

                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),

                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(55),

                      backgroundColor: Colors.green[700],

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: state is ChecklistEnviando
                        ? null
                        : () => _iniciarAssinatura(context),

                    icon: state is ChecklistEnviando
                        ? const SizedBox(
                            width: 20,
                            height: 20,

                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.draw,
                            color: Colors.white,
                          ),

                    label: Text(
                      state is ChecklistEnviando
                          ? "PROCESSANDO..."
                          : "COLETAR ASSINATURA E FINALIZAR",

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =====================================
  // BOTAO ESCOLHA
  // =====================================

  Widget _botaoEscolha(
    BuildContext context,
    int index,
    String valor,
    bool selecionado,
  ) {
    return ChoiceChip(
      label: Text(valor),

      selected: selecionado,

      selectedColor:
          valor == "Sim"
              ? Colors.green[100]
              : Colors.red[100],

      onSelected: (bool selected) {
        if (selected) {
          final cubit =
              context.read<ChecklistCubit>();

          cubit.atualizarResposta(
            index,
            valor,
          );

          print('================================');
          print('CHECKLIST ALTERADO');
          print('INDEX: $index');
          print('VALOR: $valor');

          for (final item in cubit.perguntas) {
            print(
              '${item.pergunta} => ${item.resposta}',
            );
          }

          print('================================');

          (context as Element).markNeedsBuild();
        }
      },
    );
  }

  // =====================================
  // ASSINATURA
  // =====================================

  void _iniciarAssinatura(
    BuildContext context,
  ) async {
    final cubit =
        context.read<ChecklistCubit>();

    // =====================================
    // VALIDACAO
    // =====================================

    if (cubit.perguntas.any(
      (p) => p.resposta.isEmpty,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Por favor, responda todas as perguntas!",
          ),
        ),
      );

      return;
    }

    print('================================');
    print('CHECKLIST ANTES FINALIZAR');
    print('OS ID: $osId');

    final checklistFormatado =
        cubit.perguntas.map((item) {
      return {
        'titulo': item.pergunta,
        'checked': item.resposta == 'Sim',
        'resposta': item.resposta,
      };
    }).toList();

    print(checklistFormatado);
    print('================================');

    // =====================================
    // MODAL ASSINATURA
    // =====================================

    final resultado = await Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) =>
            const ModalAssinaturaWidget(),
      ),
    );

    // =====================================
    // FINALIZAR
    // =====================================

    if (resultado != null && resultado is Map) {
      final nome =
          resultado['nome'];

      print('================================');
      print('NOME CLIENTE');
      print(nome);
      print('================================');

      cubit.finalizarAtendimento(
        osId,
        nome,
      );
    }
  }
}