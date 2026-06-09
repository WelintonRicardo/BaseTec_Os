import 'package:flutter/material.dart';

import '../../../../../../compartilhado/tema_cores.dart';

class CadastroOSHeader extends StatelessWidget {
  const CadastroOSHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: AppCores.cardEscuro,
        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: AppCores.bordaEscura,
        ),
      ),

      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            'Nova Ordem de Serviço',
            style: TextStyle(
              color: AppCores.textoBranco,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Preencha as informações da OS abaixo.',
            style: TextStyle(
              color: AppCores.textoCinza,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}