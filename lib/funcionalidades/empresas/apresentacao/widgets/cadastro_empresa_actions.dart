import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class CadastroEmpresaActions extends StatelessWidget {
  final bool loading;
  final VoidCallback onCancelar;
  final VoidCallback onSalvar;

  const CadastroEmpresaActions({
    super.key,
    required this.loading,
    required this.onCancelar,
    required this.onSalvar,
  });

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
        children: [

          /// ALERTA FINAL
          const Text(
            "Revise seus dados antes de continuar",
            style: TextStyle(
              color: AppCores.textoSecundario,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [

              /// CANCELAR
              Expanded(
                child: OutlinedButton(
                  onPressed: loading ? null : onCancelar,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppCores.bordaEscura,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(
                      color: AppCores.textoSecundario,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// CRIAR CONTA
              Expanded(
                child: ElevatedButton(
                  onPressed: loading ? null : onSalvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.primaria,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Criar empresa",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// TEXTO DE SEGURANÇA
          const Text(
            "Ao criar a conta, você concorda com os termos de uso e política de privacidade.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppCores.textoCinza,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}