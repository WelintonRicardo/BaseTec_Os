import 'dart:typed_data';

import 'package:printing/printing.dart';

class PdfPreviewService {

  // =====================================================
  // PREVIEW PDF
  // =====================================================

  static Future<void> preview(
    Uint8List pdfBytes,
  ) async {

    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
    );
  }
}