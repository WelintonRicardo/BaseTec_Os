// lib/funcionalidades/cadastro/apresentacao/telas/cadastro_os/widgets/os_section_title.dart

import 'package:flutter/material.dart';
import '../../../../../../compartilhado/tema_cores.dart';

class OsSectionTitle extends StatelessWidget {
  final String titulo;

  const OsSectionTitle({
    super.key,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Text(
        titulo,
        style: const TextStyle(
          color: AppCores.textoBranco,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}