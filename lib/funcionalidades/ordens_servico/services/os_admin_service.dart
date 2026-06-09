import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OsAdminService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =========================================================
  // CANCELAR OS
  // =========================================================

  Future<bool> cancelarOS({required String osId}) async {
    try {
      debugPrint('CANCELANDO OS: $osId');

      await _supabase
          .from('ordens_servico')
          .update({'status': 'cancelada'})
          .eq('id', osId);

      debugPrint('OS CANCELADA');

      return true;
    } catch (e) {
      debugPrint('ERRO AO CANCELAR OS: $e');
      return false;
    }
  }

  // =========================================================
  // EXCLUIR OS
  // =========================================================

  Future<bool> excluirOS({required String osId}) async {
    try {
      debugPrint('EXCLUINDO OS: $osId');

      await _supabase.from('ordens_servico').delete().eq('id', osId);

      debugPrint('OS EXCLUIDA');

      return true;
    } catch (e) {
      debugPrint('ERRO AO EXCLUIR OS: $e');
      return false;
    }
  }

  // =========================================================
  // ALTERAR STATUS
  // =========================================================

  Future<bool> alterarStatus({
    required String osId,
    required String novoStatus,
  }) async {
    try {
      debugPrint('ALTERANDO STATUS');

      await _supabase
          .from('ordens_servico')
          .update({'status': novoStatus})
          .eq('id', osId);

      debugPrint('STATUS ALTERADO');

      return true;
    } catch (e) {
      debugPrint('ERRO AO ALTERAR STATUS: $e');
      return false;
    }
  }
}
