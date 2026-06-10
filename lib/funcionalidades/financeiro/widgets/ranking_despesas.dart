import 'package:flutter/material.dart';

import '../../../compartilhado/tema_cores.dart';
import '../aplicacao/financeiro_controller.dart';

class RankingDespesas extends StatelessWidget {
  final FinanceiroController controller;

  const RankingDespesas({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final categorias = controller.agruparPorCategoria();

    // =========================================================
    // ORDENAÇÃO
    // =========================================================

    final listaOrdenada = categorias.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = listaOrdenada.fold<double>(0, (a, b) => a + b.value);

    if (listaOrdenada.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: const Center(
          child: Text(
            'Nenhuma despesa encontrada',
            style: TextStyle(color: AppCores.textoSecundario),
          ),
        ),
      );
    }

    return Column(
      children: listaOrdenada.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        final porcentagem = total == 0 ? 0 : (item.value / total);

        final cor = _corCategoria(index);

        return Container(
          margin: const EdgeInsets.only(bottom: 18),

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),

            borderRadius: BorderRadius.circular(24),

            border: Border.all(color: Colors.white.withOpacity(0.05)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Column(
            children: [
              // =================================================
              // TOPO
              // =================================================
              Row(
                children: [
                  // POSIÇÃO
                  Container(
                    height: 42,
                    width: 42,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: cor.withOpacity(0.12),

                      border: Border.all(color: cor.withOpacity(0.25)),
                    ),

                    child: Center(
                      child: Text(
                        '#${index + 1}',

                        style: TextStyle(
                          color: cor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // INFO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.key,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: AppCores.textoBranco,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          '${(porcentagem * 100).toStringAsFixed(0)}% das despesas',

                          style: const TextStyle(
                            color: AppCores.textoCinza,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // VALOR
                  Text(
                    'R\$ ${item.value.toStringAsFixed(2)}',

                    style: TextStyle(
                      color: cor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // =================================================
              // BARRA
              // =================================================
              ClipRRect(
                borderRadius: BorderRadius.circular(30),

                child: LinearProgressIndicator(
                  value: porcentagem.toDouble(),

                  minHeight: 10,

                  backgroundColor: Colors.white.withOpacity(0.05),

                  valueColor: AlwaysStoppedAnimation<Color>(cor),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ===========================================================
  // CORES RANKING
  // ===========================================================

  Color _corCategoria(int index) {
    switch (index) {
      case 0:
        return AppCores.graficoVerde;

      case 1:
        return AppCores.graficoAzul;

      case 2:
        return AppCores.graficoRoxo;

      case 3:
        return AppCores.graficoLaranja;

      default:
        return AppCores.graficoRosa;
    }
  }
}
