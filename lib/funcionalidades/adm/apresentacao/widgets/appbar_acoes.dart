import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

import '../../../tecnico/apresentacao/telas/tela_cadastro_tecnico.dart';
import '../../../tecnico/dados/servicos/tecnico_controller.dart';

import '../../../../compartilhado/pdf/apresentacao/tela_central_pdf.dart';

import '../../../dashboard/apresentacao/telas/tela_configuracoes.dart';

import '../../../financeiro/apresentacao/telas/tela_financeiro.dart';

import '../../../../compartilhado/layouts/layout_erp.dart';

List<Widget> buildAppBarActions(BuildContext context) {
  return [
    // =========================================================
    // NOTIFICAÇÕES
    // =========================================================
    IconButton(
      tooltip: 'Notificações',

      icon: const Icon(
        Icons.notifications_none_rounded,
        color: AppCores.textoBranco,
      ),

      onPressed: () {},
    ),

    // =========================================================
    // MENU
    // =========================================================
    PopupMenuButton<String>(
      color: AppCores.cardEscuro,

      icon: const Icon(Icons.more_vert_rounded, color: AppCores.textoBranco),

      onSelected: (value) => _onMenuSelected(context, value),

      itemBuilder: (context) => [
        _buildMenuItem(
          value: 'cad_tecnico',
          texto: 'Cadastrar Técnico',
          icon: Icons.person_add_alt_1_rounded,
        ),

        _buildMenuItem(
          value: 'central_pdf',
          texto: 'Central PDF',
          icon: Icons.picture_as_pdf_rounded,
        ),

        _buildMenuItem(
          value: 'config',
          texto: 'Configurações',
          icon: Icons.settings_rounded,
        ),

        // =====================================================
        // ERP FINANCEIRO
        // =====================================================
        _buildMenuItem(
          value: 'financeiro',
          texto: 'Central Financeira',
          icon: Icons.account_balance_wallet_rounded,
        ),

        _buildMenuItem(
          value: 'relatorio',
          texto: 'Relatórios',
          icon: Icons.bar_chart_rounded,
        ),

        const PopupMenuDivider(),

        _buildMenuItem(
          value: 'sair',
          texto: 'Sair',
          icon: Icons.logout_rounded,
        ),
      ],
    ),

    const SizedBox(width: 6),
  ];
}

// =============================================================
// ITEM MENU
// =============================================================

PopupMenuItem<String> _buildMenuItem({
  required String value,
  required String texto,
  required IconData icon,
}) {
  return PopupMenuItem<String>(
    value: value,

    child: Row(
      children: [
        Icon(icon, size: 18, color: AppCores.textoBranco),

        const SizedBox(width: 10),

        Text(texto, style: const TextStyle(color: AppCores.textoBranco)),
      ],
    ),
  );
}

// =============================================================
// AÇÕES MENU
// =============================================================

void _onMenuSelected(BuildContext context, String key) {
  switch (key) {
    // =========================================================
    // CADASTRO TÉCNICO
    // =========================================================

    case 'cad_tecnico':
      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) => TelaCadastroTecnico(controller: TecnicoController()),
        ),
      );

      break;

    // =========================================================
    // CENTRAL PDF
    // =========================================================

    case 'central_pdf':
      Navigator.push(
        context,

        MaterialPageRoute(builder: (_) => const TelaCentralPdf()),
      );

      break;

    // =========================================================
    // CONFIGURAÇÕES
    // =========================================================

    case 'config':
      Navigator.push(
        context,

        MaterialPageRoute(builder: (_) => const TelaConfiguracoes()),
      );

      break;

    // =========================================================
    // ERP FINANCEIRO
    // =========================================================

    case 'financeiro':
      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) => LayoutErp(
            paginas: [
              // DASHBOARD FINANCEIRO
              const TelaFinanceiro(),

              // LANÇAMENTOS
              const Center(
                child: Text(
                  'Lançamentos',
                  style: TextStyle(color: AppCores.textoBranco),
                ),
              ),

              // RECEITAS
              const Center(
                child: Text(
                  'Receitas',
                  style: TextStyle(color: AppCores.textoBranco),
                ),
              ),

              // DESPESAS
              const Center(
                child: Text(
                  'Despesas',
                  style: TextStyle(color: AppCores.textoBranco),
                ),
              ),

              // CONTAS RECORRENTES
              const Center(
                child: Text(
                  'Contas Recorrentes',
                  style: TextStyle(color: AppCores.textoBranco),
                ),
              ),

              // FLUXO CAIXA
              const Center(
                child: Text(
                  'Fluxo de Caixa',
                  style: TextStyle(color: AppCores.textoBranco),
                ),
              ),

              // RELATÓRIOS
              const Center(
                child: Text(
                  'Relatórios',
                  style: TextStyle(color: AppCores.textoBranco),
                ),
              ),

              // AUTOMAÇÃO
              const Center(
                child: Text(
                  'Automação',
                  style: TextStyle(color: AppCores.textoBranco),
                ),
              ),

              // CONFIGURAÇÕES
              const Center(
                child: Text(
                  'Configurações',
                  style: TextStyle(color: AppCores.textoBranco),
                ),
              ),
            ],
          ),
        ),
      );

      break;

    // =========================================================
    // RELATÓRIOS
    // =========================================================

    case 'relatorio':
      _snack(context, 'Relatórios em desenvolvimento');

      break;

    // =========================================================
    // SAIR
    // =========================================================

    case 'sair':
      _snack(context, 'Saindo...');

      break;
  }
}

// =============================================================
// SNACKBAR
// =============================================================

void _snack(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(texto), backgroundColor: AppCores.cardEscuro),
  );
}
