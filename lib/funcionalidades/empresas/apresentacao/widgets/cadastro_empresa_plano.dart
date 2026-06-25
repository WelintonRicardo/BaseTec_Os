import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class CadastroEmpresaPlano extends StatefulWidget {
  const CadastroEmpresaPlano({super.key});

  @override
  State<CadastroEmpresaPlano> createState() => _CadastroEmpresaPlanoState();
}

class _CadastroEmpresaPlanoState extends State<CadastroEmpresaPlano> {

  String planoSelecionado = "professional";

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
            "Escolha seu plano",
            style: TextStyle(
              color: AppCores.textoPrincipal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Você pode alterar ou fazer upgrade a qualquer momento.",
            style: TextStyle(
              color: AppCores.textoSecundario,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {

              final isMobile = constraints.maxWidth < 900;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [

                  _PlanoCard(
                    titulo: "Starter",
                    descricao: "Para pequenas operações",
                    preco: "Grátis",
                    beneficios: const [
                      "Até 2 usuários",
                      "Gestão básica de OS",
                      "Suporte padrão",
                    ],
                    ativo: planoSelecionado == "starter",
                    onTap: () {
                      setState(() => planoSelecionado = "starter");
                    },
                    width: isMobile ? double.infinity : 280,
                  ),

                  _PlanoCard(
                    titulo: "Professional",
                    descricao: "Para empresas em crescimento",
                    preco: "R\$ 99/mês",
                    beneficios: const [
                      "Até 10 usuários",
                      "Gestão completa de OS",
                      "Relatórios avançados",
                      "Suporte prioritário",
                    ],
                    ativo: planoSelecionado == "professional",
                    destaque: true,
                    onTap: () {
                      setState(() => planoSelecionado = "professional");
                    },
                    width: isMobile ? double.infinity : 280,
                  ),

                  _PlanoCard(
                    titulo: "Enterprise",
                    descricao: "Para grandes operações",
                    preco: "Sob consulta",
                    beneficios: const [
                      "Usuários ilimitados",
                      "API personalizada",
                      "Suporte dedicado",
                      "Implantação assistida",
                    ],
                    ativo: planoSelecionado == "enterprise",
                    onTap: () {
                      setState(() => planoSelecionado = "enterprise");
                    },
                    width: isMobile ? double.infinity : 280,
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

/// CARD DE PLANO
class _PlanoCard extends StatelessWidget {

  final String titulo;
  final String descricao;
  final String preco;
  final List<String> beneficios;
  final bool ativo;
  final bool destaque;
  final VoidCallback onTap;
  final double width;

  const _PlanoCard({
    required this.titulo,
    required this.descricao,
    required this.preco,
    required this.beneficios,
    required this.ativo,
    required this.onTap,
    required this.width,
    this.destaque = false,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppCores.superficie,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ativo
                ? AppCores.primaria
                : AppCores.bordaEscura,
            width: ativo ? 2 : 1,
          ),
          boxShadow: ativo
              ? AppCores.sombraCard
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// BADGE
            if (destaque)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppCores.primaria,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Mais escolhido",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),

            if (destaque) const SizedBox(height: 10),

            Text(
              titulo,
              style: const TextStyle(
                color: AppCores.textoPrincipal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              descricao,
              style: const TextStyle(
                color: AppCores.textoSecundario,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              preco,
              style: const TextStyle(
                color: AppCores.textoPrincipal,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...beneficios.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [

                    const Icon(
                      Icons.check,
                      size: 14,
                      color: AppCores.concluido,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(
                          color: AppCores.textoSecundario,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}