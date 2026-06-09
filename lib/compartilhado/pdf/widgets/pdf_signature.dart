import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../enums/pdf_template_type.dart';
import '../theme/pdf_theme.dart';

class PdfSignatureWidget {
  // =====================================================
  // ASSINATURA
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,
    required String titulo,
    required String nome,
    pw.MemoryImage? assinatura,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    final text = isDark ? PdfThemeConfig.darkText : PdfThemeConfig.cleanText;

    final light = isDark
        ? PdfThemeConfig.darkTextLight
        : PdfThemeConfig.cleanTextLight;

    final background = isDark
        ? PdfThemeConfig.darkCard
        : PdfThemeConfig.cleanCard;

    return pw.Container(
      width: 240,
      padding: const pw.EdgeInsets.all(16),

      decoration: pw.BoxDecoration(
        color: background,
        borderRadius: pw.BorderRadius.circular(14),
        border: pw.Border.all(color: border, width: 1),
      ),

      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        children: [
          // =========================================
          // TITULO
          // =========================================
          pw.Text(
            titulo,

            style: pw.TextStyle(
              fontSize: 11,
              color: light,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 14),

          // =========================================
          // ASSINATURA
          // =========================================
          pw.Container(
            height: 80,
            width: double.infinity,
            alignment: pw.Alignment.center,

            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(10),
            ),

            child: assinatura != null
                ? pw.Padding(
                    padding: const pw.EdgeInsets.all(6),

                    child: pw.Image(assinatura, fit: pw.BoxFit.contain),
                  )
                : pw.Text(
                    'Sem assinatura',

                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                  ),
          ),

          pw.SizedBox(height: 14),

          // =========================================
          // LINHA
          // =========================================
          pw.Container(height: 1, color: border),

          pw.SizedBox(height: 8),

          // =========================================
          // NOME
          // =========================================
          pw.Text(
            nome,

            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: text,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ASSINATURA DUPLA
  // =====================================================

  static pw.Widget doubleSignature({
    required PdfTemplateType template,
    required String tecnico,
    required String cliente,
    pw.MemoryImage? assinaturaTecnico,
    pw.MemoryImage? assinaturaCliente,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

      children: [
        build(
          template: template,
          titulo: 'Assinatura do Técnico',
          nome: tecnico,
          assinatura: assinaturaTecnico,
        ),

        build(
          template: template,
          titulo: 'Assinatura do Cliente',
          nome: cliente,
          assinatura: assinaturaCliente,
        ),
      ],
    );
  }
}
