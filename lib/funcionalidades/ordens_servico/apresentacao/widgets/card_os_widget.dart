import 'package:flutter/material.dart';
import '../../modelos/ordem_servico_modelo.dart';
import '../../modelos/status_os.dart'; // Importante para as regras de status

class CardOSWidget extends StatelessWidget {
  final OrdemServicoModelo os;
  final VoidCallback onTap;

  const CardOSWidget({super.key, required this.os, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Convertemos a String do banco para o nosso Objeto de Status centralizado
    final statusInfo = StatusOS.deString(os.status);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Barra lateral colorida baseada na cor centralizada do status
              Container(
                width: 6, // Aumentei um pouco para dar mais destaque
                height: 50,
                decoration: BoxDecoration(
                  color: statusInfo.cor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'O.S: ${os.numeroAssistencia}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      os.nomeSegurado.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Badge com o nome do status centralizado
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusInfo.cor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        statusInfo.nome,
                        style: TextStyle(
                          color: statusInfo.cor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Ícone centralizado definido no status_os.dart
              Icon(statusInfo.icone, color: statusInfo.cor, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
