import 'package:flutter/material.dart';

import '../../../tema_cores.dart';

class PdfSectionTitle extends StatelessWidget {

  final String text;

  const PdfSectionTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    return Text(
      text,

      style: const TextStyle(
        color: AppCores.textoBranco,

        fontSize: 18,

        fontWeight: FontWeight.bold,
      ),
    );
  }
}