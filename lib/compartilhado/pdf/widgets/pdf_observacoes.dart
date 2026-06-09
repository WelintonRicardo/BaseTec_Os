import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../enums/pdf_template_type.dart';
import '../theme/pdf_theme.dart';

class PdfObservacoes {
  // =====================================================
  // OBSERVAÇÕES
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,

    required String texto,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final background = isDark
        ? PdfThemeConfig.darkCard
        : PdfThemeConfig.cleanCard;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    final text = isDark ? PdfThemeConfig.darkText : PdfThemeConfig.cleanText;

    return pw.Container(
      width: double.infinity,

      padding: const pw.EdgeInsets.all(20),

      decoration: pw.BoxDecoration(
        color: background,

        borderRadius: pw.BorderRadius.circular(16),

        border: pw.Border.all(color: border, width: 1),
      ),

      child: pw.Text(
        texto,

        style: pw.TextStyle(fontSize: 11, lineSpacing: 4, color: text),
      ),
    );
  }
}
