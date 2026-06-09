// lib/funcionalidades/cadastro/apresentacao/telas/cadastro_os/widgets/os_card_section.dart

import 'package:flutter/material.dart';
import '../../../../../../compartilhado/tema_cores.dart';

class OsCardSection extends StatelessWidget {
  final String titulo;
  final List<Widget> children;

  const OsCardSection({
    super.key,
    required this.titulo,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppCores.cardEscuro.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppCores.bordaEscura,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: AppCores.primaria,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          ...children,
        ],
      ),
    );
  }
}