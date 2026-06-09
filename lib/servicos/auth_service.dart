import 'package:supabase_flutter/supabase_flutter.dart';
import '../arquitetura/supabase_client.dart';
import 'error_handler.dart';

class AuthService {
  static final _client = SupabaseClientInstance.client;

  /// Retorna a role do usuário autenticado ou null.
  static Future<String?> getUserRole() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      // 1) tenta metadata
      final meta = user.userMetadata;
      if (meta != null && meta['role'] != null) return meta['role'].toString();

      // 2) fallback: consulta tabela perfis
      final dynamic res = await _client.from('perfis').select('acesso').eq('id', user.id).maybeSingle();
      // normalização simples
      if (res == null) return null;
      if (res is Map && res['role'] != null) return res['role'].toString();
      try {
        final data = res.data ?? res;
        if (data is Map && data['role'] != null) return data['role'].toString();
      } catch (_) {}
      return null;
    } catch (e, st) {
      ErrorHandler.logError('Erro ao obter role', e, st);
      rethrow;
    }
  }
}
