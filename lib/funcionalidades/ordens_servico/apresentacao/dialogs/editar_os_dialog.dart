
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditarOsDialog extends StatefulWidget {
  final Map<String, dynamic> os;

  const EditarOsDialog({
    super.key,
    required this.os,
  });

  @override
  State<EditarOsDialog> createState() => _EditarOsDialogState();
}

class _EditarOsDialogState extends State<EditarOsDialog> {
  final SupabaseClient supabase = Supabase.instance.client;

  late TextEditingController numeroOsController;
  late TextEditingController seguradoController;
  late TextEditingController seguradoraController;
  late TextEditingController telefoneController;
  late TextEditingController cidadeController;
  late TextEditingController bairroController;
  late TextEditingController ruaController;
  late TextEditingController numeroController;
  late TextEditingController complementoController;
  late TextEditingController servicoController;
  late TextEditingController observacaoController;
  late TextEditingController maoObraController;
  late TextEditingController deslocamentoController;
  late TextEditingController pecasController;

  bool salvando = false;

  String status = 'pendente';

  @override
  void initState() {
    super.initState();

    final os = widget.os;

    numeroOsController =
        TextEditingController(text: os['numero_os'] ?? '');

    seguradoController =
        TextEditingController(text: os['nome_segurado'] ?? '');

    seguradoraController =
        TextEditingController(text: os['seguradora'] ?? '');

    telefoneController =
        TextEditingController(text: os['telefone'] ?? '');

    cidadeController =
        TextEditingController(text: os['cidade'] ?? '');

    bairroController =
        TextEditingController(text: os['bairro'] ?? '');

    ruaController =
        TextEditingController(text: os['rua'] ?? '');

    numeroController =
        TextEditingController(text: os['numero'] ?? '');

    complementoController =
        TextEditingController(text: os['complemento'] ?? '');

    servicoController =
        TextEditingController(text: os['descricao_servico'] ?? '');

    observacaoController =
        TextEditingController(
          text: os['informacoes_adicionais'] ?? '',
        );

    maoObraController =
        TextEditingController(
          text: os['valor_mao_obra']?.toString() ?? '',
        );

    deslocamentoController =
        TextEditingController(
          text: os['valor_deslocamento']?.toString() ?? '',
        );

    pecasController =
        TextEditingController(
          text: os['valor_pecas']?.toString() ?? '',
        );

    status = os['status'] ?? 'pendente';
  }

  // =========================================================
  // SALVAR
  // =========================================================

  Future<void> salvar() async {
    try {
      setState(() {
        salvando = true;
      });

      await supabase
          .from('ordens_servico')
          .update({
            'numero_os': numeroOsController.text,
            'nome_segurado': seguradoController.text,
            'seguradora': seguradoraController.text,
            'telefone': telefoneController.text,
            'cidade': cidadeController.text,
            'bairro': bairroController.text,
            'rua': ruaController.text,
            'numero': numeroController.text,
            'complemento': complementoController.text,
            'descricao_servico': servicoController.text,
            'informacoes_adicionais':
                observacaoController.text,
            'valor_mao_obra':
                double.tryParse(maoObraController.text),
            'valor_deslocamento':
                double.tryParse(deslocamentoController.text),
            'valor_pecas':
                double.tryParse(pecasController.text),
            'status': status,
          })
          .eq('id', widget.os['id']);

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OS atualizada com sucesso'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar OS: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 700,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Editar Ordem de Serviço',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                TextField(
                  controller: numeroOsController,
                  decoration: const InputDecoration(
                    labelText: 'Número da OS',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: seguradoController,
                  decoration: const InputDecoration(
                    labelText: 'Segurado',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: seguradoraController,
                  decoration: const InputDecoration(
                    labelText: 'Seguradora',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: telefoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: cidadeController,
                  decoration: const InputDecoration(
                    labelText: 'Cidade',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: bairroController,
                  decoration: const InputDecoration(
                    labelText: 'Bairro',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: ruaController,
                  decoration: const InputDecoration(
                    labelText: 'Rua',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: numeroController,
                  decoration: const InputDecoration(
                    labelText: 'Número',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: complementoController,
                  decoration: const InputDecoration(
                    labelText: 'Complemento',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: servicoController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descrição Serviço',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: observacaoController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Observações',
                  ),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'pendente',
                      child: Text('Pendente'),
                    ),
                    DropdownMenuItem(
                      value: 'agendada',
                      child: Text('Agendada'),
                    ),
                    DropdownMenuItem(
                      value: 'em_execucao',
                      child: Text('Em execução'),
                    ),
                    DropdownMenuItem(
                      value: 'concluida',
                      child: Text('Concluída'),
                    ),
                    DropdownMenuItem(
                      value: 'cancelada',
                      child: Text('Cancelada'),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() {
                      status = v!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: salvando ? null : salvar,
                        child: salvando
                            ? const CircularProgressIndicator()
                            : const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

