import 'package:flutter/material.dart';
import '../../../../../compartilhado/tema_cores.dart';

class HeaderTecnicoWidget extends StatelessWidget {
  const HeaderTecnicoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            color:
                AppCores.primaria.withOpacity(0.12),

            borderRadius:
                BorderRadius.circular(18),
          ),

          child: Icon(
            Icons.engineering,
            color: AppCores.primaria,
            size: 32,
          ),
        ),

        const SizedBox(width: 18),

        const Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "Novo Técnico",
                style: TextStyle(
                  color: AppCores.textoBranco,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 4),

              Text(
                "Cadastre um novo técnico para sua empresa.",
                style: TextStyle(
                  color: AppCores.textoCinza,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}