import 'package:flutter/material.dart';

import '../enums/pdf_template_type.dart';

class PdfTemplateDialog {
  // =====================================================
  // SELECIONAR TEMPLATE
  // =====================================================

  static Future<PdfTemplateType?> selecionar(BuildContext context) async {
    return await showDialog<PdfTemplateType>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text('Selecionar Template PDF'),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // ===================================
              // TEMPLATE CLEAN
              // ===================================
              _buildOption(
                context: context,

                title: 'Clean Premium',

                subtitle: 'Visual corporativo claro',

                icon: Icons.description_outlined,

                onTap: () {
                  Navigator.pop(context, PdfTemplateType.clean);
                },
              ),

              const SizedBox(height: 14),

              // ===================================
              // TEMPLATE DARK
              // ===================================
              _buildOption(
                context: context,

                title: 'Dark Premium',

                subtitle: 'Visual elegante escuro',

                icon: Icons.dark_mode_outlined,

                onTap: () {
                  Navigator.pop(context, PdfTemplateType.dark);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // =====================================================
  // CARD TEMPLATE
  // =====================================================

  static Widget _buildOption({
    required BuildContext context,

    required String title,

    required String subtitle,

    required IconData icon,

    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),

      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: Colors.grey.shade300),
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),

                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,

                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
