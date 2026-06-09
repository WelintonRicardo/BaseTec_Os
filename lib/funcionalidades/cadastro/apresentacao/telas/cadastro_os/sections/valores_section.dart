// lib/funcionalidades/cadastro/apresentacao/telas/cadastro_os/sections/valores_section.dart

import 'package:flutter/material.dart';

import '../widgets/os_card_section.dart';
import '../widgets/os_input_field.dart';
import '../../../../controle/cadastro_os_controller.dart';

class ValoresSection extends StatelessWidget {
  final CadastroOsController controller;

  const ValoresSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return OsCardSection(
      titulo: 'Valores e Observações',
      children: [
        OsInputField(
          controller: controller.infoAdicionaisController,
          label: 'Observações',
          optional: true,
          maxLines: 3,
        ),

        const SizedBox(height: 16),

        OsInputField(
          controller: controller.valorMaoObraController,
          label: 'Valor Mão de Obra',
          keyboardType: TextInputType.number,
          optional: true,
        ),

        const SizedBox(height: 16),

        OsInputField(
          controller: controller.valorDeslocamentoController,
          label: 'Valor Deslocamento',
          keyboardType: TextInputType.number,
          optional: true,
        ),

        const SizedBox(height: 16),

        OsInputField(
          controller: controller.valorPecasController,
          label: 'Valor Peças',
          keyboardType: TextInputType.number,
          optional: true,
        ),
      ],
    );
  }
}