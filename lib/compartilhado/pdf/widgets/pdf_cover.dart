import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../enums/pdf_template_type.dart';
import '../theme/pdf_theme.dart';

class PdfCover {
  // =====================================================
  // CAPA PREMIUM
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,
    required String empresa,
    required String numeroOs,
    required String cliente,
    required String tecnico,
    required String status,
    required String descricaoServico,
    required String tipoServico,
    required String seguradora,
    required String valorMaoObra,
    required String valorDeslocamento,
    required String valorPecas,
    required String telefone,
    required String endereco,
    required String cidade,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final background = isDark
        ? PdfThemeConfig.darkCard
        : PdfThemeConfig.cleanCard;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    final text = isDark ? PdfThemeConfig.darkText : PdfThemeConfig.cleanText;

    final light = isDark
        ? PdfThemeConfig.darkTextLight
        : PdfThemeConfig.cleanTextLight;

    final primary = PdfColors.blue700;

    return pw.Container(
      padding: const pw.EdgeInsets.all(32),

      decoration: pw.BoxDecoration(
        color: background,

        borderRadius: pw.BorderRadius.circular(24),

        border: pw.Border.all(color: border, width: 1),
      ),

      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        children: [
          // =====================================
          // TOPO
          // =====================================
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,

                children: [
                  pw.Text(
                    empresa,

                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: text,
                    ),
                  ),

                  pw.SizedBox(height: 6),

                  pw.Text(
                    'Relatório Técnico de Ordem de Serviço',

                    style: pw.TextStyle(fontSize: 12, color: light),
                  ),
                ],
              ),

              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),

                decoration: pw.BoxDecoration(
                  color: primary,

                  borderRadius: pw.BorderRadius.circular(16),
                ),

                child: pw.Text(
                  status.toUpperCase(),

                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 35),

          // =====================================
          // CARD PRINCIPAL
          // =====================================
          pw.Container(
            width: double.infinity,

            padding: const pw.EdgeInsets.all(26),

            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,

              borderRadius: pw.BorderRadius.circular(22),
            ),

            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,

              children: [
                // =================================
                // TITULO
                // =================================
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,

                      children: [
                        pw.Text(
                          'ORDEM DE SERVIÇO',

                          style: pw.TextStyle(
                            fontSize: 11,
                            color: light,
                            letterSpacing: 1,
                          ),
                        ),

                        pw.SizedBox(height: 8),

                        pw.Text(
                          numeroOs,

                          style: pw.TextStyle(
                            fontSize: 26,
                            fontWeight: pw.FontWeight.bold,
                            color: text,
                          ),
                        ),
                      ],
                    ),

                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),

                      decoration: pw.BoxDecoration(
                        color: primary,

                        borderRadius: pw.BorderRadius.circular(14),
                      ),

                      child: pw.Text(
                        tipoServico,

                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 28),

                // =================================
                // GRID DADOS
                // =================================
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,

                  children: [
                    // COLUNA 1
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,

                        children: [
                          _item(
                            label: 'Cliente',
                            value: cliente,
                            text: text,
                            light: light,
                          ),

                          _item(
                            label: 'Telefone',
                            value: telefone,
                            text: text,
                            light: light,
                          ),

                          _item(
                            label: 'Cidade',
                            value: cidade,
                            text: text,
                            light: light,
                          ),
                        ],
                      ),
                    ),

                    pw.SizedBox(width: 30),

                    // COLUNA 2
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,

                        children: [
                          _item(
                            label: 'Técnico Responsável',
                            value: tecnico,
                            text: text,
                            light: light,
                          ),

                          _item(
                            label: 'Seguradora',
                            value: seguradora,
                            text: text,
                            light: light,
                          ),

                          _item(
                            label: 'Status',
                            value: status,
                            text: text,
                            light: light,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 25),

                // =================================
                // ENDEREÇO
                // =================================
                pw.Container(
                  width: double.infinity,

                  padding: const pw.EdgeInsets.all(18),

                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,

                    borderRadius: pw.BorderRadius.circular(16),

                    border: pw.Border.all(color: PdfColors.grey300),
                  ),

                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,

                    children: [
                      pw.Text(
                        'ENDEREÇO DO ATENDIMENTO',

                        style: pw.TextStyle(
                          fontSize: 11,
                          color: light,
                          letterSpacing: 1,
                        ),
                      ),

                      pw.SizedBox(height: 10),

                      pw.Text(
                        endereco,

                        style: pw.TextStyle(
                          fontSize: 16,
                          color: text,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 25),

                // =================================
                // DESCRIÇÃO
                // =================================
                pw.Container(
                  width: double.infinity,

                  padding: const pw.EdgeInsets.all(18),

                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,

                    borderRadius: pw.BorderRadius.circular(16),

                    border: pw.Border.all(color: PdfColors.grey300),
                  ),

                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,

                    children: [
                      pw.Text(
                        'DESCRIÇÃO DA SOLICITAÇÃO',

                        style: pw.TextStyle(
                          fontSize: 11,
                          color: light,
                          letterSpacing: 1,
                        ),
                      ),

                      pw.SizedBox(height: 10),

                      pw.Text(
                        descricaoServico,

                        style: pw.TextStyle(
                          fontSize: 15,
                          color: text,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 30),

          // =====================================
          // FOOTER
          // =====================================
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

            children: [
              pw.Text(
                'Documento gerado automaticamente',

                style: pw.TextStyle(fontSize: 10, color: light),
              ),

              pw.Text(
                'Gerado em '
                '${DateTime.now().day}/'
                '${DateTime.now().month}/'
                '${DateTime.now().year}',

                style: pw.TextStyle(fontSize: 10, color: light),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ITEM
  // =====================================================

  static pw.Widget _item({
    required String label,
    required String value,
    required PdfColor text,
    required PdfColor light,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 18),

      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 11, color: light)),

          pw.SizedBox(height: 6),

          pw.Text(
            value,

            style: pw.TextStyle(
              fontSize: 16,
              color: text,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
