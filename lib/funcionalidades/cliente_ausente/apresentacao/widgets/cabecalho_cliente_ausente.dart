import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class CabecalhoClienteAusente extends StatelessWidget {
  final Map<String, dynamic> os;

  const CabecalhoClienteAusente({
    super.key,
    required this.os,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppCores.cardEscuro,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.assignment_outlined,
            color: AppCores.primaria,
            size: 40,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'OS: ${os['numero_os']}',
                  style: const TextStyle(
                    color: AppCores.textoBranco,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  os['cliente'] ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),

                Text(
                  os['rua'] ?? '',
                  style: const TextStyle(
                    color: Colors.white54,
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