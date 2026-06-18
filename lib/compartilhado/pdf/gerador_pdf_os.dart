import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'enums/pdf_template_type.dart';

import 'repositorios/pdf_empresa_repository.dart';

import 'widgets/pdf_checklist.dart';
import 'widgets/pdf_cover.dart';
import 'widgets/pdf_footer.dart';
import 'widgets/pdf_header.dart';
import 'widgets/pdf_observacoes.dart';
import 'widgets/pdf_photo_grid.dart';
import 'widgets/pdf_qrcode.dart';
import 'widgets/pdf_section.dart';
import 'widgets/pdf_signature.dart';
import 'widgets/pdf_status_badge.dart';
import 'widgets/pdf_timeline.dart';

class GeradorPdfOs {
  static Future<Uint8List> gerar({
    required Map<String, dynamic> os,
    required Map<String, dynamic> tecnico,
  }) async {
    // =====================================================
    // FONTES
    // =====================================================

    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );

    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
    );

    // =====================================================
    // CONFIG EMPRESA
    // =====================================================

    final empresaConfig = await PdfEmpresaRepository().buscarConfiguracoes();

    final templateString =
        empresaConfig?['pdf_template']?.toString() ?? 'clean';

    final PdfTemplateType template = templateString == 'dark'
        ? PdfTemplateType.dark
        : PdfTemplateType.clean;

    // =====================================================
    // LOGO
    // =====================================================

    pw.MemoryImage? logoImage;

    try {
      final logoUrl = empresaConfig?['logo_url']?.toString();

      if (logoUrl != null && logoUrl.isNotEmpty) {
        final response = await http.get(Uri.parse(logoUrl));

        if (response.statusCode == 200) {
          logoImage = pw.MemoryImage(response.bodyBytes);
        }
      }
    } catch (_) {}

    // =====================================================
    // EXECUÇÃO
    // =====================================================

    Map<String, dynamic>? execucao;

    final execucoes = os['execucoes_os'];

    if (execucoes is List && execucoes.isNotEmpty) {
      for (final item in execucoes) {
        if (item['status_execucao']?.toString().toLowerCase() == 'finalizado') {
          execucao = Map<String, dynamic>.from(item);

          break;
        }
      }

      if (execucao == null) {
        execucao = Map<String, dynamic>.from(execucoes.first);
      }
    }

    // =====================================================
    // DEBUG
    // =====================================================

    print('================================');
    print('=== DADOS EXECUCAO ===');
    print(execucao.toString());

    print('Solicitação: ${execucao?['solicitacao_cliente']}');

    print('Defeito: ${execucao?['defeito_constatado']}');

    print('Solução: ${execucao?['solucao_aplicada']}');

    print('Checklist: ${execucao?['checklist']}');

    print('Ass Tec: ${execucao?['assinatura_tecnico_url']}');

    print('Ass Cliente: ${execucao?['assinatura_cliente_url']}');

    print('================================');

    // =====================================================
    // DADOS GERAIS
    // =====================================================

    final empresa = empresaConfig?['nome']?.toString() ?? 'Empresa';

    final numeroOs = os['numero_os']?.toString() ?? '---';

    final status =
        execucao?['status_final']?.toString() ??
        os['status']?.toString() ??
        '---';

    final cliente =
        os['nome_segurado']?.toString() ??
        os['cliente']?.toString() ??
        'Não informado';

    final telefone = os['telefone']?.toString() ?? 'Não informado';

    final cidade = os['cidade']?.toString() ?? 'Não informado';

    final rua = os['rua']?.toString() ?? 'Não informado';

    final numero = os['numero']?.toString() ?? 'S/N';

    final tecnicoNome =
        execucao?['tecnico']?['nome']?.toString() ??
        tecnico['nome']?.toString() ??
        'Técnico';

    final valorMaoObra = os['valor_mao_obra']?.toString() ?? '0';

    final valorDeslocamento = os['valor_deslocamento']?.toString() ?? '0';

    final valorPecas = os['valor_pecas']?.toString() ?? '0';

    // =====================================================
    // DADOS EXECUÇÃO
    // =====================================================

    final solicitacao = execucao?['solicitacao_cliente']?.toString() ?? '';

    final defeito = execucao?['defeito_constatado']?.toString() ?? '';

    final solucao = execucao?['solucao_aplicada']?.toString() ?? '';

    final observacoes = execucao?['observacao_final']?.toString() ?? '';

    // =====================================================
    // FOTOS
    // =====================================================

    Future<Uint8List?> baixarFoto(String? url) async {
      try {
        if (url == null || url.isEmpty) {
          return null;
        }

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
      } catch (_) {}

      return null;
    }
    // =====================================================
    // CARREGAR FOTOS
    // =====================================================

    final fotoInicio = await baixarFoto(execucao?['foto_inicio']?.toString());

    final fotoFim = await baixarFoto(execucao?['foto_fim']?.toString());
    // =====================================================
    // ASSINATURAS
    // =====================================================

    pw.MemoryImage? assinaturaCliente;

    pw.MemoryImage? assinaturaTecnico;

    Future<pw.MemoryImage?> carregarImagem(String? url) async {
      try {
        if (url == null || url.isEmpty) {
          return null;
        }

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          return pw.MemoryImage(response.bodyBytes);
        }
      } catch (_) {}

      return null;
    }

    assinaturaCliente = await carregarImagem(
      execucao?['assinatura_cliente_url']?.toString(),
    );

    assinaturaTecnico = await carregarImagem(
      execucao?['assinatura_tecnico_url']?.toString(),
    );

    // =====================================================
    // TIMELINE
    // =====================================================

    final inicio = execucao?['inicio_execucao']?.toString();

    final fim = execucao?['fim_execucao']?.toString();

    final horaInicio = inicio != null && inicio.length >= 16
        ? inicio.substring(11, 16)
        : '--:--';

    final horaFim = fim != null && fim.length >= 16
        ? fim.substring(11, 16)
        : '--:--';

    final timeline = [
      {
        'titulo': 'Execução iniciada',
        'descricao': 'Início da execução da OS',
        'hora': horaInicio,
      },
      {
        'titulo': 'Execução finalizada',
        'descricao': 'Finalização da execução',
        'hora': horaFim,
      },
    ];

    // =====================================================
    // CHECKLIST
    // =====================================================

    List<Map<String, dynamic>> checklist = [];

    try {
      final checklistRaw = execucao?['checklist'];

      if (checklistRaw is List && checklistRaw.isNotEmpty) {
        checklist = checklistRaw.map((item) {
          if (item is Map<String, dynamic>) {
            return {
              'titulo': item['titulo']?.toString() ?? 'Item',

              'checked': item['checked'] == true,
            };
          }

          return {'titulo': item.toString(), 'checked': false};
        }).toList();
      }
    } catch (_) {}

    if (checklist.isEmpty) {
      checklist = [
        {'titulo': 'Nenhum item informado', 'checked': false},
      ];
    }

    // =====================================================
    // PDF
    // =====================================================

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),

          pageFormat: PdfPageFormat.a4,
        ),

        footer: (context) {
          return PdfFooter.build(
            template: template,

            page: context.pageNumber,

            totalPages: context.pagesCount,

            generatedAt: DateTime.now(),
          );
        },

        build: (context) {
          return [
            // =================================================
            // CAPA
            // =================================================
            PdfCover.build(
              template: template,

              empresa: empresa,

              numeroOs: numeroOs,

              cliente: cliente,

              tecnico: tecnicoNome,

              status: status,

              descricaoServico: os['descricao_servico']?.toString() ?? '---',

              tipoServico: os['tipo_servico']?.toString() ?? '---',

              seguradora: os['seguradora']?.toString() ?? '---',

              valorMaoObra: valorMaoObra,

              valorDeslocamento: valorDeslocamento,

              valorPecas: valorPecas,

              // =========================================
              // NOVOS CAMPOS
              // =========================================
              telefone: telefone,

              cidade: cidade,

              endereco: '$rua, $numero',
            ),

            pw.NewPage(),

            // =================================================
            // HEADER
            // =================================================
            PdfHeader.build(
              template: template,

              empresa: empresa,

              numeroOs: numeroOs,

              status: status,

              tecnico: tecnicoNome,

              data: DateTime.now(),

              logo: logoImage,
            ),

            pw.SizedBox(height: 20),

            PdfStatusBadge.build(template: template, status: status),

            pw.SizedBox(height: 20),

            // =================================================
            // SOLICITAÇÃO
            // =================================================
            PdfSection.build(
              template: template,

              title: 'Solicitação do Cliente',

              children: [
                PdfObservacoes.build(template: template, texto: solicitacao),
              ],
            ),

            // =================================================
            // DEFEITO
            // =================================================
            PdfSection.build(
              template: template,

              title: 'Defeito Constatado',

              children: [
                PdfObservacoes.build(template: template, texto: defeito),
              ],
            ),

            // =================================================
            // SOLUÇÃO
            // =================================================
            PdfSection.build(
              template: template,

              title: 'Solução Aplicada',

              children: [
                PdfObservacoes.build(template: template, texto: solucao),
              ],
            ),

            // =================================================
            // OBSERVAÇÕES
            // =================================================
            PdfSection.build(
              template: template,

              title: 'Observações Finais',

              children: [
                PdfObservacoes.build(template: template, texto: observacoes),
              ],
            ),

            pw.SizedBox(height: 30),

            // =================================================
            // TIMELINE
            // =================================================
            PdfSection.build(
              template: template,

              title: 'Linha do Tempo',

              children: [
                PdfTimeline.build(template: template, eventos: timeline),
              ],
            ),

            pw.SizedBox(height: 30),

            // =================================================
            // CHECKLIST
            // =================================================
            PdfSection.build(
              template: template,

              title: 'Checklist',

              children: [
                PdfChecklist.build(template: template, itens: checklist),
              ],
            ),

            pw.SizedBox(height: 30),

            // =================================================
            // FOTOS
            // =================================================
            PdfSection.build(
              template: template,
              title: 'Registro Fotográfico',
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // FOTO INICIAL
                    pw.Expanded(
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'FOTO INICIAL',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),

                          pw.SizedBox(height: 8),

                          fotoInicio != null
                              ? pw.Container(
                                  height: 180,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.grey400,
                                    ),
                                  ),
                                  child: pw.Image(
                                    pw.MemoryImage(fotoInicio),
                                    fit: pw.BoxFit.cover,
                                  ),
                                )
                              : pw.Container(
                                  height: 180,
                                  alignment: pw.Alignment.center,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.grey400,
                                    ),
                                  ),
                                  child: pw.Text('Sem foto'),
                                ),
                        ],
                      ),
                    ),

                    pw.SizedBox(width: 20),

                    // FOTO FINAL
                    pw.Expanded(
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'FOTO FINAL',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),

                          pw.SizedBox(height: 8),

                          fotoFim != null
                              ? pw.Container(
                                  height: 180,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.grey400,
                                    ),
                                  ),
                                  child: pw.Image(
                                    pw.MemoryImage(fotoFim),
                                    fit: pw.BoxFit.cover,
                                  ),
                                )
                              : pw.Container(
                                  height: 180,
                                  alignment: pw.Alignment.center,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.grey400,
                                    ),
                                  ),
                                  child: pw.Text('Sem foto'),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 30),

            // =================================================
            // QR CODE
            // =================================================
            PdfQrCode.build(template: template, data: 'OS-$numeroOs'),

            pw.SizedBox(height: 30),

            // =================================================
            // ASSINATURAS LADO A LADO
            // =================================================
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,

              children: [
                pw.Expanded(
                  child: PdfSignatureWidget.build(
                    template: template,

                    titulo: 'Assinatura do Técnico',

                    nome: tecnicoNome,

                    assinatura: assinaturaTecnico,
                  ),
                ),

                pw.SizedBox(width: 20),

                pw.Expanded(
                  child: PdfSignatureWidget.build(
                    template: template,

                    titulo: 'Assinatura do Cliente',

                    nome: cliente,

                    assinatura: assinaturaCliente,
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
