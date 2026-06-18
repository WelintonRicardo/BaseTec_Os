import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../enums/pdf_template_type.dart';
import '../theme/pdf_theme.dart';

class PdfPhotoGrid {
  // =====================================================
  // GRID FOTOS
  // =====================================================

  static pw.Widget build({
    required PdfTemplateType template,
    required List<Uint8List> fotos,
  }) {
    final bool isDark = template == PdfTemplateType.dark;

    final border = isDark
        ? PdfThemeConfig.darkBorder
        : PdfThemeConfig.cleanBorder;

    final background = isDark
        ? PdfThemeConfig.darkCard
        : PdfThemeConfig.cleanCard;

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: background,
        borderRadius: pw.BorderRadius.circular(18),
        border: pw.Border.all(color: border),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              children: [
                pw.Text(
                  'FOTO INICIAL',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.SizedBox(height: 8),
                fotos.isNotEmpty
                    ? pw.Container(
                        height: 180,
                        child: pw.Image(
                          pw.MemoryImage(fotos[0]),
                          fit: pw.BoxFit.cover,
                        ),
                      )
                    : pw.Container(
                        height: 180,
                        alignment: pw.Alignment.center,
                        child: pw.Text('Sem foto'),
                      ),
              ],
            ),
          ),

          pw.SizedBox(width: 20),

          pw.Expanded(
            child: pw.Column(
              children: [
                pw.Text(
                  'FOTO FINAL',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.SizedBox(height: 8),
                fotos.length > 1
                    ? pw.Container(
                        height: 180,
                        child: pw.Image(
                          pw.MemoryImage(fotos[1]),
                          fit: pw.BoxFit.cover,
                        ),
                      )
                    : pw.Container(
                        height: 180,
                        alignment: pw.Alignment.center,
                        child: pw.Text('Sem foto'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
