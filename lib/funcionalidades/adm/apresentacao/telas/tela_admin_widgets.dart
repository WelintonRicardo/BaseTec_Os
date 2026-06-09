// lib/funcionalidades/dashboard/apresentacao/telas/tela_admin_widgets.dart

import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

import '../../../tecnico/apresentacao/telas/tela_cadastro_tecnico.dart';

import '../../../tecnico/dados/servicos/tecnico_controller.dart';

import '../../../../compartilhado/pdf/apresentacao/tela_central_pdf.dart';

import '../../../../compartilhado/pdf/servicos/pdf_menu_service.dart';

import '../../../ordens_servico/services/os_admin_service.dart';

import '../../../ordens_servico/apresentacao/dialogs/editar_os_dialog.dart';

import '../widgets/admin_search_bar_widget.dart';
import '../widgets/chips.dart';

// =========================================
// ACTIONS APPBAR
// =========================================

List<Widget> buildAppBarActions(BuildContext context) {
  return [
    IconButton(
      tooltip: 'Notificações',

      icon: const Icon(
        Icons.notifications_none_rounded,
        color: AppCores.textoBranco,
      ),

      onPressed: () {},
    ),

    // =========================================
    // MENU
    // =========================================
    PopupMenuButton<String>(
      color: AppCores.cardEscuro,

      icon: const Icon(Icons.more_vert_rounded, color: AppCores.textoBranco),

      onSelected: (value) => _onMenuSelected(context, value),

      itemBuilder: (context) => [
        // =====================================
        // CADASTRAR TÉCNICO
        // =====================================
        _buildMenuItem(
          value: 'cad_tecnico',
          texto: 'Cadastrar Técnico',
          icon: Icons.person_add_alt_1_rounded,
        ),

        // =====================================
        // CENTRAL PDF
        // =====================================
        _buildMenuItem(
          value: 'central_pdf',
          texto: 'Central PDF',
          icon: Icons.picture_as_pdf_rounded,
        ),

        // =====================================
        // CONFIG
        // =====================================
        _buildMenuItem(
          value: 'config',
          texto: 'Configurações',
          icon: Icons.settings_rounded,
        ),

        // =====================================
        // FINANCEIRO
        // =====================================
        _buildMenuItem(
          value: 'financeiro',
          texto: 'Financeiro',
          icon: Icons.attach_money_rounded,
        ),

        // =====================================
        // RELATÓRIOS
        // =====================================
        _buildMenuItem(
          value: 'relatorio',
          texto: 'Relatórios',
          icon: Icons.bar_chart_rounded,
        ),

        const PopupMenuDivider(),

        // =====================================
        // SAIR
        // =====================================
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

// =========================================
// MENU ITEM
// =========================================

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

// =========================================
// MENU ACTIONS
// =========================================

void _onMenuSelected(BuildContext context, String key) {
  switch (key) {
    // =====================================
    // CADASTRO TÉCNICO
    // =====================================

    case 'cad_tecnico':
      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) => TelaCadastroTecnico(controller: TecnicoController()),
        ),
      );

      break;

    // =====================================
    // CENTRAL PDF
    // =====================================

    case 'central_pdf':
      Navigator.push(
        context,

        MaterialPageRoute(builder: (_) => const TelaCentralPdf()),
      );

      break;

    // =====================================
    // CONFIG
    // =====================================

    case 'config':
      _snack(context, 'Configurações em desenvolvimento');

      break;

    // =====================================
    // FINANCEIRO
    // =====================================

    case 'financeiro':
      _snack(context, 'Financeiro em desenvolvimento');

      break;

    // =====================================
    // RELATÓRIOS
    // =====================================

    case 'relatorio':
      _snack(context, 'Relatórios em desenvolvimento');

      break;

    // =====================================
    // SAIR
    // =====================================

    case 'sair':
      _snack(context, 'Saindo...');

      break;
  }
}

void _snack(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(texto), backgroundColor: AppCores.cardEscuro),
  );
}

// =========================================
// CALENDÁRIO
// =========================================

Widget buildCalendarioBR({
  DateTime? selectedDay,
  required Function(DateTime selectedDay) onDaySelected,
}) {
  final DateTime hoje = DateTime.now();

  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppCores.cardEscuro,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppCores.bordaEscura, width: 1.2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: AppCores.primaria,
          onPrimary: Colors.white,
          surface: AppCores.cardEscuro,
          onSurface: AppCores.textoBranco,
        ),
        dividerColor: AppCores.bordaEscura,
      ),

      child: CalendarDatePicker(
        initialDate: selectedDay ?? hoje,
        firstDate: DateTime(2020),
        lastDate: DateTime(2035),

        onDateChanged: (date) {
          onDaySelected(date);
        },
      ),
    ),
  );
}
// =========================================
// LISTA DE TÉCNICOS
// =========================================

