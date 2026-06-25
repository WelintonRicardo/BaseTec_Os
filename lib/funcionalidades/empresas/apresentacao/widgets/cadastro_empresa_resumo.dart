import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class CadastroEmpresaResumo extends StatelessWidget {
  final String planoSelecionado;

  const CadastroEmpresaResumo({
    super.key,
    required this.planoSelecionado,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITULO
          const Text(
            "Resumo da sua empresa",
            style: TextStyle(
              color: AppCores.textoPrincipal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Confira os dados antes de criar sua conta.",
            style: TextStyle(
              color: AppCores.textoSecundario,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          /// CARD RESUMO
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppCores.superficie,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppCores.bordaEscura,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _linha("Empresa", "Silva Refrigeração LTDA"),
                _linha("Nome Fantasia", "Silva Refrigeração"),
                _linha("CNPJ", "00.000.000/0000-00"),
                const Divider(color: Colors.white10),
                _linha("Cidade", "São Paulo - SP"),
                _linha("Responsável", "João Silva"),
                const Divider(color: Colors.white10),
                _linha("Plano", _planoLabel(planoSelecionado)),
                _linha("Status", "Ativo após cadastro"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// ALERTA
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppCores.primaria.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppCores.primaria.withOpacity(0.3),
              ),
            ),
            child: const Text(
              "Ao criar a conta, sua empresa terá acesso imediato ao sistema BaseTec OS.",
              style: TextStyle(
                color: AppCores.textoSecundario,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linha(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            label,
            style: const TextStyle(
              color: AppCores.textoCinza,
              fontSize: 12,
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppCores.textoPrincipal,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _planoLabel(String plano) {
    switch (plano) {
      case "starter":
        return "Starter (Grátis)";
      case "enterprise":
        return "Enterprise";
      default:
        return "Professional (R\$ 99/mês)";
    }
  }
}