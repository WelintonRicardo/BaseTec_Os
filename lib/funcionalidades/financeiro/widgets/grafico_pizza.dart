import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../compartilhado/tema_cores.dart';
import '../aplicacao/financeiro_controller.dart';

class GraficoPizza extends StatefulWidget {
  final FinanceiroController controller;

  const GraficoPizza({super.key, required this.controller});

  @override
  State<GraficoPizza> createState() => _GraficoPizzaState();
}

class _GraficoPizzaState extends State<GraficoPizza> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final dados = widget.controller.agruparPorCategoria();

    final total = dados.values.fold<double>(0, (a, b) => a + b);

    if (dados.isEmpty || total <= 0) {
      return const Center(
        child: Text(
          'Nenhum dado disponível',
          style: TextStyle(color: AppCores.textoSecundario),
        ),
      );
    }

    final categorias = dados.entries.toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;

        return Column(
          children: [
            // =====================================================
            // GRÁFICO
            // =====================================================
            SizedBox(
              height: isMobile ? 280 : 340,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow fundo
                  Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppCores.graficoAzul.withOpacity(0.12),
                          blurRadius: 80,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),

                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            touchedIndex =
                                response?.touchedSection?.touchedSectionIndex ??
                                -1;
                          });
                        },
                      ),

                      sectionsSpace: 4,
                      centerSpaceRadius: isMobile ? 55 : 70,
                      borderData: FlBorderData(show: false),

                      sections: List.generate(categorias.length, (index) {
                        final item = categorias[index];

                        final porcentagem = (item.value / total) * 100;

                        final isTouched = index == touchedIndex;

                        final cor = _corCategoria(item.key);

                        return PieChartSectionData(
                          value: item.value,
                          radius: isTouched ? 115 : 100,
                          title: '${porcentagem.toStringAsFixed(0)}%',

                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: isTouched ? 18 : 14,
                            fontWeight: FontWeight.bold,
                          ),

                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [cor, cor.withOpacity(0.65)],
                          ),

                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.08),
                            width: 2,
                          ),
                        );
                      }),
                    ),
                  ),

                  // =================================================
                  // CENTRO
                  // =================================================
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: AppCores.textoSecundario,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'R\$ ${total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppCores.textoBranco,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // LEGENDAS
            // =====================================================
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 14,
              children: categorias.map((item) {
                final porcentagem = (item.value / total) * 100;

                final cor = _corCategoria(item.key);

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: cor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        item.key,
                        style: const TextStyle(
                          color: AppCores.textoBranco,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        '${porcentagem.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: AppCores.textoSecundario,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // CORES
  // =========================================================

  Color _corCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'moradia':
        return AppCores.graficoAzul;

      case 'alimentação':
        return AppCores.graficoLaranja;

      case 'lazer':
        return AppCores.graficoRoxo;

      case 'receita':
        return AppCores.graficoVerde;

      default:
        return AppCores.graficoRosa;
    }
  }
}
