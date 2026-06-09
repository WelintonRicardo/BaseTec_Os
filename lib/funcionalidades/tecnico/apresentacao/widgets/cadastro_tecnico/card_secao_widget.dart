import 'package:flutter/material.dart';
import '../../../../../compartilhado/tema_cores.dart';

class CardSecaoWidget extends StatelessWidget {
  final String titulo;
  final List<Widget> children;

  const CardSecaoWidget({
    super.key,
    required this.titulo,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: AppCores.fundoEscuro.withOpacity(0.28),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: AppCores.bordaEscura,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            titulo,
            style: TextStyle(
              color: AppCores.primaria,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ...children,
        ],
      ),
    );
  }
}