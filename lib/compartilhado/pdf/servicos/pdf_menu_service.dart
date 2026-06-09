import 'package:flutter/material.dart';

import '../dados/repositorios/pdf_os_repository.dart';
import '../dados/repositorios/pdf_tecnico_repository.dart';

import '../pdf_service.dart';

class PdfMenuService {
  // =====================================================
  // REPOSITORY TECNICO
  // =====================================================

  final PdfTecnicoRepository tecnicoRepository = PdfTecnicoRepository();

  // =====================================================
  // REPOSITORY OS
  // =====================================================

  final PdfOsRepository osRepository = PdfOsRepository();

  // =====================================================
  // VISUALIZAR PDF
  // =====================================================

  Future<void> visualizarPdf({
    required BuildContext context,
    required Map<String, dynamic> os,
  }) async {
    try {
      // =========================================
      // LOADING
      // =========================================

      _showLoading(context);

      // =========================================
      // BUSCAR TECNICO
      // =========================================

      final tecnico = await tecnicoRepository.buscarTecnico();

      if (tecnico == null) {
        _hideLoading(context);

        _snack(context, 'Técnico não encontrado');

        return;
      }

      // =========================================
      // BUSCAR OS COMPLETA
      // =========================================

      final osCompleta = await osRepository.buscarOsPorId(os['id']);

      if (osCompleta == null) {
        _hideLoading(context);

        _snack(context, 'Erro ao carregar OS completa');

        return;
      }

      // =========================================
      // GERAR PDF
      // =========================================
      await Future.delayed(const Duration(milliseconds: 300));
      await PdfService.visualizarPdf(os: osCompleta, tecnico: tecnico);

      // =========================================
      // FECHAR LOADING
      // =========================================

      _hideLoading(context);
    } catch (e) {
      _hideLoading(context);

      debugPrint('ERRO PDF VIEW: $e');

      _snack(context, 'Erro ao visualizar PDF');
    }
  }

  // =====================================================
  // BAIXAR PDF
  // =====================================================

  Future<void> baixarPdf({
    required BuildContext context,
    required Map<String, dynamic> os,
  }) async {
    try {
      // =========================================
      // LOADING
      // =========================================

      _showLoading(context);

      // =========================================
      // BUSCAR TECNICO
      // =========================================

      final tecnico = await tecnicoRepository.buscarTecnico();

      if (tecnico == null) {
        _hideLoading(context);

        _snack(context, 'Técnico não encontrado');

        return;
      }

      // =========================================
      // BUSCAR OS COMPLETA
      // =========================================

      final osCompleta = await osRepository.buscarOsPorId(os['id']);

      if (osCompleta == null) {
        _hideLoading(context);

        _snack(context, 'Erro ao carregar OS completa');

        return;
      }

      // =========================================
      // SALVAR PDF
      // =========================================

      final path = await PdfService.salvarPdf(os: osCompleta, tecnico: tecnico);

      // =========================================
      // FECHAR LOADING
      // =========================================

      _hideLoading(context);

      _snack(context, 'PDF salvo em:\n$path');
    } catch (e) {
      _hideLoading(context);

      debugPrint('ERRO PDF DOWNLOAD: $e');

      _snack(context, 'Erro ao baixar PDF');
    }
  }

  // =====================================================
  // COMPARTILHAR PDF
  // =====================================================

  Future<void> compartilharPdf({
    required BuildContext context,
    required Map<String, dynamic> os,
  }) async {
    try {
      // =========================================
      // LOADING
      // =========================================

      _showLoading(context);

      // =========================================
      // BUSCAR TECNICO
      // =========================================

      final tecnico = await tecnicoRepository.buscarTecnico();

      if (tecnico == null) {
        _hideLoading(context);

        _snack(context, 'Técnico não encontrado');

        return;
      }

      // =========================================
      // BUSCAR OS COMPLETA
      // =========================================

      final osCompleta = await osRepository.buscarOsPorId(os['id']);

      if (osCompleta == null) {
        _hideLoading(context);

        _snack(context, 'Erro ao carregar OS completa');

        return;
      }

      // =========================================
      // COMPARTILHAR PDF
      // =========================================

      await PdfService.compartilharPdf(os: osCompleta, tecnico: tecnico);

      // =========================================
      // FECHAR LOADING
      // =========================================

      _hideLoading(context);
    } catch (e) {
      _hideLoading(context);

      debugPrint('ERRO PDF SHARE: $e');

      _snack(context, 'Erro ao compartilhar PDF');
    }
  }

  // =====================================================
  // LOADING
  // =====================================================

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator.adaptive(),

              SizedBox(width: 20),

              Expanded(child: Text('Gerando PDF...')),
            ],
          ),
        );
      },
    );
  }

  void _hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // =====================================================
  // SNACK
  // =====================================================

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
