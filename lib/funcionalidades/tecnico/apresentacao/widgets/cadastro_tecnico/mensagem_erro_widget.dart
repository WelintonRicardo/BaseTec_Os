import 'package:flutter/material.dart';
import '../../../../../compartilhado/tema_cores.dart';

class MensagemErroWidget extends StatelessWidget {
  final String mensagem;

  const MensagemErroWidget({
    super.key,
    required this.mensagem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color:
            AppCores.cancelado.withOpacity(0.12),

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: AppCores.cancelado,
        ),
      ),

      child: Text(
        mensagem,
        style: const TextStyle(
          color: AppCores.cancelado,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}