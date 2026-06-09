import 'package:supabase_flutter/supabase_flutter.dart';

class PdfConfigRepository {
  // =====================================================
  // CLIENT
  // =====================================================

  final SupabaseClient _client = Supabase.instance.client;

  // =====================================================
  // BUSCAR CONFIG
  // =====================================================

  Future<Map<String, dynamic>?> buscarConfigEmpresa() async {
    try {
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

      final empresaId = perfil?['empresa_id'];

      if (empresaId == null) {
        return null;
      }

      // ===============================================
      // EMPRESA
      // ===============================================

      final empresa = await _client
          .from('empresas')
          .select('''
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

      return {
        'nome': empresa['nome'],
        'logo_url': empresa['logo_url'],
        'template': empresa['pdf_template'],
        'cor_primaria': empresa['pdf_cor_primaria'],
        'cor_secundaria': empresa['pdf_cor_secundaria'],
      };
    } catch (e) {
      print('ERRO CONFIG PDF: $e');

      return null;
    }
  }

  // =====================================================
  // SALVAR CONFIG
  // =====================================================

  Future<void> salvarConfiguracao({
    required String template,

    required String corPrimaria,

    required String corSecundaria,
  }) async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        return;
      }

      // ===============================================
      // PERFIL
      // ===============================================

      final perfil = await _client
          .from('perfis')
          .select('empresa_id')
          .eq('id', user.id)
          .maybeSingle();

      final empresaId = perfil?['empresa_id'];

      if (empresaId == null) {
        return;
      }

      // ===============================================
      // UPDATE
      // ===============================================

      await _client
          .from('empresas')
          .update({
            'pdf_template': template,

            'pdf_cor_primaria': corPrimaria,

            'pdf_cor_secundaria': corSecundaria,
          })
          .eq('id', empresaId);
    } catch (e) {
      print('ERRO SALVAR PDF CONFIG: $e');
    }
  }
}
