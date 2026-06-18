import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class SecaoAtendimento extends StatelessWidget {
  final TextEditingController dataController;
  final TextEditingController horarioController;

  const SecaoAtendimento({
    super.key,
    required this.dataController,
    required this.horarioController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppCores.cardEscuro,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Atendimento',
              style: TextStyle(
                color: AppCores.textoBranco,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: dataController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Data',
              ),
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: horarioController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Horário',
              ),
            ),
          ],
        ),
      ),
    );
  }
}