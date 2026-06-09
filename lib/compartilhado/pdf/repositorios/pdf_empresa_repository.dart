import 'package:supabase_flutter/supabase_flutter.dart';

class PdfEmpresaRepository {
  // =====================================================
  // CLIENT
  // =====================================================

  final SupabaseClient _client = Supabase.instance.client;

  // =====================================================
  // BUSCAR CONFIGURAÇÕES
  // =====================================================

  Future<Map<String, dynamic>?> buscarConfiguracoes() async {
    try {
      // ===============================================
      // USER
      // ===============================================

      final user = _client.auth.currentUser;

      if (user == null) {
        return null;
      }

      // ===============================================
      // PERFIL
      // ===============================================

      final perfil = await _client
          .from('perfis')
          .select('empresa_id')
          .eq('id', user.id)
          .maybeSingle();

      if (perfil == null) {
        return null;
      }

      final empresaId = perfil['empresa_id'];

      if (empresaId == null) {
        return null;
      }

      // ===============================================
      // EMPRESA
      // ===============================================

      final empresa = await _client
          .from('empresas')
          .select('''
                id,
                nome,
                logo_url,
                pdf_template,
                pdf_cor_primaria,
                pdf_cor_secundaria
              ''')
          .eq('id', empresaId)
          .maybeSingle();

      if (empresa == null) {
        return null;
      }

      // ===============================================
      // RETORNO PADRONIZADO
      // ===============================================

      return {
        'empresa_id': empresa['id'],

        'nome': empresa['nome'],

        'logo_url': empresa['logo_url'],

        'pdf_template': empresa['pdf_template'],

        'pdf_cor_primaria': empresa['pdf_cor_primaria'],

        'pdf_cor_secundaria': empresa['pdf_cor_secundaria'],
      };
    } catch (e) {
      print('ERRO PDF CONFIG: $e');

      return null;
    }
  }

  // =====================================================
  // BUSCAR EMPRESA ID
  // =====================================================

  Future<String?> buscarEmpresaId() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        return null;
      }

      final perfil = await _client
          .from('perfis')
          .select('empresa_id')
          .eq('id', user.id)
          .maybeSingle();

      return perfil?['empresa_id'];
    } catch (e) {
      print('ERRO EMPRESA ID: $e');

      return null;
    }
  }

  // =====================================================
  // SALVAR LOGO
  // =====================================================

  Future<void> salvarLogoUrl({required String url}) async {
    try {
      final empresaId = await buscarEmpresaId();

      if (empresaId == null) {
        return;
      }

      await _client
          .from('empresas')
          .update({'logo_url': url})
          .eq('id', empresaId);
    } catch (e) {
      print('ERRO SALVAR LOGO URL: $e');
    }
  }

  // =====================================================
  // SALVAR CONFIG PDF
  // =====================================================

  Future<void> salvarConfiguracoes({
    required String template,

    required String corPrimaria,

    required String corSecundaria,
  }) async {
    try {
      final empresaId = await buscarEmpresaId();

      if (empresaId == null) {
        return;
      }

      await _client
          .from('empresas')
          .update({
            'pdf_template': template,

            'pdf_cor_primaria': corPrimaria,

            'pdf_cor_secundaria': corSecundaria,
          })
          .eq('id', empresaId);
    } catch (e) {
      print('ERRO SALVAR CONFIG PDF: $e');
    }
  }
}
