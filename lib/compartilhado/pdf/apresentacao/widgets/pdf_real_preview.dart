import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:printing/printing.dart';

class PdfRealPreview extends StatelessWidget {

  final Future<Uint8List> Function()
      onBuildPdf;

  const PdfRealPreview({
    super.key,
    required this.onBuildPdf,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 500,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(20),

        child: PdfPreview(

          build: (format) async {

            return await onBuildPdf();
          },

          allowPrinting: false,

          allowSharing: false,

          canChangeOrientation: false,

          canChangePageFormat: false,

          canDebug: false,
        ),
      ),
    );
  }
}