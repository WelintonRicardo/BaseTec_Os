import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../enums/pdf_template_type.dart';
import '../theme/pdf_theme.dart';

class PdfFooter {
  // =====================================================
  // FOOTER
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,

    required int page,

    required int totalPages,

    required DateTime generatedAt,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    final text = isDark
        ? PdfThemeConfig.darkTextLight
        : PdfThemeConfig.cleanTextLight;

    final accent = isDark
        ? PdfThemeConfig.darkAccent
        : PdfThemeConfig.cleanAccent;

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),

      padding: const pw.EdgeInsets.only(top: 14),

      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: border, width: 1)),
      ),

      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

        crossAxisAlignment: pw.CrossAxisAlignment.center,

        children: [
          // =========================================
          // ESQUERDA
          // =========================================
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [
              pw.Text(
                'Documento gerado automaticamente pelo sistema',

                style: pw.TextStyle(fontSize: 9, color: text),
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                DateFormat('dd/MM/yyyy HH:mm').format(generatedAt),

                style: pw.TextStyle(fontSize: 9, color: text),
              ),
            ],
          ),

          // =========================================
          // CENTRO
          // =========================================
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 6),

            decoration: pw.BoxDecoration(
              color: accent,

              borderRadius: pw.BorderRadius.circular(20),
            ),

            child: pw.Text(
              'RELATÓRIO PREMIUM',

              style: pw.TextStyle(
                color: PdfColors.white,

                fontSize: 8,

                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          // =========================================
          // DIREITA
          // =========================================
          pw.Text(
            'Página $page de $totalPages',

            style: pw.TextStyle(
              fontSize: 10,

              color: text,

              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
