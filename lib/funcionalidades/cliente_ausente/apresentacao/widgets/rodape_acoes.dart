import 'package:flutter/material.dart';

import '../../../../../compartilhado/tema_cores.dart';

class RodapeAcoes extends StatelessWidget {
  final bool carregando;

  final VoidCallback? onCancelar;

  final VoidCallback? onRegistrar;

  const RodapeAcoes({
    super.key,
    required this.carregando,
    required this.onCancelar,
    required this.onRegistrar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          // ==================================================
          // REGISTRAR AUSÊNCIA
          // ==================================================
          SizedBox(
            height: 56,

            child: ElevatedButton.icon(
              onPressed: carregando ? null : onRegistrar,

              style: ElevatedButton.styleFrom(
                elevation: 0,

                backgroundColor: AppCores.ausente,

                disabledBackgroundColor: AppCores.ausente.withOpacity(.45),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              icon: carregando
                  ? const SizedBox(
                      width: 20,
                      height: 20,

                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.assignment_turned_in, color: Colors.white),

              label: Text(
                carregando ? 'Registrando Ausência...' : 'Registrar Ausência',

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ==================================================
          // CANCELAR
          // ==================================================
          SizedBox(
            height: 52,

            child: OutlinedButton.icon(
              onPressed: carregando ? null : onCancelar,

              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(.15)),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              icon: const Icon(Icons.close, color: Colors.white70),

              label: const Text(
                'Cancelar',

                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ==================================================
          // INFORMATIVO
          // ==================================================
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.03),

              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: Colors.white.withOpacity(.05)),
            ),

            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Icon(Icons.info_outline, color: Colors.white54, size: 18),

                SizedBox(width: 8),

                Expanded(
                  child: Text(
                    'Ao registrar a ausência serão salvos os dados da visita, foto da residência e tentativas de contato.',

                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
