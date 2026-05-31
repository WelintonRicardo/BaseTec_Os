// lib/funcionalidades/cadastro/apresentacao/telas/tela_cadastro_os.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:basetec_os/compartilhado/formularios/form_template.dart';
import '../../controle/cadastro_os_controller.dart';

class TelaCadastroOS extends StatelessWidget {
  const TelaCadastroOS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CadastroOsController(),
      child: const _TelaCadastroOsBody(),
    );
  }
}

class _TelaCadastroOsBody extends StatefulWidget {
  const _TelaCadastroOsBody({Key? key}) : super(key: key);

  @override
  State<_TelaCadastroOsBody> createState() => _TelaCadastroOsBodyState();
}

class _TelaCadastroOsBodyState extends State<_TelaCadastroOsBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Tipos e técnicos (mock). Ideal: buscar do repositório.
  final List<String> _tiposServico = ['Serviço novo', 'Retorno', 'Conclusão', 'Garantia', 'Emergencial'];
  final List<String> _tecnicosMock = ['Técnico A', 'Técnico B', 'Técnico C'];

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'Não selecionado';
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CadastroOsController>(context);

    return FormTemplate(
      title: 'Cadastro de OS',
      formKey: _formKey,
      submitting: controller.isLoading,
      onClear: () => controller.limpar(),
      onSubmit: () async {
        final ok = await controller.enviar(_formKey);
        if (ok) Navigator.pop(context);
        else if (controller.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(controller.errorMessage!)));
        }
      },
      submitLabel: 'Cadastrar',
      children: [
        // Campos principais
        LabeledField(controller: controller.osController, label: 'Número da OS', validator: controller.validarObrigatorio),
        const SizedBox(height: 12),
        LabeledField(controller: controller.seguradoraController, label: 'Seguradora', validator: controller.validarObrigatorio),
        const SizedBox(height: 12),
        LabeledField(controller: controller.clienteController, label: 'Nome do cliente', validator: controller.validarObrigatorio),
        const SizedBox(height: 12),

        // Novo campo: Serviço (descrição para o técnico)
        LabeledField(
          controller: controller.servicoController,
          label: 'Serviço (descrição para o técnico)',
          optional: true,
          hintText: 'Descreva brevemente o serviço a ser realizado',
          maxLines: 2,
        ),
        const SizedBox(height: 12),

        // Tipo de serviço (ao setar, controller aplica regras automaticamente)
        DropdownField<String>(
          value: controller.tipoServico,
          label: 'Tipo de serviço',
          items: _tiposServico.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (v) {
            controller.tipoServico = v; // setter aplica regra e notifica UI
          },
          validator: (v) => v == null ? 'Selecione o tipo de serviço' : null,
        ),

        const Divider(height: 24),

        // Endereço
        const SectionHeader('Endereço'),
        LabeledField(controller: controller.cepController, label: 'CEP', keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: controller.validarObrigatorio),
        const SizedBox(height: 8),
        LabeledField(controller: controller.cidadeController, label: 'Cidade', validator: controller.validarObrigatorio),
        const SizedBox(height: 8),
        LabeledField(controller: controller.ruaController, label: 'Rua', validator: controller.validarObrigatorio),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(flex: 2, child: LabeledField(controller: controller.numeroController, label: 'Número', keyboardType: TextInputType.number, validator: controller.validarObrigatorio)),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: LabeledField(controller: controller.complementoController, label: 'Complemento (opcional)', optional: true)),
        ]),

        const Divider(height: 24),

        // Agendamento: data, hora início e hora fim
        SectionHeader('Agendamento'),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final hoje = DateTime.now();
                  final data = await showDatePicker(context: context, initialDate: controller.dataAgendamento ?? hoje, firstDate: hoje, lastDate: DateTime(2100));
                  if (data != null) {
                    controller.dataAgendamento = data;
                    controller.notifyListeners();
                  }
                },
                child: Text(controller.dataAgendamento == null ? 'Selecionar data' : DateFormat('dd/MM/yyyy').format(controller.dataAgendamento!)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final hora = await showTimePicker(context: context, initialTime: controller.horaInicio ?? const TimeOfDay(hour: 9, minute: 0));
                  if (hora != null) {
                    controller.horaInicio = hora;
                    controller.notifyListeners();
                  }
                },
                child: Text(controller.horaInicio == null ? 'Hora início' : controller.horaInicio!.format(context)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final hora = await showTimePicker(context: context, initialTime: controller.horaFim ?? const TimeOfDay(hour: 10, minute: 0));
                  if (hora != null) {
                    controller.horaFim = hora;
                    controller.notifyListeners();
                  }
                },
                child: Text(controller.horaFim == null ? 'Hora fim (opcional)' : controller.horaFim!.format(context)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Início: ${_formatDateTime(controller.montarAgendamentoInicio())}\nFim: ${_formatDateTime(controller.montarAgendamentoFim())}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        const Divider(height: 24),

        // Técnico
        DropdownField<String>(
          value: controller.tecnicoSelecionado,
          label: 'Técnico responsável',
          items: _tecnicosMock.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (v) {
            controller.tecnicoSelecionado = v;
            controller.notifyListeners();
          },
          validator: (v) => v == null ? 'Selecione um técnico' : null,
        ),

        const Divider(height: 24),

        // Complementos e valores
        const SectionHeader('Complementos e Valores'),
        LabeledField(controller: controller.infoAdicionaisController, label: 'Informações adicionais (opcional)', optional: true, maxLines: 3, hintText: 'Observações para o técnico'),
        const SizedBox(height: 12),
        LabeledField(controller: controller.valorMaoObraController, label: 'Valor mão de obra (R\$)', keyboardType: const TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\.,]'))], optional: true, hintText: 'Ex: 150.00'),
        const SizedBox(height: 8),
        LabeledField(controller: controller.valorDeslocamentoController, label: 'Valor deslocamento / km (R\$)', keyboardType: const TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\.,]'))], optional: true),
        const SizedBox(height: 8),
        LabeledField(controller: controller.valorPecasController, label: 'Valor peças/outros (R\$)', keyboardType: const TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\.,]'))], optional: true),
      ],
    );
  }
}
