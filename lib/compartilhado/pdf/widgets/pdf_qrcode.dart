import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../enums/pdf_template_type.dart';
import '../theme/pdf_theme.dart';

class PdfQrCode {
  // =====================================================
  // QR CODE
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,

    required String data,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    final background = isDark
        ? PdfThemeConfig.darkCard
        : PdfThemeConfig.cleanCard;

    final text = isDark ? PdfThemeConfig.darkText : PdfThemeConfig.cleanText;

    final light = isDark
        ? PdfThemeConfig.darkTextLight
        : PdfThemeConfig.cleanTextLight;

    return pw.Container(
      padding: const pw.EdgeInsets.all(18),

      decoration: pw.BoxDecoration(
        color: background,

        borderRadius: pw.BorderRadius.circular(18),

        border: pw.Border.all(color: border),
      ),

      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,

        children: [
          // =========================================
          // QR CODE
          // =========================================
          pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),

            data: data,

            width: 90,

            height: 90,
          ),

          pw.SizedBox(width: 20),

          // =========================================
          // TEXTO
          // =========================================
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,

              children: [
                pw.Text(
                  'Documento autenticado',

                  style: pw.TextStyle(
                    fontSize: 14,

                    fontWeight: pw.FontWeight.bold,

                    color: text,
                  ),
                ),

                pw.SizedBox(height: 8),

                pw.Text(
                  'Este relatório possui validação digital e identificação única da Ordem de Serviço.',

                  style: pw.TextStyle(fontSize: 10, color: light),
                ),

                pw.SizedBox(height: 10),

                pw.Text(data, style: pw.TextStyle(fontSize: 8, color: light)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
