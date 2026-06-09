import 'package:supabase_flutter/supabase_flutter.dart';

class PdfTecnicoRepository {
  // =====================================================
  // CLIENT
  // =====================================================

  final SupabaseClient _client = Supabase.instance.client;

  // =====================================================
  // BUSCAR TECNICO
  // =====================================================

  Future<Map<String, dynamic>?> buscarTecnico() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        return null;
      }

      final response = await _client
          .from('perfis')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      return response;
    } catch (e) {
      print('ERRO BUSCAR TECNICO PDF: $e');

      return null;
    }
  }
}
