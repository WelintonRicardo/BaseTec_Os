import 'package:flutter/material.dart';

class PdfActionButtons extends StatelessWidget {
  final Color corPrimaria;

  final Color corSecundaria;

  final bool salvando;

  final VoidCallback onVisualizar;

  final VoidCallback onBaixar;

  final VoidCallback onCompartilhar;

  final VoidCallback onSalvar;

  const PdfActionButtons({
    super.key,

    required this.corPrimaria,

    required this.corSecundaria,

    required this.salvando,

    required this.onVisualizar,

    required this.onBaixar,

    required this.onCompartilhar,

    required this.onSalvar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // =====================================
        // PRIMEIRA LINHA
        // =====================================
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,

                  minimumSize: const Size(double.infinity, 54),
                ),

                onPressed: onVisualizar,

                icon: const Icon(Icons.visibility_rounded),

                label: const Text('Visualizar'),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: corSecundaria,

                  minimumSize: const Size(double.infinity, 54),
                ),

                onPressed: onBaixar,

                icon: const Icon(Icons.download_rounded),

                label: const Text('Baixar'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // =====================================
        // COMPARTILHAR
        // =====================================
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,

            minimumSize: const Size(double.infinity, 54),
          ),

          onPressed: onCompartilhar,

          icon: const Icon(Icons.share_rounded),

          label: const Text('Compartilhar PDF'),
        ),

        const SizedBox(height: 14),

        // =====================================
        // SALVAR CONFIG
        // =====================================
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,

            minimumSize: const Size(double.infinity, 56),
          ),

          onPressed: salvando ? null : onSalvar,

          icon: salvando
              ? const SizedBox(
                  width: 18,
                  height: 18,

                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save_rounded),

          label: Text(salvando ? 'Salvando...' : 'Salvar Configurações'),
        ),
      ],
    );
  }
}
