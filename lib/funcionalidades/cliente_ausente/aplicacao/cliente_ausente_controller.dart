import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../dados/repositorios/cliente_ausente_repository.dart';
import '../dominio/modelos/cliente_ausente_model.dart';

class ClienteAusenteController {
  final observacaoController = TextEditingController();

  final dataController = TextEditingController();

  final horarioController = TextEditingController();

  final repository = ClienteAusenteRepository();

  String? contato1;
  String? contato2;

  String? resultado1;
  String? resultado2;

  XFile? fotoResidencia;

  DateTime? dataFoto;

  double? latitude;
  double? longitude;

  String? fotoUrl;

  String? pdfUrl;

  String? linkPublico;

  // =====================================================
  // INICIAR TELA
  // =====================================================

  void iniciar() {
    final agora = DateTime.now();

    dataController.text =
        '${agora.day.toString().padLeft(2, '0')}/'
        '${agora.month.toString().padLeft(2, '0')}/'
        '${agora.year}';

    horarioController.text =
        '${agora.hour.toString().padLeft(2, '0')}:'
        '${agora.minute.toString().padLeft(2, '0')}';
  }

  // =====================================================
  // VALIDAR
  // =====================================================

  bool validar() {
    return fotoResidencia != null;
  }

  // =====================================================
  // REGISTRAR AUSÊNCIA
  // =====================================================

  Future<void> registrarAusencia({
    required String ordemServicoId,
    required String tecnicoId,
  }) async {
    // ==========================================
    // UPLOAD FOTO
    // ==========================================

    if (fotoResidencia != null) {
      fotoUrl = await repository.uploadFotoResidencia(
        ordemServicoId: ordemServicoId,
        foto: fotoResidencia!,
      );
    }

    // ==========================================
    // BUSCAR EMPRESA DA OS
    // ==========================================

    final empresa = await repository.buscarEmpresaDaOS(ordemServicoId);

    final empresaNome = empresa['nome']?.toString();

    final empresaLogoUrl = empresa['logo_url']?.toString();

    // ==========================================
    // MODEL
    // ==========================================

    final model = ClienteAusenteModel(
      ordemServicoId: ordemServicoId,

      tecnicoId: tecnicoId,

      observacoes: observacaoController.text.trim(),

      contato1: contato1,

      resultadoContato1: resultado1,

      contato2: contato2,

      resultadoContato2: resultado2,

      fotoUrl: fotoUrl,

      latitude: latitude,

      longitude: longitude,

      empresaNome: empresaNome,

      empresaLogoUrl: empresaLogoUrl,

      pdfUrl: pdfUrl,

      linkPublico: linkPublico,

      dataRegistro: DateTime.now(),
    );

    // ==========================================
    // SALVAR + STATUS + HISTÓRICO
    // ==========================================

    await repository.registrarClienteAusente(
      model: model,
      ordemServicoId: ordemServicoId,
    );
  }

  // =====================================================
  // LIMPAR
  // =====================================================

  void limpar() {
    observacaoController.clear();

    contato1 = null;
    contato2 = null;

    resultado1 = null;
    resultado2 = null;

    fotoResidencia = null;

    fotoUrl = null;

    pdfUrl = null;

    linkPublico = null;

    latitude = null;
    longitude = null;
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  void dispose() {
    observacaoController.dispose();

    dataController.dispose();

    horarioController.dispose();
  }
}
