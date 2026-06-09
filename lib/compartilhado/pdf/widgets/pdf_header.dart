import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../theme/pdf_theme.dart';
import '../enums/pdf_template_type.dart';

class PdfHeader {
  // =====================================================
  // HEADER PRINCIPAL
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,

    required String empresa,

    required String numeroOs,

    required String status,

    required String tecnico,

    required DateTime data,

    pw.MemoryImage? logo,

    Uint8List? logoBytes,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final background = isDark
        ? PdfThemeConfig.darkCard
        : PdfThemeConfig.cleanCard;

    final primary = isDark
        ? PdfThemeConfig.darkPrimary
        : PdfThemeConfig.cleanPrimary;

    final accent = isDark
        ? PdfThemeConfig.darkAccent
        : PdfThemeConfig.cleanAccent;

    final text = isDark ? PdfThemeConfig.darkText : PdfThemeConfig.cleanText;

    final textLight = isDark
        ? PdfThemeConfig.darkTextLight
        : PdfThemeConfig.cleanTextLight;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    // =====================================================
    // LOGO
    // =====================================================

    pw.Widget logoWidget;

    if (logoBytes != null) {
      final image = pw.MemoryImage(logoBytes);

      logoWidget = pw.Container(
        width: 72,

        height: 72,

        padding: const pw.EdgeInsets.all(6),

        decoration: pw.BoxDecoration(
          color: PdfColors.white,

          borderRadius: pw.BorderRadius.circular(14),
        ),

        child: pw.Image(image, fit: pw.BoxFit.contain),
      );
    } else {
      // FALLBACK CASO NÃO TENHA LOGO

      logoWidget = pw.Container(
        width: 72,

        height: 72,

        alignment: pw.Alignment.center,

        decoration: pw.BoxDecoration(
          color: primary,

          borderRadius: pw.BorderRadius.circular(16),
        ),

        child: pw.Text(
          empresa.isNotEmpty ? empresa[0].toUpperCase() : 'B',

          style: pw.TextStyle(
            color: PdfColors.white,

            fontSize: 28,

            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(24),

      decoration: pw.BoxDecoration(
        color: background,

        borderRadius: pw.BorderRadius.circular(18),

        border: pw.Border.all(color: border, width: 1),
      ),

      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

        children: [
          // =========================================
          // LADO ESQUERDO
          // =========================================
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [
              // =====================================
              // LOGO
              // =====================================
              if (logo != null)
                pw.Container(
                  width: 70,
                  height: 70,

                  margin: const pw.EdgeInsets.only(right: 18),

                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(14),

                    border: pw.Border.all(color: border, width: 1),
                  ),

                  child: pw.ClipRRect(
                    horizontalRadius: 14,
                    verticalRadius: 14,

                    child: pw.Image(logo, fit: pw.BoxFit.cover),
                  ),
                ),

              // =====================================
              // TEXTOS
              // =====================================
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,

                children: [
                  pw.Text(
                    empresa,

                    style: pw.TextStyle(
                      fontSize: 24,

                      fontWeight: pw.FontWeight.bold,

                      color: primary,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  pw.Text(
                    'Relatório Técnico de Serviço',

                    style: pw.TextStyle(fontSize: 12, color: textLight),
                  ),

                  pw.SizedBox(height: 18),

                  _buildStatusBadge(status, accent),
                ],
              ),
            ],
          ),

          // =========================================
          // LADO DIREITO
          // =========================================
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,

            children: [
              pw.Text(
                'ORDEM DE SERVIÇO',

                style: pw.TextStyle(fontSize: 10, color: textLight),
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                '#$numeroOs',

                style: pw.TextStyle(
                  fontSize: 22,

                  fontWeight: pw.FontWeight.bold,

                  color: text,
                ),
              ),

              pw.SizedBox(height: 16),

              _buildInfo('Técnico', tecnico, text, textLight),

              pw.SizedBox(height: 10),

              _buildInfo(
                'Data',
                DateFormat('dd/MM/yyyy HH:mm').format(data),
                text,
                textLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // INFO
  // =====================================================

  static pw.Widget _buildInfo(
    String label,

    String value,

    PdfColor text,

    PdfColor light,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,

      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, color: light)),

        pw.SizedBox(height: 2),

        pw.Text(
          value,

          style: pw.TextStyle(
            fontSize: 12,

            fontWeight: pw.FontWeight.bold,

            color: text,
          ),
        ),
      ],
    );
  }

  // =====================================================
  // STATUS BADGE
  // =====================================================

  static pw.Widget _buildStatusBadge(String status, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 6),

      decoration: pw.BoxDecoration(
        color: color,

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
