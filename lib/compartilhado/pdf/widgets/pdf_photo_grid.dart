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

    if (fotos.isEmpty) {
      return pw.Container(
        height: 120,

        alignment: pw.Alignment.center,

        decoration: pw.BoxDecoration(
          color: background,

          borderRadius: pw.BorderRadius.circular(18),

          border: pw.Border.all(color: border),
        ),

        child: pw.Text('Nenhuma foto adicionada'),
      );
    }

    return pw.Wrap(
      spacing: 12,

      runSpacing: 12,

      children: fotos.map((foto) {
        return pw.Container(
          width: 240,

          height: 180,

          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(14),

            border: pw.Border.all(color: border),
          ),

          child: pw.ClipRRect(
            horizontalRadius: 14,

            verticalRadius: 14,

            child: pw.Image(pw.MemoryImage(foto), fit: pw.BoxFit.cover),
          ),
        );
      }).toList(),
    );
  }
}
