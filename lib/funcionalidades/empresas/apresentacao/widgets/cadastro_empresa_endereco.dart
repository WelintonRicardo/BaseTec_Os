import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class CadastroEmpresaEndereco extends StatelessWidget {
  const CadastroEmpresaEndereco({super.key});

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

          /// TITULO
          const Text(
            "Endereço da Empresa",
            style: TextStyle(
              color: AppCores.textoPrincipal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {

              final isMobile = constraints.maxWidth < 700;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [

                  _CampoTexto(
                    label: "CEP",
                    hint: "00000-000",
                    width: isMobile ? double.infinity : 200,
                  ),

                  _CampoTexto(
                    label: "Estado",
                    hint: "SP",
                    width: isMobile ? double.infinity : 120,
                  ),

                  _CampoTexto(
                    label: "Cidade",
                    hint: "São Paulo",
                    width: isMobile ? double.infinity : 250,
                  ),

                  _CampoTexto(
                    label: "Bairro",
                    hint: "Centro",
                    width: isMobile ? double.infinity : 250,
                  ),

                  _CampoTexto(
                    label: "Rua",
                    hint: "Av. Paulista",
                    width: isMobile ? double.infinity : 400,
                  ),

                  _CampoTexto(
                    label: "Número",
                    hint: "123",
                    width: isMobile ? double.infinity : 120,
                  ),

                  _CampoTexto(
                    label: "Complemento",
                    hint: "Sala 12",
                    width: isMobile ? double.infinity : 250,
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