import 'dart:typed_data';

import 'package:printing/printing.dart';

class PdfPrintService {
  // =====================================================
  // IMPRIMIR PDF
  // =====================================================

  static Future<void> imprimir(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  // =====================================================
  // PREVIEW PDF
  // =====================================================

  static Future<void> compartilhar(
    Uint8List bytes, {

    required String nomeArquivo,
  }) async {
    await Printing.sharePdf(bytes: bytes, filename: '$nomeArquivo.pdf');
  }
}
