// lib/funcionalidades/cadastro/apresentacao/telas/cadastro_os/sections/endereco_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../controle/cadastro_os_controller.dart';
import '../widgets/os_card_section.dart';
import '../widgets/os_input_field.dart';

class EnderecoSection extends StatelessWidget {
  final CadastroOsController controller;

  const EnderecoSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return OsCardSection(
      titulo: 'Endereço',
      children: [
        OsInputField(
          controller: controller.cepController,
          label: 'CEP',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: controller.validarObrigatorio,
        ),

        const SizedBox(height: 16),

        OsInputField(
          controller: controller.cidadeController,
          label: 'Cidade',
          validator: controller.validarObrigatorio,
        ),

        const SizedBox(height: 16),

        OsInputField(
          controller: controller.ruaController,
          label: 'Rua',
          validator: controller.validarObrigatorio,
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: OsInputField(
                controller: controller.numeroController,
                label: 'Número',
                validator: controller.validarObrigatorio,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              flex: 3,
              child: OsInputField(
                controller: controller.complementoController,
                label: 'Complemento',
                optional: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}