import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class CadastroEmpresaHeader extends StatelessWidget {
  const CadastroEmpresaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppCores.glass,
        border: Border.all(
          color: AppCores.bordaEscura,
        ),
        boxShadow: AppCores.sombraCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IDENTIDADE
          Row(
            children: const [
              Icon(
                Icons.apartment_rounded,
                color: AppCores.textoBranco,
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                "BaseTec OS",
                style: TextStyle(
                  color: AppCores.textoBranco,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// TITULO
          const Text(
            "Cadastre sua empresa",
            style: TextStyle(
              color: AppCores.textoPrincipal,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          /// SUBTITULO
          const Text(
            "Comece a organizar atendimentos, ordens de serviço e sua operação em um só lugar.",
            style: TextStyle(
              color: AppCores.textoSecundario,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          /// PROGRESSO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Progresso do cadastro",
                    style: TextStyle(
                      color: AppCores.textoCinza,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "10%",
                    style: TextStyle(
                      color: AppCores.textoCinza,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// PROGRESS BAR
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppCores.superficie,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: AppCores.gradienteCard,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}