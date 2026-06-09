import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../enums/pdf_template_type.dart';
import '../theme/pdf_theme.dart';

class PdfChecklist {
  // =====================================================
  // CHECKLIST
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,

    required List<Map<String, dynamic>> itens,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    final text = isDark ? PdfThemeConfig.darkText : PdfThemeConfig.cleanText;

    final background = isDark
        ? PdfThemeConfig.darkCard
        : PdfThemeConfig.cleanCard;

    return pw.Column(
      children: itens.map((item) {
        final checked = item['checked'] == true;

        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 10),

          padding: const pw.EdgeInsets.all(14),

          decoration: pw.BoxDecoration(
            color: background,

            borderRadius: pw.BorderRadius.circular(14),

            border: pw.Border.all(color: border),
          ),

          child: pw.Row(
            children: [
              pw.Container(
                width: 18,

                height: 18,

                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: border),

                  shape: pw.BoxShape.circle,

                  color: checked ? border : PdfColor.fromInt(0x00000000)
                ),
              ),

              pw.SizedBox(width: 12),

              pw.Expanded(
                child: pw.Text(
                  item['titulo'] ?? '',

                  style: pw.TextStyle(fontSize: 11, color: text),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
