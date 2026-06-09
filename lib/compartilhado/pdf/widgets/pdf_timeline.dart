import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../enums/pdf_template_type.dart';
import '../theme/pdf_theme.dart';

class PdfTimeline {
  // =====================================================
  // TIMELINE
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,

    required List<Map<String, String>> eventos,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    final text = isDark ? PdfThemeConfig.darkText : PdfThemeConfig.cleanText;

    final light = isDark
        ? PdfThemeConfig.darkTextLight
        : PdfThemeConfig.cleanTextLight;

    return pw.Column(
      children: eventos.map((evento) {
        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 18),

          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [
              // =====================================
              // BOLINHA + LINHA
              // =====================================
              pw.Column(
                children: [
                  pw.Container(
                    width: 12,

                    height: 12,

                    decoration: pw.BoxDecoration(
                      color: border,

                      shape: pw.BoxShape.circle,
                    ),
                  ),

                  pw.Container(width: 2, height: 50, color: border),
                ],
              ),

              pw.SizedBox(width: 18),

              // =====================================
              // TEXTO
              // =====================================
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,

                  children: [
                    pw.Text(
                      evento['titulo'] ?? '',

                      style: pw.TextStyle(
                        fontSize: 13,

                        fontWeight: pw.FontWeight.bold,

                        color: text,
                      ),
                    ),

                    pw.SizedBox(height: 4),

                    pw.Text(
                      evento['descricao'] ?? '',

                      style: pw.TextStyle(fontSize: 10, color: light),
                    ),

                    pw.SizedBox(height: 6),

                    pw.Text(
                      evento['hora'] ?? '',

                      style: pw.TextStyle(fontSize: 9, color: light),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
