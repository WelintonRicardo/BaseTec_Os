import 'package:flutter/material.dart';

import 'package:signature/signature.dart';

import '../../../../compartilhado/tema_cores.dart';

class CardAssinaturas extends StatelessWidget {
  final SignatureController assinaturaClienteController;

  final SignatureController assinaturaTecnicoController;

  final VoidCallback onLimparCliente;

  final VoidCallback onLimparTecnico;

  const CardAssinaturas({
    super.key,
    required this.assinaturaClienteController,
    required this.assinaturaTecnicoController,
    required this.onLimparCliente,
    required this.onLimparTecnico,
  });

  Widget _buildAssinatura({
    required String titulo,
    required SignatureController controller,
    required VoidCallback onLimpar,
  }) {
    return Card(
      color: AppCores.cardEscuro,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              titulo,

              style: const TextStyle(
                color: AppCores.textoBranco,

                fontWeight: FontWeight.bold,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              height: 220,

              decoration: BoxDecoration(
                color: AppCores.fundoEscuro,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.white24),
              ),

              child: Signature(
                controller: controller,

                backgroundColor: Colors.transparent,
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,

                minimumSize: const Size(double.infinity, 48),
              ),

              onPressed: onLimpar,

              icon: const Icon(Icons.delete, color: AppCores.textoBranco),

              label: const Text(
                'Limpar assinatura',

                style: TextStyle(color: AppCores.textoBranco),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAssinatura(
          titulo: 'Assinatura do Segurado',

          controller: assinaturaClienteController,

          onLimpar: onLimparCliente,
        ),

        const SizedBox(height: 20),

        _buildAssinatura(
          titulo: 'Assinatura do Técnico',

          controller: assinaturaTecnicoController,

          onLimpar: onLimparTecnico,
        ),
      ],
    );
  }
}
