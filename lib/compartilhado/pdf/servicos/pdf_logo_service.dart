import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PdfLogoService {
  // =====================================================
  // SUPABASE CLIENT
  // =====================================================

  final SupabaseClient supabase =
      Supabase.instance.client;

  // =====================================================
  // SELECIONAR E ENVIAR LOGO
  // =====================================================

  Future<String?> selecionarEEnviarLogo() async {
    try {
      print('====================================');
      print('INICIO UPLOAD LOGO');
      print('====================================');

      // ===============================================
      // IMAGE PICKER
      // ===============================================

      final picker = ImagePicker();

      print('Abrindo seletor de imagem...');

      final imagem = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (imagem == null) {
        print('Usuário cancelou seleção da imagem');
        return null;
      }

      print('Imagem selecionada com sucesso');
      print('PATH => ${imagem.path}');

      // ===============================================
      // BYTES
      // ===============================================

      final Uint8List bytes =
          await imagem.readAsBytes();

      print('BYTES CARREGADOS');
      print('TAMANHO => ${bytes.length}');

      // ===============================================
      // USER
      // ===============================================

      final user =
          supabase.auth.currentUser;

      print('USUARIO => ${user?.id}');

      if (user == null) {
        print('ERRO: usuário não autenticado');

        throw Exception(
          'Usuário não autenticado',
        );
      }

      // ===============================================
      // PERFIL
      // ===============================================

      print('Buscando perfil...');

      final perfil = await supabase
          .from('perfis')
          .select('empresa_id')
          .eq('id', user.id)
          .maybeSingle();

      print('PERFIL => $perfil');

      final empresaId =
          perfil?['empresa_id'];

      print('EMPRESA ID => $empresaId');

      if (empresaId == null) {
        print('ERRO: empresa_id não encontrada');

        throw Exception(
          'empresa_id não encontrada',
        );
      }

      // ===============================================
      // FILE NAME
      // ===============================================

      final fileName =
          'logo_${empresaId}_${DateTime.now().millisecondsSinceEpoch}.png';

      final path =
          '$empresaId/$fileName';

      print('FILE NAME => $fileName');
      print('PATH STORAGE => $path');

      // ===============================================
      // STORAGE
      // ===============================================

      print('Iniciando upload para storage...');

      final storageResponse =
          await supabase.storage
              .from('logos')
              .uploadBinary(
                path,
                bytes,
                fileOptions:
                    const FileOptions(
                  upsert: true,
                ),
              );

      print('UPLOAD FINALIZADO');
      print('STORAGE RESPONSE => $storageResponse');

      // ===============================================
      // URL
      // ===============================================

      final url = supabase.storage
          .from('logos')
          .getPublicUrl(path);

      print('URL GERADA => $url');

      // ===============================================
      // UPDATE EMPRESA
      // ===============================================

      print('Atualizando tabela empresas...');

      final updateResponse =
          await supabase
              .from('empresas')
              .update({
                'logo_url': url,
              })
              .eq('id', empresaId);

      print('UPDATE RESPONSE => $updateResponse');

      print('====================================');
      print('UPLOAD FINALIZADO COM SUCESSO');
      print('====================================');

      return url;
    } catch (e, stack) {
      print('====================================');
      print('ERRO NO UPLOAD DA LOGO');
      print('====================================');

      print('ERRO => $e');

      print('STACK => $stack');

      return null;
    }
  }
}