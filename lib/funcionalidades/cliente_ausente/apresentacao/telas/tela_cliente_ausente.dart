import '../../aplicacao/cliente_ausente_controller.dart';
import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

import '../widgets/rodape_acoes.dart';
import '../widgets/secao_foto_residencia.dart';
import '../widgets/cabecalho_cliente_ausente.dart';
import '../widgets/secao_atendimento.dart';
import '../widgets/secao_observacoes.dart';
import '../widgets/secao_contatos.dart';

class TelaClienteAusente extends StatefulWidget {
  final Map<String, dynamic> ordemServico;

  const TelaClienteAusente({super.key, required this.ordemServico});

  @override
  State<TelaClienteAusente> createState() => _TelaClienteAusenteState();
}

class _TelaClienteAusenteState extends State<TelaClienteAusente> {
  late final ClienteAusenteController controller;

  final _formKey = GlobalKey<FormState>();

  bool _salvando = false;

  @override
  void initState() {
    super.initState();

    controller = ClienteAusenteController();

    controller.iniciar();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  // =====================================================
  // REGISTRAR AUSÊNCIA
  // =====================================================

  Future<void> _registrarAusencia() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (controller.fotoResidencia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione uma foto da residência.')),
      );

      return;
    }

    try {
      setState(() {
        _salvando = true;
      });

      final ordemServicoId = widget.ordemServico['id'].toString();

      final tecnicoId = widget.ordemServico['tecnico_id']?.toString() ?? '';

      print('======================');
      print('OS ID: $ordemServicoId');
      print('TECNICO ID: $tecnicoId');
      print('======================');
      await controller.registrarAusencia(
        ordemServicoId: ordemServicoId,
        tecnicoId: tecnicoId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente ausente registrado com sucesso.'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao registrar ausência: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      appBar: AppBar(
        backgroundColor: AppCores.cardEscuro,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Laudo de Cliente Ausente',
          style: TextStyle(
            color: AppCores.textoBranco,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // =====================================
                // ALERTA
                // =====================================
                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(.12),

                    borderRadius: BorderRadius.circular(16),

                    border: Border.all(color: Colors.orange.withOpacity(.30)),
                  ),

                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange),

                      SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          'Registre todas as tentativas de contato antes de confirmar a ausência do cliente.',
                          style: TextStyle(color: AppCores.textoBranco),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =====================================
                // CABEÇALHO
                // =====================================
                CabecalhoClienteAusente(os: widget.ordemServico),

                const SizedBox(height: 16),

                // =====================================
                // DATA / HORÁRIO
                // =====================================
                SecaoAtendimento(
                  dataController: controller.dataController,

                  horarioController: controller.horarioController,
                ),

                const SizedBox(height: 16),

                // =====================================
                // OBSERVAÇÕES
                // =====================================
                SecaoObservacoes(controller: controller.observacaoController),

                const SizedBox(height: 16),

                // =====================================
                // CONTATOS
                // =====================================
                SecaoContatos(controller: controller),

                const SizedBox(height: 16),

                // =====================================
                // FOTO
                // =====================================
                SecaoFotoResidencia(controller: controller),

                const SizedBox(height: 24),

                // =====================================
                // BOTÕES
                // =====================================
                RodapeAcoes(
                  carregando: _salvando,

                  onCancelar: _salvando
                      ? null
                      : () {
                          Navigator.pop(context);
                        },

                  onRegistrar: _salvando ? null : _registrarAusencia,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
