import 'package:flutter/material.dart';

import '../sections/agendamento_section.dart';
import '../sections/dados_cliente_section.dart';
import '../sections/endereco_section.dart';
import '../sections/tecnico_section.dart';
import '../sections/valores_section.dart';

class CadastroOSMobile extends StatelessWidget {
  final dynamic controller;

  const CadastroOSMobile({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        DadosClienteSection(
          controller: controller,
        ),

        const SizedBox(height: 20),

        EnderecoSection(
          controller: controller,
        ),

        const SizedBox(height: 20),

        AgendamentoSection(
          controller: controller,
        ),

        const SizedBox(height: 20),

        TecnicoSection(
          controller: controller,
          tecnicos: controller.tecnicos,
        ),

        const SizedBox(height: 20),

        ValoresSection(
          controller: controller,
        ),
      ],
    );
  }
}