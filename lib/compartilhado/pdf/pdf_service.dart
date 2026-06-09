import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import 'gerador_pdf_os.dart';

class PdfService {
  // =====================================================
  // VISUALIZAR PDF
  // =====================================================

  static Future<void> visualizarPdf({
    required Map<String, dynamic> os,
    required Map<String, dynamic> tecnico,
  }) async {
    try {
      final Uint8List pdfBytes = await GeradorPdfOs.gerar(
        os: os,
        tecnico: tecnico,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      await Printing.layoutPdf(
        onLayout: (_) async {
          return pdfBytes;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // =====================================================
  // SALVAR PDF
  // =====================================================

  static Future<String> salvarPdf({
    required Map<String, dynamic> os,
    required Map<String, dynamic> tecnico,
  }) async {
    try {
      final Uint8List pdfBytes = await GeradorPdfOs.gerar(
        os: os,
        tecnico: tecnico,
      );

      // =========================================
      // WEB
      // =========================================

      if (kIsWeb) {
        throw Exception(
          'Salvar PDF localmente não é suportado no Flutter Web.',
        );
      }

      final dir = await getApplicationDocumentsDirectory();

      final numeroOs = os['numero_os']?.toString() ?? 'os';

      final path = '${dir.path}/OS_$numeroOs.pdf';

      final file = File(path);

      await file.writeAsBytes(pdfBytes);

      return path;
    } catch (e) {
      rethrow;
    }
  }

  // =====================================================
  // COMPARTILHAR PDF
  // =====================================================

  static Future<void> compartilharPdf({
    required Map<String, dynamic> os,
    required Map<String, dynamic> tecnico,
  }) async {
    try {
      final Uint8List pdfBytes = await GeradorPdfOs.gerar(
        os: os,
        tecnico: tecnico,
      );

      final numeroOs = os['numero_os']?.toString() ?? 'os';

      await Printing.sharePdf(bytes: pdfBytes, filename: 'OS_$numeroOs.pdf');
    } catch (e) {
      rethrow;
    }
  }
}
