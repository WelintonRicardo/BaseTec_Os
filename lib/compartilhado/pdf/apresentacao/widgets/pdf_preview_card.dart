import 'package:flutter/material.dart';

import '../../../tema_cores.dart';

import '../../enums/pdf_template_type.dart';

class PdfPreviewCard extends StatelessWidget {
  final PdfTemplateType template;

  final Color corPrimaria;

  final Color corSecundaria;

  const PdfPreviewCard({
    super.key,
    required this.template,
    required this.corPrimaria,
    required this.corSecundaria,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark = template == PdfTemplateType.dark;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: dark ? const Color(0xFF111827) : Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: AppCores.bordaEscura),

        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.15),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // =====================================
          // HEADER PDF
          // =====================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,

                    decoration: BoxDecoration(
                      color: corPrimaria,

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'BaseTec OS',

                        style: TextStyle(
                          color: dark ? Colors.white : Colors.black,

                          fontSize: 20,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Relatório Técnico',

                        style: TextStyle(
                          color: dark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: corSecundaria,

                  borderRadius: BorderRadius.circular(30),
                ),

                child: const Text(
                  'CONCLUÍDO',

                  style: TextStyle(
                    color: Colors.white,

                    fontWeight: FontWeight.bold,

                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // =====================================
          // BLOCOS
          // =====================================
          _fakeBlock(dark: dark, titulo: 'Cliente', valor: 'João da Silva'),

          const SizedBox(height: 14),

          _fakeBlock(
            dark: dark,
            titulo: 'Serviço',
            valor: 'Instalação Hidráulica',
          ),

          const SizedBox(height: 14),

          _fakeBlock(dark: dark, titulo: 'Técnico', valor: 'Carlos Técnico'),

          const SizedBox(height: 28),

          // =====================================
          // ASSINATURAS
          // =====================================
          Row(
            children: [
              Expanded(child: _signature(dark, 'Assinatura Técnico')),

              const SizedBox(width: 20),

              Expanded(child: _signature(dark, 'Assinatura Cliente')),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // BLOCO
  // =====================================================

  Widget _fakeBlock({
    required bool dark,
    required String titulo,
    required String valor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: dark ? Colors.white10 : Colors.grey.shade100,

        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            titulo,

            style: TextStyle(
              color: dark ? Colors.white70 : Colors.black54,

              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            valor,

            style: TextStyle(
              color: dark ? Colors.white : Colors.black,

              fontWeight: FontWeight.bold,

              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ASSINATURA
  // =====================================================

  Widget _signature(bool dark, String titulo) {
    return Column(
      children: [
        Container(height: 1, color: dark ? Colors.white38 : Colors.black26),

        const SizedBox(height: 8),

        Text(
          titulo,

          style: TextStyle(
            color: dark ? Colors.white70 : Colors.black54,

            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
