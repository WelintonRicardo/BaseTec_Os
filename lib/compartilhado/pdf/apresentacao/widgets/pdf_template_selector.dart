import 'package:flutter/material.dart';

import '../../../tema_cores.dart';
import '../../enums/pdf_template_type.dart';

class PdfTemplateSelector extends StatelessWidget {
  final PdfTemplateType template;

  final Color corPrimaria;

  final Function(PdfTemplateType) onChanged;

  const PdfTemplateSelector({
    super.key,
    required this.template,
    required this.corPrimaria,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _templateCard(
            title: 'Clean',

            icon: Icons.description_outlined,

            selected: template == PdfTemplateType.clean,

            onTap: () {
              onChanged(PdfTemplateType.clean);
            },
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _templateCard(
            title: 'Dark',

            icon: Icons.dark_mode_rounded,

            selected: template == PdfTemplateType.dark,

            onTap: () {
              onChanged(PdfTemplateType.dark);
            },
          ),
        ),
      ],
    );
  }

  // =====================================================
  // TEMPLATE CARD
  // =====================================================

  Widget _templateCard({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: selected ? corPrimaria : AppCores.cardEscuro,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: selected ? corPrimaria : AppCores.bordaEscura,
          ),
        ),

        child: Column(
          children: [
            Icon(icon, size: 42, color: Colors.white),

            const SizedBox(height: 12),

            Text(
              title,

              style: const TextStyle(
                color: Colors.white,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
