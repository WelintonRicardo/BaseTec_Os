import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../compartilhado/tema_cores.dart';
import '../../aplicacao/cliente_ausente_controller.dart';

class SecaoFotoResidencia extends StatefulWidget {
  final ClienteAusenteController controller;

  const SecaoFotoResidencia({super.key, required this.controller});

  @override
  State<SecaoFotoResidencia> createState() => _SecaoFotoResidenciaState();
}

class _SecaoFotoResidenciaState extends State<SecaoFotoResidencia> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _webImageBytes;

  Future<void> _abrirCamera() async {
    final foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (foto == null) return;

    if (kIsWeb) {
      _webImageBytes = await foto.readAsBytes();
    }

    setState(() {
      widget.controller.fotoResidencia = foto;
      widget.controller.dataFoto = DateTime.now();
    });
  }

  Future<void> _abrirGaleria() async {
    final foto = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (foto == null) return;

    if (kIsWeb) {
      _webImageBytes = await foto.readAsBytes();
    }

    setState(() {
      widget.controller.fotoResidencia = foto;
      widget.controller.dataFoto = DateTime.now();
    });
  }

  void _removerFoto() {
    setState(() {
      widget.controller.fotoResidencia = null;
      widget.controller.dataFoto = null;
      _webImageBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final foto = widget.controller.fotoResidencia;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppCores.cardEscuro,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.white10),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // =====================================================
          // TÍTULO
          // =====================================================
          const Row(
            children: [
              Icon(Icons.photo_camera, color: AppCores.primaria),

              SizedBox(width: 8),

              Text(
                'Foto da Residência',

                style: TextStyle(
                  color: AppCores.textoBranco,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Tire uma foto que comprove sua presença no local.',

            style: TextStyle(color: Colors.white60),
          ),

          const SizedBox(height: 16),

          // =====================================================
          // PREVIEW
          // =====================================================
          if (foto == null) ...[
            Container(
              height: 220,

              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.black26,

                borderRadius: BorderRadius.circular(14),

                border: Border.all(color: Colors.white10),
              ),

              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.image_outlined, size: 60, color: Colors.white38),

                  SizedBox(height: 12),

                  Text(
                    'Nenhuma foto adicionada',

                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ] else ...[
            kIsWeb
                ? Image.memory(
                    _webImageBytes!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(foto.path),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(height: 12),

            // =====================================================
            // FOTO REGISTRADA
            // =====================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.12),

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.green.withOpacity(.35)),
              ),

              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),

                  SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'Foto registrada com sucesso.',

                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // =====================================================
          // BOTÕES
          // =====================================================
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _abrirCamera,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.primaria,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  icon: const Icon(Icons.camera_alt, color: Colors.white),

                  label: const Text(
                    'Câmera',

                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _abrirGaleria,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.emAndamento,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  icon: const Icon(Icons.photo_library, color: Colors.white),

                  label: const Text(
                    'Galeria',

                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          // =====================================================
          // REMOVER FOTO
          // =====================================================
          if (foto != null) ...[
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,

              child: OutlinedButton.icon(
                onPressed: _removerFoto,

                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                icon: const Icon(Icons.delete_outline, color: Colors.red),

                label: const Text(
                  'Remover Foto',

                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
