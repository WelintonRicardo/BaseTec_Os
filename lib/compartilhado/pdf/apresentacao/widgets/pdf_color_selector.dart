import 'package:flutter/material.dart';

import '../../../tema_cores.dart';

class PdfColorSelector extends StatelessWidget {

  final Color corPrimaria;

  final Color corSecundaria;

  final VoidCallback onPrimaryTap;

  final VoidCallback onSecondaryTap;

  const PdfColorSelector({
    super.key,
    required this.corPrimaria,
    required this.corSecundaria,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        Expanded(
          child: _colorCard(

            titulo: 'Cor Primária',

            cor: corPrimaria,

            onTap: onPrimaryTap,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _colorCard(

            titulo: 'Cor Secundária',

            cor: corSecundaria,

            onTap: onSecondaryTap,
          ),
        ),
      ],
    );
  }

  // =====================================================
  // CARD
  // =====================================================

  Widget _colorCard({
    required String titulo,
    required Color cor,
    required VoidCallback onTap,
  }) {

    return InkWell(

      onTap: onTap,

      borderRadius:
          BorderRadius.circular(18),

      child: Container(

        padding:
            const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color:
              AppCores.cardEscuro,

          borderRadius:
              BorderRadius.circular(18),

          border: Border.all(
            color:
                AppCores.bordaEscura,
          ),
        ),

        child: Column(

          children: [

            Container(

              width: 52,
              height: 52,

              decoration: BoxDecoration(

                color: cor,

                shape:
                    BoxShape.circle,
              ),
            ),

            const SizedBox(height: 14),

            Text(

              titulo,

              style: const TextStyle(
                color:
                    AppCores.textoBranco,
              ),
            ),
          ],
        ),
      ),
    );
  }
}