import 'package:flutter/material.dart';

import '../tema_cores.dart';
import 'sidebar_erp.dart';

class LayoutErp extends StatefulWidget {
  final List<Widget> paginas;

  const LayoutErp({super.key, required this.paginas});

  @override
  State<LayoutErp> createState() => _LayoutErpState();
}

class _LayoutErpState extends State<LayoutErp> {
  int paginaAtual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      body: Container(
        decoration: const BoxDecoration(gradient: AppCores.gradienteFundo),

        child: Row(
          children: [
            // =================================================
            // SIDEBAR
            // =================================================
            SidebarErp(
              paginaAtual: paginaAtual,

              onSelecionarPagina: (index) {
                setState(() {
                  paginaAtual = index;
                });
              },
            ),

            // =================================================
            // CONTEÚDO
            // =================================================
            Expanded(
              child: Column(
                children: [
                  // =============================================
                  // HEADER
                  // =============================================
                  Container(
                    height: 80,

                    padding: const EdgeInsets.symmetric(horizontal: 28),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),

                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),

                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'ERP Premium',

                            style: TextStyle(
                              color: AppCores.textoBranco,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // PESQUISA
                        Container(
                          width: 280,
                          height: 46,

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),

                            borderRadius: BorderRadius.circular(16),

                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),

                          child: TextField(
                            style: const TextStyle(color: AppCores.textoBranco),

                            decoration: const InputDecoration(
                              border: InputBorder.none,

                              hintText: 'Pesquisar...',

                              hintStyle: TextStyle(color: AppCores.textoCinza),

                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: AppCores.textoCinza,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        // NOTIFICAÇÃO
                        Container(
                          height: 46,
                          width: 46,

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),

                            borderRadius: BorderRadius.circular(14),

                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),

                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppCores.textoBranco,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =============================================
                  // PÁGINA
                  // =============================================
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),

                      child: Container(
                        key: ValueKey(paginaAtual),

                        child: widget.paginas[paginaAtual],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
