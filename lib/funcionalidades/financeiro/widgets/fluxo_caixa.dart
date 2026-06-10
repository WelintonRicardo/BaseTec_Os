import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../compartilhado/tema_cores.dart';
import '../aplicacao/financeiro_controller.dart';

class FluxoCaixa extends StatelessWidget {
  final FinanceiroController controller;

  const FluxoCaixa({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final receitasPorMes =
        controller.agruparPorMes(receitas: true);

    final despesasPorMes =
        controller.agruparPorMes(receitas: false);

    final receitas = receitasPorMes.entries
        .map(
          (e) => FlSpot(
            e.key.toDouble(),
            e.value,
          ),
        )
        .toList();

    final despesas = despesasPorMes.entries
        .map(
          (e) => FlSpot(
            e.key.toDouble(),
            e.value,
          ),
        )
        .toList();

    final maxY = [
      ...receitas.map((e) => e.y),
      ...despesas.map((e) => e.y),
    ].fold<double>(
      0,
      (prev, element) =>
          element > prev ? element : prev,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return LineChart(
          LineChartData(
            minY: 0,

            maxY: maxY == 0 ? 100 : maxY * 1.2,

            clipData: FlClipData.all(),

            backgroundColor: Colors.transparent,

            // ===================================================
            // GRID
            // ===================================================

            gridData: FlGridData(
              show: true,

              drawVerticalLine: false,

              horizontalInterval: maxY <= 1000
                  ? 250
                  : maxY <= 5000
                      ? 1000
                      : 2000,

              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white.withOpacity(0.05),
                  strokeWidth: 1,
                );
              },
            ),

            // ===================================================
            // BORDAS
            // ===================================================

            borderData: FlBorderData(
              show: false,
            ),

            // ===================================================
            // TITULOS
            // ===================================================

            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles:
                    SideTitles(showTitles: false),
              ),

              rightTitles: AxisTitles(
                sideTitles:
                    SideTitles(showTitles: false),
              ),

              // ===============================================
              // TITULOS ESQUERDA
              // ===============================================

              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,

                  reservedSize: isMobile ? 42 : 55,

                  interval: maxY <= 1000
                      ? 250
                      : maxY <= 5000
                          ? 1000
                          : 2000,

                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        right: 10,
                      ),
                      child: Text(
                        'R\$ ${value.toInt()}',
                        style: TextStyle(
                          color:
                              Colors.white.withOpacity(
                            0.45,
                          ),
                          fontSize:
                              isMobile ? 10 : 12,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ===============================================
              // TITULOS ABAIXO
              // ===============================================

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,

                  reservedSize: 40,

                  interval: 1,

                  getTitlesWidget: (value, meta) {
                    const meses = [
                      '',
                      'Jan',
                      'Fev',
                      'Mar',
                      'Abr',
                      'Mai',
                      'Jun',
                      'Jul',
                      'Ago',
                      'Set',
                      'Out',
                      'Nov',
                      'Dez',
                    ];

                    final index = value.toInt();

                    if (index < 1 ||
                        index >= meses.length) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        meses[index],
                        style: TextStyle(
                          color:
                              Colors.white.withOpacity(
                            0.55,
                          ),
                          fontSize:
                              isMobile ? 10 : 12,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ===================================================
            // TOOLTIP
            // ===================================================

            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,

              touchTooltipData: LineTouchTooltipData(
                

                tooltipPadding:
                    const EdgeInsets.all(12),

                tooltipMargin: 12,

                getTooltipColor: (_) =>
                    AppCores.cardEscuro,

                getTooltipItems:
                    (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final isReceita =
                        spot.barIndex == 0;

                    return LineTooltipItem(
                      '${isReceita ? 'Receita' : 'Despesa'}\nR\$ ${spot.y.toStringAsFixed(2)}',

                      TextStyle(
                        color: isReceita
                            ? AppCores.receita
                            : AppCores.despesa,

                        fontWeight:
                            FontWeight.bold,
                        fontSize: 13,
                      ),
                    );
                  }).toList();
                },
              ),
            ),

            // ===================================================
            // LINHAS
            // ===================================================

            lineBarsData: [
              // ===============================================
              // RECEITAS
              // ===============================================

              LineChartBarData(
                spots: receitas,

                isCurved: true,

                curveSmoothness: 0.35,

                preventCurveOverShooting: true,

                gradient: const LinearGradient(
                  colors: [
                    AppCores.graficoVerde,
                    AppCores.receita,
                  ],
                ),

                barWidth: 4,

                isStrokeCapRound: true,

                belowBarData: BarAreaData(
                  show: true,

                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppCores.receita
                          .withOpacity(0.25),

                      AppCores.receita
                          .withOpacity(0.02),
                    ],
                  ),
                ),

                dotData: FlDotData(
                  show: true,

                  getDotPainter:
                      (spot, percent, bar, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppCores.receita,
                      strokeWidth: 2,
                      strokeColor:
                          AppCores.textoBranco,
                    );
                  },
                ),
              ),

              // ===============================================
              // DESPESAS
              // ===============================================

              LineChartBarData(
                spots: despesas,

                isCurved: true,

                curveSmoothness: 0.35,

                preventCurveOverShooting: true,

                gradient: const LinearGradient(
                  colors: [
                    AppCores.despesa,
                    AppCores.graficoRosa,
                  ],
                ),

                barWidth: 4,

                isStrokeCapRound: true,

                belowBarData: BarAreaData(
                  show: true,

                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppCores.despesa
                          .withOpacity(0.20),

                      AppCores.despesa
                          .withOpacity(0.02),
                    ],
                  ),
                ),

                dotData: FlDotData(
                  show: true,

                  getDotPainter:
                      (spot, percent, bar, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppCores.despesa,
                      strokeWidth: 2,
                      strokeColor:
                          AppCores.textoBranco,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}