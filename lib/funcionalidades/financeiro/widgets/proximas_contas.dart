import 'package:flutter/material.dart';

import '../../../compartilhado/tema_cores.dart';

class ProximasContas extends StatelessWidget {
  final List<Map<String, dynamic>> contas;

  const ProximasContas({super.key, required this.contas});

  @override
  Widget build(BuildContext context) {
    if (contas.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: const Center(
          child: Text(
            'Nenhuma conta pendente',
            style: TextStyle(color: AppCores.textoSecundario),
          ),
        ),
      );
    }

    final total = contas.fold<double>(0, (a, b) => a + (b['valor'] as double));

    return Column(
      children: [
        // =====================================================
        // TOTAL
        // =====================================================
        Container(
          width: double.infinity,

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppCores.despesa.withOpacity(0.18), Colors.transparent],
            ),

            borderRadius: BorderRadius.circular(24),

            border: Border.all(color: AppCores.despesa.withOpacity(0.15)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total próximo a vencer',

                style: TextStyle(color: AppCores.textoSecundario, fontSize: 14),
              ),

              const SizedBox(height: 10),

              Text(
                'R\$ ${total.toStringAsFixed(2)}',

                style: const TextStyle(
                  color: AppCores.textoBranco,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // =====================================================
        // LISTA
        // =====================================================
        ...contas.map((conta) {
          final cor = _definirCor(conta['descricao']);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),

            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),

              borderRadius: BorderRadius.circular(22),

              border: Border.all(color: Colors.white.withOpacity(0.05)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Row(
              children: [
                // =============================================
                // ÍCONE
                // =============================================
                Container(
                  height: 54,
                  width: 54,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: cor.withOpacity(0.12),

                    border: Border.all(color: cor.withOpacity(0.25)),
                  ),

                  child: Icon(
                    _definirIcone(conta['descricao']),
                    color: cor,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                // =============================================
                // INFORMAÇÕES
                // =============================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conta['descricao'],

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: AppCores.textoBranco,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),

                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Text(
                          'Vencimento: ${conta['data']}',

                          style: const TextStyle(
                            color: AppCores.textoCinza,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // =============================================
                // VALOR
                // =============================================
                Text(
                  'R\$ ${(conta['valor'] as double).toStringAsFixed(2)}',

                  style: TextStyle(
                    color: cor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ===========================================================
  // ÍCONES
  // ===========================================================

  IconData _definirIcone(String descricao) {
    final texto = descricao.toLowerCase();

    if (texto.contains('luz')) {
      return Icons.lightbulb_outline_rounded;
    }

    if (texto.contains('internet')) {
      return Icons.wifi_rounded;
    }

    if (texto.contains('cartão')) {
      return Icons.credit_card_rounded;
    }

    if (texto.contains('água')) {
      return Icons.water_drop_outlined;
    }

    return Icons.receipt_long_rounded;
  }

  // ===========================================================
  // CORES
  // ===========================================================

  Color _definirCor(String descricao) {
    final texto = descricao.toLowerCase();

    if (texto.contains('luz')) {
      return AppCores.graficoLaranja;
    }

    if (texto.contains('internet')) {
      return AppCores.graficoAzul;
    }

    if (texto.contains('cartão')) {
      return AppCores.graficoRoxo;
    }

    if (texto.contains('água')) {
      return AppCores.graficoVerde;
    }

    return AppCores.despesa;
  }
}
