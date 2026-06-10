import 'package:flutter/material.dart';

import '../../../compartilhado/tema_cores.dart';
import '../aplicacao/financeiro_controller.dart';

class SaldoMeta extends StatelessWidget {
  final FinanceiroController controller;
  final double metaMensal;

  const SaldoMeta({
    super.key,
    required this.controller,
    required this.metaMensal,
  });

  @override
  Widget build(BuildContext context) {
    final saldo = controller.saldo;

    final double progresso = (saldo / metaMensal).clamp(0, 1).toDouble();

    final bool metaBatida = saldo >= metaMensal;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppCores.gradienteCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppCores.bordaEscura),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // TOPO
          // =====================================================
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppCores.receita.withOpacity(0.12),
                  border: Border.all(color: AppCores.receita.withOpacity(0.25)),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppCores.receita,
                  size: 30,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Saldo Atual',
                      style: TextStyle(
                        color: AppCores.textoSecundario,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Meta financeira mensal',
                      style: TextStyle(
                        color: AppCores.textoCinza,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // =====================================================
          // SALDO
          // =====================================================
          Text(
            'R\$ ${saldo.toStringAsFixed(2)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppCores.textoBranco,
              fontSize: 38,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Text(
                'Meta mensal:',
                style: TextStyle(color: AppCores.textoSecundario, fontSize: 14),
              ),

              const SizedBox(width: 8),

              Text(
                'R\$ ${metaMensal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppCores.textoBranco,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // =====================================================
          // PROGRESSO
          // =====================================================
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 14,
              child: LinearProgressIndicator(
                value: progresso,
                backgroundColor: Colors.white.withOpacity(0.05),
                valueColor: AlwaysStoppedAnimation<Color>(
                  metaBatida ? AppCores.receita : AppCores.graficoAzul,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // =====================================================
          // STATUS
          // =====================================================
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: metaBatida
                      ? AppCores.receita.withOpacity(0.12)
                      : AppCores.graficoAzul.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  metaBatida
                      ? 'Meta atingida'
                      : '${(progresso * 100).toStringAsFixed(0)}% atingido',
                  style: TextStyle(
                    color: metaBatida ? AppCores.receita : AppCores.graficoAzul,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),

              const Spacer(),

              Text(
                '${(metaMensal - saldo).clamp(0, double.infinity).toStringAsFixed(2)} restantes',
                style: const TextStyle(
                  color: AppCores.textoCinza,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