Widget buildListaTecnicos(List<Map<String, dynamic>> tecnicos) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppCores.cardEscuro,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppCores.bordaEscura),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.engineering_rounded, color: AppCores.primaria),
            SizedBox(width: 10),
            Text(
              "Técnicos",
              style: TextStyle(
                color: AppCores.textoBranco,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        if (tecnicos.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                "Nenhum técnico encontrado",
                style: TextStyle(color: AppCores.textoCinza),
              ),
            ),
          ),

        if (tecnicos.isNotEmpty)
          ...tecnicos.map((t) {
            return buildItemTecnico(
              nome: t['nome']?.toString() ?? 'Sem nome',

              totalOsMes: t['total_os_mes'] is int
                  ? t['total_os_mes']
                  : int.tryParse(t['total_os_mes']?.toString() ?? '0') ?? 0,

              concluidas: t['concluidas'] is int
                  ? t['concluidas']
                  : int.tryParse(t['concluidas']?.toString() ?? '0') ?? 0,
            );
          }).toList(),
      ],
    ),
  );
}
// =========================================
// ITEM TÉCNICO
// =========================================

Widget buildItemTecnico({
  required String nome,
  required int totalOsMes,
  required int concluidas,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppCores.fundoEscuro,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: AppCores.primaria.withOpacity(0.2),
          child: const Icon(Icons.person, color: AppCores.primaria),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nome,
                style: const TextStyle(
                  color: AppCores.textoBranco,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppCores.primaria.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'OS no mês: $totalOsMes',
                      style: const TextStyle(
                        color: AppCores.primaria,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Concluídas: $concluidas',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: AppCores.textoCinza,
        ),
      ],
    ),
  );
}

// =========================================
// FORMATA HORA (CORREÇÃO DO ERRO)
// =========================================

String formatHora(String? dataIso) {
  if (dataIso == null || dataIso.isEmpty) return '---';

  try {
    final dt = DateTime.parse(dataIso);
    final hora = dt.hour.toString().padLeft(2, '0');
    final minuto = dt.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  } catch (e) {
    return '---';
  }
}

// =========================================
// LISTA DE OS
// =========================================

