import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../dados/repositorios/pdf_config_repository.dart';
import '../dados/repositorios/pdf_logo_repository.dart';
import '../enums/pdf_template_type.dart';

class PdfCentralController extends ChangeNotifier {
  // =====================================================
  // REPOSITORIES
  // =====================================================

  final PdfConfigRepository repository = PdfConfigRepository();

  final PdfLogoRepository logoRepository = PdfLogoRepository();

  // =====================================================
  // CONFIGURAÇÕES
  // =====================================================

  PdfTemplateType template = PdfTemplateType.clean;

  Color corPrimaria = Colors.blue;

  Color corSecundaria = Colors.orange;

  String? logoUrl;

  bool salvando = false;

  bool enviandoLogo = false;

  // =====================================================
  // INIT
  // =====================================================

  Future<void> inicializar() async {
    debugPrint('====================================');
    debugPrint('INICIALIZANDO PDF CENTRAL CONTROLLER');
    debugPrint('====================================');

    await carregarConfiguracoes();
  }

  // =====================================================
  // CARREGAR CONFIG
  // =====================================================

  Future<void> carregarConfiguracoes() async {
    try {
      debugPrint('CARREGANDO CONFIGURAÇÕES PDF...');

      final config = await repository.buscarConfigEmpresa();

      debugPrint('CONFIG RECEBIDA => $config');

      if (config == null || config is! Map<String, dynamic>) {
        debugPrint('CONFIG INVÁLIDA OU NULA');
        return;
      }

      // ===============================================
      // TEMPLATE
      // ===============================================

      final templateDb = config['template']?.toString();

      debugPrint('TEMPLATE DB => $templateDb');

      template = templateDb == 'dark'
          ? PdfTemplateType.dark
          : PdfTemplateType.clean;

      // ===============================================
      // CORES
      // ===============================================

      final primaria = config['cor_primaria']?.toString();

      final secundaria = config['cor_secundaria']?.toString();

      debugPrint('COR PRIMARIA => $primaria');
      debugPrint('COR SECUNDARIA => $secundaria');

      corPrimaria = _hexToColor(primaria);

      corSecundaria = _hexToColor(secundaria);

      // ===============================================
      // LOGO
      // ===============================================

      logoUrl = config['logo_url']?.toString();

      debugPrint('LOGO URL => $logoUrl');

      notifyListeners();

      debugPrint('CONFIGURAÇÕES CARREGADAS');
    } catch (e, stack) {
      debugPrint('====================================');
      debugPrint('ERRO CARREGAR CONFIG PDF');
      debugPrint('ERRO => $e');
      debugPrint('STACK => $stack');
      debugPrint('====================================');
    }
  }

  // =====================================================
  // SALVAR CONFIGURAÇÕES
  // =====================================================

  Future<void> salvarConfiguracoes() async {
    try {
      debugPrint('====================================');
      debugPrint('SALVANDO CONFIGURAÇÕES PDF');

      salvando = true;

      notifyListeners();

      await repository.salvarConfiguracao(
        template: template == PdfTemplateType.dark ? 'dark' : 'clean',
        corPrimaria: colorToHex(corPrimaria),
        corSecundaria: colorToHex(corSecundaria),
      );

      debugPrint('CONFIGURAÇÕES SALVAS COM SUCESSO');
    } catch (e, stack) {
      debugPrint('====================================');
      debugPrint('ERRO SALVAR PDF CONFIG');
      debugPrint('ERRO => $e');
      debugPrint('STACK => $stack');
      debugPrint('====================================');
    } finally {
      salvando = false;

      notifyListeners();
    }
  }

  // =====================================================
  // ALTERAR TEMPLATE
  // =====================================================

  void alterarTemplate(PdfTemplateType value) {
    template = value;

    notifyListeners();
  }

  // =====================================================
  // ALTERAR CORES
  // =====================================================

  void trocarCorPrimaria() {
    corPrimaria = corPrimaria == Colors.blue ? Colors.purple : Colors.blue;

    notifyListeners();
  }

  void trocarCorSecundaria() {
    corSecundaria = corSecundaria == Colors.orange
        ? Colors.green
        : Colors.orange;

    notifyListeners();
  }

  // =====================================================
  // LOGO
  // =====================================================

  void atualizarLogo(String url) {
    logoUrl = url;

    notifyListeners();
  }

  // =====================================================
  // SELECIONAR LOGO
  // =====================================================

  Future<void> selecionarLogo() async {
    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        return;
      }

      enviandoLogo = true;

      notifyListeners();

      final bytes = await image.readAsBytes();

      final url = await logoRepository.uploadLogo(bytes: bytes);

      if (url != null && url.isNotEmpty) {
        atualizarLogo(url);
      }
    } catch (e, stack) {
      debugPrint('ERRO SELECT LOGO');
      debugPrint('$e');
      debugPrint('$stack');
    } finally {
      enviandoLogo = false;

      notifyListeners();
    }
  }

  // =====================================================
  // HELPERS
  // =====================================================

  Color _hexToColor(String? hex) {
    try {
      if (hex == null || hex.isEmpty) {
        return Colors.blue;
      }

      final cleanHex = hex.replaceAll('#', '');

      final buffer = StringBuffer();

      if (cleanHex.length == 6) {
        buffer.write('ff');
      }

      buffer.write(cleanHex);

      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      debugPrint('ERRO AO CONVERTER HEX => $e');

      return Colors.blue;
    }
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
