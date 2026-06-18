import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

class CardFotos extends StatelessWidget {
  final File? fotoInicio;
  final File? fotoFim;

  final String? fotoInicioUrl;
  final String? fotoFimUrl;

  final VoidCallback onCapturarFotoInicio;

  final VoidCallback onCapturarFotoFim;

  const CardFotos({
    super.key,
    required this.fotoInicio,
    required this.fotoFim,
    required this.fotoInicioUrl,
    required this.fotoFimUrl,
    required this.onCapturarFotoInicio,
    required this.onCapturarFotoFim,
  });

  Widget _buildImagem(File foto) {
    // =====================================
    // WEB
    // =====================================

    if (kIsWeb) {
      return Image.network(
        foto.path,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // =====================================
    // MOBILE
    // =====================================

    return Image.file(
      foto,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildCardFoto({
    required String titulo,
    required File? foto,
    required String? fotoUrl,
    required String textoBotao,
    required Color corBotao,
    required VoidCallback onPressed,
  }) {
    return Card(
      color: AppCores.cardEscuro,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: AppCores.textoBranco,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            // =====================================
            // FOTO
            // =====================================
            if (foto != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImagem(foto),
              )
            else if (fotoUrl != null && fotoUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  fotoUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;

                    return const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 220,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppCores.fundoEscuro,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Nenhuma foto capturada',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: corBotao,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: onPressed,
              icon: const Icon(Icons.camera_alt, color: AppCores.textoBranco),
              label: Text(
                textoBotao,
                style: const TextStyle(color: AppCores.textoBranco),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCardFoto(
          titulo: 'Foto Inicial',
          foto: fotoInicio,
          fotoUrl: fotoInicioUrl,
          textoBotao: 'Capturar Foto Inicial',
          corBotao: AppCores.primaria,
          onPressed: onCapturarFotoInicio,
        ),

        const SizedBox(height: 20),

        _buildCardFoto(
          titulo: 'Foto Final',
          foto: fotoFim,
          fotoUrl: fotoFimUrl,
          textoBotao: 'Capturar Foto Final',
          corBotao: AppCores.concluido,
          onPressed: onCapturarFotoFim,
        ),
      ],
    );
  }
}
