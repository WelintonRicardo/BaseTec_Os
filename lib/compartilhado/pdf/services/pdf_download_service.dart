import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class PdfDownloadService {
  // =====================================================
  // SALVAR PDF
  // =====================================================

  static Future<File> salvarPdf({
    required Uint8List bytes,

    required String nomeArquivo,
  }) async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$nomeArquivo.pdf');

    await file.writeAsBytes(bytes);

    return file;
  }
}
