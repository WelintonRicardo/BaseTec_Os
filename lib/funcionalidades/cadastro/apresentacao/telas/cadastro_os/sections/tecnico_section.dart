// lib/funcionalidades/cadastro/apresentacao/telas/cadastro_os/sections/tecnico_section.dart

import 'package:flutter/material.dart';

import '../../../../controle/cadastro_os_controller.dart';
import '../widgets/os_card_section.dart';

class TecnicoSection extends StatelessWidget {
  final CadastroOsController controller;
  final List<String> tecnicos;

  const TecnicoSection({
    super.key,
    required this.controller,
    required this.tecnicos,
  });

  @override
  Widget build(BuildContext context) {
    return OsCardSection(
      titulo: 'Técnico Responsável',
      children: [
        DropdownButtonFormField<String>(
          value: controller.tecnicoSelecionado,
          dropdownColor: Colors.grey.shade900,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.04),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          items: tecnicos
              .map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(t),
                ),
              )
              .toList(),
          onChanged: (v) {
            controller.tecnicoSelecionado = v;
            controller.notifyListeners();
          },
          validator: (v) =>
              v == null ? 'Selecione um técnico' : null,
        ),
      ],
    );
  }
}