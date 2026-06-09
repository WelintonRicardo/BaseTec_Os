import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../tema_cores.dart';

class TelaPreviewPdf extends StatelessWidget {

  final Uint8List pdfData;

  const TelaPreviewPdf({
    super.key,
    required this.pdfData,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppCores.fundoEscuro,

      appBar: AppBar(

        backgroundColor:
            AppCores.cardEscuro,

        title: const Text(
          'Preview PDF',
          style: TextStyle(
            color: AppCores.textoBranco,
          ),
        ),
      ),

      body: PdfPreview(

        build: (format) async {
          return pdfData;
        },

        allowPrinting: true,

        allowSharing: true,

        canChangePageFormat: false,

        canDebug: false,
      ),
    );
  }
}