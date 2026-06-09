import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class PdfLogoRepository {

  // =====================================================
  // CLIENT
  // =====================================================

  final SupabaseClient _client =
      Supabase.instance.client;

  // =====================================================
  // UPLOAD LOGO
  // =====================================================

  Future<String?> uploadLogo({
    required Uint8List bytes,
  }) async {

    try {

      // ===============================================
      // USER
      // ===============================================

      final user =
          _client.auth.currentUser;

      if (user == null) {
        return null;
      }

      // ===============================================
      // PERFIL
      // ===============================================

      final perfil =
          await _client
              .from('perfis')
              .select('empresa_id')
              .eq('id', user.id)
              .maybeSingle();

      final empresaId =
          perfil?['empresa_id'];

      if (empresaId == null) {
        return null;
      }

      // ===============================================
      // FILE NAME
      // ===============================================

      final fileName =
          'logo_${empresaId}_${DateTime.now().millisecondsSinceEpoch}.png';

      // ===============================================
      // UPLOAD
      // ===============================================

      await _client.storage
          .from('logos')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions:
                const FileOptions(
              upsert: true,
            ),
          );

      // ===============================================
      // PUBLIC URL
      // ===============================================

      final url =
          _client.storage
              .from('logos')
              .getPublicUrl(
                fileName,
              );

      // ===============================================
      // UPDATE EMPRESA
      // ===============================================

      await _client
          .from('empresas')
          .update({
            'logo_url': url,
          })
          .eq('id', empresaId);

      return url;

    } catch (e) {

      print(
        'ERRO UPLOAD LOGO: $e',
      );

      return null;
    }
  }
}