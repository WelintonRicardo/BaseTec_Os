import 'package:flutter/material.dart';
import '../../../../../compartilhado/tema_cores.dart';

class MensagemSucessoWidget extends StatelessWidget {
  const MensagemSucessoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(top: 16),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color:
            AppCores.concluido.withOpacity(0.12),

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: AppCores.concluido,
        ),
      ),

      child: const Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppCores.concluido,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              'Técnico cadastrado com sucesso!',
              style: TextStyle(
                color: AppCores.concluido,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}