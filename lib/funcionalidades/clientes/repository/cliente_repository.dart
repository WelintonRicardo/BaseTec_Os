import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cliente_model.dart';

class ClienteRepository {
  final SupabaseClient client;

  ClienteRepository(this.client);

  // =========================================================
  // BUSCAR CLIENTE POR NOME
  // =========================================================

  Future<ClienteModel?> buscarPorNome({
    required String empresaId,
    required String nome,
  }) async {
    try {
      final response = await client
          .from('clientes')
          .select()
          .eq('empresa_id', empresaId)
          .eq('nome_segurado', nome.trim())
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return ClienteModel.fromMap(response);
    } catch (e) {
      debugPrint('ERRO AO BUSCAR CLIENTE: $e');
      return null;
    }
  }

  // =========================================================
  // BUSCAR CLIENTES PARA AUTOCOMPLETE
  // =========================================================

  Future<List<Map<String, dynamic>>> buscarClientes({
    required String empresaId,
    required String busca,
  }) async {
    try {
      if (busca.trim().isEmpty) {
        return [];
      }

      final response = await client
          .from('clientes')
          .select()
          .eq('empresa_id', empresaId)
          .ilike('nome_segurado', '%${busca.trim()}%')
          .order('nome_segurado')
          .limit(10);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('ERRO AUTOCOMPLETE CLIENTES: $e');
      return [];
    }
  }

  // =========================================================
  // INSERIR CLIENTE
  // =========================================================

  Future<void> inserir(ClienteModel cliente) async {
    try {
      await client.from('clientes').insert(cliente.toMap());
    } catch (e) {
      debugPrint('ERRO AO INSERIR CLIENTE: $e');
      rethrow;
    }
  }

  // =========================================================
  // ATUALIZAR CLIENTE
  // =========================================================

  Future<void> atualizar({
    required String id,
    required ClienteModel cliente,
  }) async {
    try {
      await client.from('clientes').update(cliente.toMap()).eq('id', id);
    } catch (e) {
      debugPrint('ERRO AO ATUALIZAR CLIENTE: $e');
      rethrow;
    }
  }
}
