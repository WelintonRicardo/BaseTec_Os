import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class CadastroEmpresaResponsavel extends StatelessWidget {
  const CadastroEmpresaResponsavel({super.key});

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
            "Responsável da Conta",
            style: TextStyle(
              color: AppCores.textoPrincipal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Essa será a conta administrativa principal da empresa.",
            style: TextStyle(
              color: AppCores.textoSecundario,
              fontSize: 13,
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
                    label: "Nome completo",
                    hint: "Ex: João Silva",
                    width: isMobile ? double.infinity : 400,
                  ),

                  _CampoTexto(
                    label: "E-mail",
                    hint: "admin@empresa.com",
                    width: isMobile ? double.infinity : 300,
                  ),

                  _CampoTexto(
                    label: "Telefone",
                    hint: "(11) 99999-9999",
                    width: isMobile ? double.infinity : 250,
                  ),

                  _CampoSenha(
                    label: "Senha",
                    hint: "Crie uma senha segura",
                    width: isMobile ? double.infinity : 300,
                  ),

                  _CampoSenha(
                    label: "Confirmar senha",
                    hint: "Repita a senha",
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

/// CAMPO TEXTO PADRÃO
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

/// CAMPO SENHA (com ícone futuro preparado)
class _CampoSenha extends StatelessWidget {
  final String label;
  final String hint;
  final double width;

  const _CampoSenha({
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
            obscureText: true,
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