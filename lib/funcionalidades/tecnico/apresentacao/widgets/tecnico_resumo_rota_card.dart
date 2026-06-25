import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

class TecnicoResumoRotaCard extends StatelessWidget {
  final int totalAtendimentos;
  final int minutosEstimados;
  final double kmEstimados;
  final bool rotaOtimizada;

  const TecnicoResumoRotaCard({
    super.key,
    required this.totalAtendimentos,
    required this.minutosEstimados,
    required this.kmEstimados,
    required this.rotaOtimizada,
  });

  String _formatarTempo() {
    final horas = minutosEstimados ~/ 60;
    final minutos = minutosEstimados % 60;

    if (horas == 0) {
      return '$minutos min';
    }

    return '${horas}h ${minutos}min';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: AppCores.gradienteCard,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: AppCores.primaria.withOpacity(0.20),
        ),

        boxShadow: AppCores.sombraCard,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Row(
            children: [
              Icon(
                Icons.route,
                color: AppCores.primaria,
              ),

              SizedBox(width: 8),

              Text(
                'ROTAS DE HOJE',
                style: TextStyle(
                  color: AppCores.textoBranco,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _item(
            '📍',
            '$totalAtendimentos atendimentos',
          ),

          const SizedBox(height: 10),

          _item(
            '🕒',
            _formatarTempo(),
          ),

          const SizedBox(height: 10),

          _item(
            '🚗',
            '${kmEstimados.toStringAsFixed(1)} km previstos',
          ),

          const SizedBox(height: 10),

          _item(
            rotaOtimizada ? '✅' : '⚠️',
            rotaOtimizada
                ? 'Sequência otimizada'
                : 'Rota não otimizada',
          ),
        ],
      ),
    );
  }

  Widget _item(
    String emoji,
    String texto,
  ) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 18),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            texto,
            style: const TextStyle(
              color: AppCores.textoBranco,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}