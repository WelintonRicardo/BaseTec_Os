import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class SecaoObservacoes extends StatelessWidget {
  final TextEditingController controller;

  const SecaoObservacoes({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppCores.cardEscuro,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: TextFormField(
          controller: controller,
          maxLines: 6,

          decoration: const InputDecoration(
            labelText: 'Observações do técnico',
          ),
        ),
      ),
    );
  }
}