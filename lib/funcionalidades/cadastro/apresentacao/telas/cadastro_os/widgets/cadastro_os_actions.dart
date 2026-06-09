import 'package:flutter/material.dart';

import '../../../../../../compartilhado/tema_cores.dart';

class CadastroOSActions extends StatelessWidget {
  final bool loading;
  final VoidCallback onCancelar;
  final Future<void> Function() onSalvar;

  const CadastroOSActions({
    super.key,
    required this.loading,
    required this.onCancelar,
    required this.onSalvar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        // CANCELAR
        Expanded(
          child: OutlinedButton(
            onPressed: loading ? null : onCancelar,

            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 18,
              ),

              side: BorderSide(
                color: AppCores.bordaEscura,
              ),

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),

            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: AppCores.textoBranco,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // SALVAR
        Expanded(
          child: ElevatedButton(
            onPressed: loading
                ? null
                : () async {
                    await onSalvar();
                  },

            style: ElevatedButton.styleFrom(
              backgroundColor: AppCores.primaria,

              padding: const EdgeInsets.symmetric(
                vertical: 18,
              ),

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),

            child: loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Cadastrar OS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}