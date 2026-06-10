import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';
import '../../../../compartilhado/pdf/servicos/pdf_menu_service.dart';
import '../../../ordens_servico/services/os_admin_service.dart';
import '../../../ordens_servico/apresentacao/dialogs/editar_os_dialog.dart';
import 'chip_status.dart';
import 'format_hora.dart';

Widget buildListaOSDia(
  List<Map<String, dynamic>> ordensServico,
  DateTime dataSelecionada,
) {
  if (ordensServico.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text("Nenhuma ordem de serviço encontrada",
            style: TextStyle(color: AppCores.textoCinza)),
      ),
    );
  }

  final osFiltradas = ordensServico.where((os) {
    final dataIso = os['janela_inicio_agendada'];
    if (dataIso == null) return false;
    try {
      final dt = DateTime.parse(dataIso);
      return dt.year == dataSelecionada.year &&
          dt.month == dataSelecionada.month &&
          dt.day == dataSelecionada.day;
    } catch (_) {
      return false;
    }
  }).toList();

  if (osFiltradas.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text("Nenhuma OS encontrada para esta data",
            style: TextStyle(color: AppCores.textoCinza)),
      ),
    );
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(),
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
            // HEADER
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppCores.primaria.withOpacity(0.2),
                  child: const Icon(Icons.assignment_rounded,
                      color: AppCores.primaria),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("OS: ${os['numero_os'] ?? '---'}",
                          style: const TextStyle(
                              color: AppCores.textoBranco,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      Text(os['nome_segurado'] ?? 'Sem segurado',
                          style: const TextStyle(color: AppCores.textoCinza)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppCores.textoCinza),
                  color: AppCores.cardEscuro,
                  onSelected: (value) async {
                    switch (value) {
                      case 'editar':
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => EditarOsDialog(os: os),
                        );
                        break;
                      case 'cancelar':
                        await osAdminService.cancelarOS(osId: os['id'].toString());
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OS cancelada com sucesso')),
                        );
                        break;
                      case 'status':
                        final novoStatus = await _dialogAlterarStatus(context);
                        if (novoStatus != null) {
                          await osAdminService.alterarStatus(
                            osId: os['id'].toString(),
                            novoStatus: novoStatus,
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Status alterado para $novoStatus')),
                          );
                        }
                        break;
                      case 'excluir':
                        final confirmar = await _dialogExcluir(context);
                        if (confirmar == true) {
                          await osAdminService.excluirOS(osId: os['id'].toString());
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('OS excluída com sucesso')),
                          );
                        }
                        break;
                      case 'visualizar_pdf':
                        await pdfMenuService.visualizarPdf(context: context, os: os);
                        break;
                      case 'baixar_pdf':
                        await pdfMenuService.baixarPdf(context: context, os: os);
                        break;
                      case 'compartilhar_pdf':
                        await pdfMenuService.compartilharPdf(context: context, os: os);
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(value: 'editar', child: Text('Editar')),
                    PopupMenuItem<String>(value: 'cancelar', child: Text('Cancelar')),
                    PopupMenuItem<String>(value: 'status', child: Text('Alterar Status')),
                    PopupMenuItem<String>(value: 'excluir', child: Text('Excluir')),
                    PopupMenuDivider(),
                    PopupMenuItem<String>(value: 'visualizar_pdf', child: Text('Visualizar PDF')),
                    PopupMenuItem<String>(value: 'baixar_pdf', child: Text('Baixar PDF')),
                    PopupMenuItem<String>(value: 'compartilhar_pdf', child: Text('Compartilhar PDF')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // DADOS
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 16, color: AppCores.textoCinza),
                const SizedBox(width: 6),
                Text(formatHora(os['janela_inicio_agendada']?.toString()),
                    style: const TextStyle(color: AppCores.textoCinza)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppCores.primaria.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(os['status'] ?? 'Pendente',
                      style: const TextStyle(
                          color: AppCores.primaria,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // CHIPS
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip("Seguradora", os['seguradora']),
                _chip("Tipo", os['tipo_servico']),
                _chip("Cidade", os['cidade']),
                chipStatus(os['status']),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _chip(String label, String? valor) {
  if (valor == null || valor.isEmpty) return const SizedBox.shrink();
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppCores.fundoEscuro,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text("$label: $valor",
        style: const TextStyle(color: AppCores.textoBranco, fontSize: 12)),
  );
}

Future<String?> _dialogAlterarStatus(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: AppCores.cardEscuro,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Alterar Status',
                  style: TextStyle(color: AppCores.textoBranco, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  'pendente',
                  'agendada',
                  'em_execucao',
                  'aguardando_peca',
                  'retorno',
                  'concluida',
                  'cancelada',
                ].map((status) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => Navigator.pop(context, status),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppCores.primaria.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(status,
                          style: const TextStyle(color: AppCores.textoBranco, fontSize: 10)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<bool?> _dialogExcluir(BuildContext context) {
  return showDialog<bool>(
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
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppCores.textoBranco),
            ),
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
}