Widget buildListaOSDia(
  List<Map<String, dynamic>> ordensServico,
  DateTime dataSelecionada,
) {
  if (ordensServico.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Nenhuma ordem de serviço encontrada",
          style: TextStyle(color: AppCores.textoCinza),
        ),
      ),
    );
  }

  final osFiltradas = ordensServico.where((os) {
    final dataIso = os['janela_inicio_agendada'];

    if (dataIso == null) {
      return false;
    }

    try {
      final dt = DateTime.parse(dataIso);

      return dt.year == dataSelecionada.year &&
          dt.month == dataSelecionada.month &&
          dt.day == dataSelecionada.day;
    } catch (e) {
      return false;
    }
  }).toList();

  if (osFiltradas.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Nenhuma OS encontrada para esta data",
          style: TextStyle(color: AppCores.textoCinza),
        ),
      ),
    );
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(), // ✅ permite scroll dentro do pai
    itemCount: osFiltradas.length,
    itemBuilder: (context, index) {
      final os = osFiltradas[index];

      final pdfMenuService = PdfMenuService();
      final osAdminService = OsAdminService();

      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppCores.cardEscuro,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================
            // HEADER
            // =====================================
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppCores.primaria.withOpacity(0.2),
                  child: const Icon(
                    Icons.assignment_rounded,
                    color: AppCores.primaria,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "OS: ${os['numero_os'] ?? '---'}",
                        style: const TextStyle(
                          color: AppCores.textoBranco,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      Text(
                        os['nome_segurado'] ?? 'Sem segurado',
                        style: const TextStyle(color: AppCores.textoCinza),
                      ),
                    ],
                  ),
                ),

                // =====================================
                // MENU
                // =====================================
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppCores.textoCinza),

                  color: AppCores.cardEscuro,

                  onSelected: (value) async {
                    switch (value) {
                      // =================================
                      // EDITAR
                      // =================================

                      case 'editar':
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => EditarOsDialog(os: os),
                        );

                        break;

                      // =================================
                      // CANCELAR
                      // =================================

                      case 'cancelar':
                        await osAdminService.cancelarOS(
                          osId: os['id'].toString(),
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('OS cancelada com sucesso'),
                          ),
                        );

                        break;

                      // =================================
                      // STATUS
                      // =================================

                      case 'status':
                        final novoStatus = await showDialog<String>(
                          context: context,
                          builder: (_) {
                            return Dialog(
                              backgroundColor: AppCores.cardEscuro,
                              insetPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 24,
                              ),

                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 320, // limita largura do modal
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(12),

                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Alterar Status',
                                        style: TextStyle(
                                          color: AppCores.textoBranco,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      Wrap(
                                        spacing: 4,
                                        runSpacing: 4,

                                        children:
                                            [
                                              'pendente',
                                              'agendada',
                                              'em_execucao',
                                              'aguardando_peca',
                                              'retorno',
                                              'concluida',
                                              'cancelada',
                                            ].map((status) {
                                              return InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(6),

                                                onTap: () {
                                                  Navigator.pop(
                                                    context,
                                                    status,
                                                  );
                                                },

                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 4,
                                                      ),

                                                  decoration: BoxDecoration(
                                                    color: AppCores.primaria
                                                        .withOpacity(0.12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),

                                                  child: Text(
                                                    status,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color:
                                                          AppCores.textoBranco,
                                                      fontSize: 8, // menor
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );

                        if (novoStatus != null) {
                          await osAdminService.alterarStatus(
                            osId: os['id'].toString(),
                            novoStatus: novoStatus,
                          );

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Status alterado para $novoStatus'),
                            ),
                          );
                        }

                        break;

                      // =================================
                      // EXCLUIR
                      // =================================

                      case 'excluir':
                        final confirmar = await showDialog<bool>(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              backgroundColor: AppCores.cardEscuro,

                              title: const Text(
                                'Excluir OS',
                                style: TextStyle(color: AppCores.textoBranco),
                              ),

                              content: const Text(
                                'Deseja realmente excluir esta OS?',
                                style: TextStyle(color: AppCores.textoCinza),
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },

                                  child: const Text('Cancelar'),
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },

                                  child: const Text('Excluir'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmar == true) {
                          await osAdminService.excluirOS(
                            osId: os['id'].toString(),
                          );

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('OS excluída com sucesso'),
                            ),
                          );
                        }

                        break;

                      // =================================
                      // VISUALIZAR PDF
                      // =================================

                      case 'visualizar_pdf':
                        await pdfMenuService.visualizarPdf(
                          context: context,
                          os: os,
                        );

                        break;

                      // =================================
                      // BAIXAR PDF
                      // =================================

                      case 'baixar_pdf':
                        await pdfMenuService.baixarPdf(
                          context: context,
                          os: os,
                        );

                        break;

                      // =================================
                      // COMPARTILHAR PDF
                      // =================================

                      case 'compartilhar_pdf':
                        await pdfMenuService.compartilharPdf(
                          context: context,
                          os: os,
                        );

                        break;
                    }
                  },

                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'editar',
                      child: Text('Editar'),
                    ),

                    const PopupMenuItem<String>(
                      value: 'cancelar',
                      child: Text('Cancelar'),
                    ),

                    const PopupMenuItem<String>(
                      value: 'status',
                      child: Text('Alterar Status'),
                    ),

                    const PopupMenuItem<String>(
                      value: 'excluir',
                      child: Text('Excluir'),
                    ),

                    const PopupMenuDivider(),

                    const PopupMenuItem<String>(
                      value: 'visualizar_pdf',
                      child: Text('Visualizar PDF'),
                    ),

                    const PopupMenuItem<String>(
                      value: 'baixar_pdf',
                      child: Text('Baixar PDF'),
                    ),

                    const PopupMenuItem<String>(
                      value: 'compartilhar_pdf',
                      child: Text('Compartilhar PDF'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =====================================
            // DADOS
            // =====================================
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: AppCores.textoCinza,
                ),

                const SizedBox(width: 6),

                Text(
                  formatHora(os['janela_inicio_agendada']?.toString()),
                  style: const TextStyle(color: AppCores.textoCinza),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: AppCores.primaria.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    os['status'] ?? 'Pendente',

                    style: const TextStyle(
                      color: AppCores.primaria,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =====================================
            // CHIPS
            // =====================================
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip("Seguradora", os['seguradora']),

                _chip("Tipo", os['tipo_servico']),

                _chip("Cidade", os['cidade']),

                _chipStatus(os['status']),
              ],
            ),

            const SizedBox(height: 12),

            // =====================================
            // HORÁRIO
            // =====================================
            Container(
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Início: ${formatHora(os['janela_inicio_agendada'])}",
                    style: const TextStyle(color: AppCores.textoCinza),
                  ),

                  Text(
                    "Fim: ${formatHora(os['janela_fim_agendada'])}",
                    style: const TextStyle(color: AppCores.textoCinza),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

// =========================================
// CHIPS (FORA DO WIDGET - CORRETO)
// =========================================

Widget _chip(String label, String? value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppCores.primaria.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppCores.primaria.withOpacity(0.3)),
    ),
    child: Text(
      "$label: ${value ?? '---'}",
      style: const TextStyle(color: AppCores.textoCinza, fontSize: 12),
    ),
  );
}

Widget _chipStatus(String? status) {
  Color color = Colors.orange;

  if (status == 'concluida') color = Colors.green;
  if (status == 'cancelada') color = Colors.red;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color),
    ),
    child: Text(
      status ?? 'pendente',
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
    ),
  );
}
