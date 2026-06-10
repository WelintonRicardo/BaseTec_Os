import 'package:flutter/material.dart';

import '../tema_cores.dart';

class SidebarErp extends StatefulWidget {
  final int paginaAtual;
  final Function(int) onSelecionarPagina;

  const SidebarErp({
    super.key,
    required this.paginaAtual,
    required this.onSelecionarPagina,
  });

  @override
  State<SidebarErp> createState() => _SidebarErpState();
}

class _SidebarErpState extends State<SidebarErp> {
  bool expandido = true;

  final List<Map<String, dynamic>> menus = [
    {'titulo': 'Dashboard', 'icone': Icons.dashboard_rounded},
    {'titulo': 'Lançamentos', 'icone': Icons.receipt_long_rounded},
    {'titulo': 'Receitas', 'icone': Icons.trending_up_rounded},
    {'titulo': 'Despesas', 'icone': Icons.trending_down_rounded},
    {'titulo': 'Contas Recorrentes', 'icone': Icons.autorenew_rounded},
    {'titulo': 'Fluxo de Caixa', 'icone': Icons.bar_chart_rounded},
    {'titulo': 'Relatórios', 'icone': Icons.insert_chart_rounded},
    {'titulo': 'Automação', 'icone': Icons.auto_awesome_rounded},
    {'titulo': 'Configurações', 'icone': Icons.settings_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),

      width: expandido ? 280 : 95,

      decoration: BoxDecoration(
        gradient: AppCores.gradienteCard,

        border: Border(
          right: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 25,
            offset: const Offset(4, 0),
          ),
        ],
      ),

      child: Column(
        children: [
          // ===================================================
          // TOPO
          // ===================================================
          Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 18),

            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),

                    gradient: const LinearGradient(
                      colors: [AppCores.primaria, AppCores.graficoAzul],
                    ),
                  ),

                  child: const Icon(
                    Icons.stacked_line_chart_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                if (expandido) ...[
                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WP Finance',

                          style: TextStyle(
                            color: AppCores.textoBranco,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'ERP Premium',

                          style: TextStyle(
                            color: AppCores.textoCinza,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                InkWell(
                  borderRadius: BorderRadius.circular(12),

                  onTap: () {
                    setState(() {
                      expandido = !expandido;
                    });
                  },

                  child: Container(
                    padding: const EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Icon(
                      expandido ? Icons.menu_open_rounded : Icons.menu_rounded,

                      color: AppCores.textoBranco,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Colors.white.withOpacity(0.05), height: 1),

          const SizedBox(height: 18),

          // ===================================================
          // MENUS
          // ===================================================
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),

              itemCount: menus.length,

              itemBuilder: (context, index) {
                final item = menus[index];

                final ativo = widget.paginaAtual == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),

                    onTap: () {
                      widget.onSelecionarPagina(index);
                    },

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),

                        gradient: ativo
                            ? LinearGradient(
                                colors: [
                                  AppCores.primaria.withOpacity(0.22),
                                  AppCores.graficoAzul.withOpacity(0.10),
                                ],
                              )
                            : null,

                        border: Border.all(
                          color: ativo
                              ? AppCores.primaria.withOpacity(0.25)
                              : Colors.transparent,
                        ),
                      ),

                      child: Row(
                        children: [
                          Icon(
                            item['icone'],

                            color: ativo
                                ? AppCores.textoBranco
                                : AppCores.textoCinza,

                            size: 24,
                          ),

                          if (expandido) ...[
                            const SizedBox(width: 16),

                            Expanded(
                              child: Text(
                                item['titulo'],

                                style: TextStyle(
                                  color: ativo
                                      ? AppCores.textoBranco
                                      : AppCores.textoCinza,

                                  fontSize: 15,

                                  fontWeight: ativo
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ===================================================
          // RODAPÉ
          // ===================================================
          Padding(
            padding: const EdgeInsets.all(18),

            child: Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),

                borderRadius: BorderRadius.circular(20),

                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),

              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppCores.primaria,

                    child: const Icon(Icons.person, color: Colors.white),
                  ),

                  if (expandido) ...[
                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Administrador',

                            style: TextStyle(
                              color: AppCores.textoBranco,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'Plano Premium',

                            style: TextStyle(
                              color: AppCores.textoCinza,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
