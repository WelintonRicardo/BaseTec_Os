import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';
import '../dominio/modelos/transacao_model.dart';

class ListaTransacoes extends StatelessWidget {
  final List<Transacao> transacoes;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ListaTransacoes({
    super.key,
    required this.transacoes,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    if (transacoes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: const Center(
          child: Text(
            'Nenhuma transação encontrada',
            style: TextStyle(color: AppCores.textoSecundario, fontSize: 15),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: transacoes.length,

      separatorBuilder: (_, __) => const SizedBox(height: 14),

      itemBuilder: (ctx, i) {
        final t = transacoes[i];

        final cor = t.isReceita ? AppCores.receita : AppCores.despesa;

        final prefixo = t.isReceita ? '+ R\$ ' : '- R\$ ';

        return Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),

            borderRadius: BorderRadius.circular(22),

            border: Border.all(color: Colors.white.withOpacity(0.05)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Row(
            children: [
              // ===================================================
              // ÍCONE
              // ===================================================
              Container(
                height: 52,
                width: 52,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: cor.withOpacity(0.12),

                  border: Border.all(color: cor.withOpacity(0.22)),
                ),

                child: Icon(
                  t.isReceita
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: cor,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              // ===================================================
              // INFORMAÇÕES
              // ===================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.descricao,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: AppCores.textoBranco,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
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
                            t.categoria,

                            style: const TextStyle(
                              color: AppCores.textoSecundario,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            _formatarData(t.data),

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: AppCores.textoCinza,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ===================================================
              // VALOR
              // ===================================================
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$prefixo${t.valor.toStringAsFixed(2)}',

                    style: TextStyle(
                      color: cor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    t.isReceita ? 'Receita' : 'Despesa',

                    style: TextStyle(
                      color: cor.withOpacity(0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // DATA FORMATADA
  // =========================================================

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }
}
