// lib/funcionalidades/cadastro/apresentacao/telas/cadastro_os/sections/dados_cliente_section.dart

import 'package:flutter/material.dart';

import '../../../../controle/cadastro_os_controller.dart';
import '../widgets/os_card_section.dart';
import '../widgets/os_input_field.dart';

class DadosClienteSection extends StatelessWidget {
  final CadastroOsController controller;

  const DadosClienteSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return OsCardSection(
      titulo: 'Dados da O.S',
      children: [
        OsInputField(
          controller: controller.osController,
          label: 'Número da OS',
          validator: controller.validarObrigatorio,
        ),

        const SizedBox(height: 16),

        OsInputField(
          controller: controller.seguradoraController,
          label: 'Seguradora',
          validator: controller.validarObrigatorio,
        ),

        const SizedBox(height: 16),

        OsInputField(
          controller: controller.clienteController,
          label: 'Nome do Cliente',
          validator: controller.validarObrigatorio,
        ),

        const SizedBox(height: 16),

        OsInputField(
          controller: controller.servicoController,
          label: 'Descrição do Serviço',
          hint: 'Descreva o serviço para o técnico',
          maxLines: 3,
          optional: true,
        ),
      ],
    );
  }
}