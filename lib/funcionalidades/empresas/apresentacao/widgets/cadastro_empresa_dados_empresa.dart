import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class CadastroEmpresaDadosEmpresa extends StatelessWidget {
  const CadastroEmpresaDadosEmpresa({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppCores.glass,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppCores.bordaEscura,
        ),
        boxShadow: AppCores.sombraCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITULO DA SEÇÃO
          const Text(
            "Dados da Empresa",
            style: TextStyle(
              color: AppCores.textoPrincipal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          /// GRID RESPONSIVO
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 700;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [

                  _CampoTexto(
                    label: "Razão Social",
                    hint: "Ex: Silva Refrigeração LTDA",
                    width: isMobile ? double.infinity : 500,
                  ),

                  _CampoTexto(
                    label: "Nome Fantasia",
                    hint: "Ex: Silva Refrigeração",
                    width: isMobile ? double.infinity : 300,
                  ),

                  _CampoTexto(
                    label: "CNPJ",
                    hint: "00.000.000/0000-00",
                    width: isMobile ? double.infinity : 300,
                  ),

                  _CampoTexto(
                    label: "Telefone",
                    hint: "(11) 99999-9999",
                    width: isMobile ? double.infinity : 300,
                  ),

                  _CampoTexto(
                    label: "WhatsApp",
                    hint: "(11) 99999-9999",
                    width: isMobile ? double.infinity : 300,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// CAMPO PADRÃO PREMIUM
class _CampoTexto extends StatelessWidget {
  final String label;
  final String hint;
  final double width;

  const _CampoTexto({
    required this.label,
    required this.hint,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            label,
            style: const TextStyle(
              color: AppCores.textoSecundario,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 6),

          TextFormField(
            style: const TextStyle(
              color: AppCores.textoPrincipal,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppCores.textoCinza,
              ),

              filled: true,
              fillColor: AppCores.superficie,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppCores.bordaEscura,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppCores.primaria,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}