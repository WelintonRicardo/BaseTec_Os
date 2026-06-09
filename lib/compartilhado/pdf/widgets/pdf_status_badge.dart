import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../enums/pdf_template_type.dart';
import '../theme/pdf_theme.dart';

class PdfStatusBadge {
  // =====================================================
  // BADGE STATUS
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,

    required String status,
  }) {
    final statusLower = status.toLowerCase();

    PdfColor background;

    // =====================================================
    // STATUS COLORS
    // =====================================================

    switch (statusLower) {
      case 'concluido':
        background = PdfThemeConfig.success;

        break;

      case 'aguardando peça':
        background = PdfThemeConfig.warning;

        break;

      case 'cliente ausente':
        background = PdfThemeConfig.danger;

        break;

      default:
        background = template == PdfTemplateType.dark
            ? PdfThemeConfig.darkAccent
            : PdfThemeConfig.cleanAccent;
    }

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 7),

      decoration: pw.BoxDecoration(
        color: background,

        borderRadius: pw.BorderRadius.circular(30),
      ),

      child: pw.Text(
        status.toUpperCase(),

        style: pw.TextStyle(
          color: PdfColors.white,

          fontSize: 10,

          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }
}
