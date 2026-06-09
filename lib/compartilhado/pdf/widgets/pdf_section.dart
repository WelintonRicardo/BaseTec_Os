import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../enums/pdf_template_type.dart';
import '../theme/pdf_theme.dart';

class PdfSection {
  // =====================================================
  // SECTION CARD
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,

    required String title,

    required List<pw.Widget> children,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final background = isDark
        ? PdfThemeConfig.darkCard
        : PdfThemeConfig.cleanCard;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    final text = isDark ? PdfThemeConfig.darkText : PdfThemeConfig.cleanText;

    final accent = isDark
        ? PdfThemeConfig.darkAccent
        : PdfThemeConfig.cleanAccent;

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 18),

      padding: const pw.EdgeInsets.all(20),

      decoration: pw.BoxDecoration(
        color: background,

        borderRadius: pw.BorderRadius.circular(18),

        border: pw.Border.all(color: border, width: 1),
      ),

      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        children: [
          // =========================================
          // HEADER SECTION
          // =========================================
          pw.Row(
            children: [
              pw.Container(
                width: 6,
                height: 24,

                decoration: pw.BoxDecoration(
                  color: accent,

                  borderRadius: pw.BorderRadius.circular(30),
                ),
              ),

              pw.SizedBox(width: 12),

              pw.Text(
                title,

                style: pw.TextStyle(
                  fontSize: 18,

                  fontWeight: pw.FontWeight.bold,

                  color: text,
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 18),

          // =========================================
          // CONTENT
          // =========================================
          ...children,
        ],
      ),
    );
  }

  // =====================================================
  // INFO LINE
  // =====================================================

  static pw.Widget infoLine({
    required PdfTemplateType template,

    required String label,

    required String value,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final text = isDark ? PdfThemeConfig.darkText : PdfThemeConfig.cleanText;

    final light = isDark
        ? PdfThemeConfig.darkTextLight
        : PdfThemeConfig.cleanTextLight;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),

      padding: const pw.EdgeInsets.only(bottom: 10),

      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: border, width: .5)),
      ),

      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        children: [
          // LABEL
          pw.SizedBox(
            width: 140,

            child: pw.Text(
              label,

              style: pw.TextStyle(
                fontSize: 11,

                color: light,

                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          // VALUE
          pw.Expanded(
            child: pw.Text(
              value.isEmpty ? '-' : value,

              style: pw.TextStyle(fontSize: 12, color: text),
            ),
          ),
        ],
      ),
    );
  }
}
