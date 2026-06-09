import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

class CardSolucao extends StatelessWidget {
  final TextEditingController
      controller;

  const CardSolucao({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppCores.cardEscuro,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              'Solução Aplicada',

              style: TextStyle(
                color:
                    AppCores.textoBranco,

                fontWeight:
                    FontWeight.bold,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: controller,

              maxLines: 5,

              style: const TextStyle(
                color:
                    AppCores.textoBranco,
              ),

              decoration:
                  InputDecoration(
                hintText:
                    'Descreva a solução executada...',

                hintStyle:
                    const TextStyle(
                  color:
                      Colors.white54,
                ),

                filled: true,

                fillColor:
                    AppCores.fundoEscuro,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}