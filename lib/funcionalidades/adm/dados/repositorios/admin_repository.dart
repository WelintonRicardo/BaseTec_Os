
// lib/funcionalidades/adm/admin_repository.dart
// Repositório responsável por operações CRUD na tabela "perfis" (admins/gestores).
// Compatível com diferentes versões do SDK supabase_flutter.
// - Normaliza respostas dinamicamente (List, Map, objetos com data/error).
// - Lança Exception com mensagens legíveis em caso de falha.

import 'package:supabase_flutter/supabase_flutter.dart';

class AdminRepository {
  final SupabaseClient _client = Supabase.instance.client;

  AdminRepository();

  /// Normaliza respostas do Supabase de forma segura.
  Map<String, dynamic> _normalizarResposta(dynamic res) {
    try {
      if (res is List || res is Map) {
        return {'data': res, 'error': null};
      }

      final dynamic dyn = res;
      final dynamic maybeError = dyn.error;
      final dynamic maybeData = dyn.data;

      if (maybeError != null) {
        return {'data': maybeData, 'error': maybeError};
      }

      if (maybeData != null) {
        return {'data': maybeData, 'error': null};
      }

      if (res is Iterable) {
        return {'data': List.from(res), 'error': null};
      }

      return {'data': res, 'error': null};
    } catch (_) {
      if (res is List || res is Map) {
        return {'data': res, 'error': null};
      }
      return {'data': res, 'error': null};
    }
  }

  /// Lista todos os usuários (admins/gestores) ordenados por nome.
  Future<List<Map<String, dynamic>>> listarUsuarios() async {
    try {
      final dynamic res = await _client.from('perfis').select().order('nome');
      final normalized = _normalizarResposta(res);

      if (normalized['error'] != null) {
        throw Exception(_extrairMensagemErro(normalized['error']));
      }

      final data = normalized['data'];
      if (data == null) return [];

      if (data is Map) return [Map<String, dynamic>.from(data)];
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      throw Exception('Falha ao listar usuários: $e');
    }
  }

  /// Busca um usuário pelo id.
  Future<Map<String, dynamic>?> buscarUsuarioPorId(String id) async {
    try {
      final dynamic res =
          await _client.from('perfis').select().eq('id', id).maybeSingle();
      final normalized = _normalizarResposta(res);

      if (normalized['error'] != null) {
        throw Exception(_extrairMensagemErro(normalized['error']));
      }

      final data = normalized['data'];
      if (data == null) return null;

      if (data is List && data.isNotEmpty) {
        return Map<String, dynamic>.from(data.first as Map);
      }
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (e) {
      throw Exception('Falha ao buscar usuário: $e');
    }
  }

  /// Cria um novo usuário (admin/gestor).
  Future<Map<String, dynamic>> criarUsuario(Map<String, dynamic> dados) async {
    try {
      final dynamic res =
          await _client.from('perfis').insert(dados).select().single();
      final normalized = _normalizarResposta(res);

      if (normalized['error'] != null) {
        throw Exception(_extrairMensagemErro(normalized['error']));
      }

      final data = normalized['data'];
      if (data == null) throw Exception('Resposta vazia ao criar usuário.');

      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      throw Exception('Formato de resposta inesperado ao criar usuário.');
    } catch (e) {
      throw Exception('Falha ao criar usuário: $e');
    }
  }

  /// Atualiza um usuário existente.
  Future<Map<String, dynamic>> atualizarUsuario(
      String id, Map<String, dynamic> dados) async {
    try {
      final dynamic res = await _client
          .from('perfis')
          .update(dados)
          .eq('id', id)
          .select()
          .single();
      final normalized = _normalizarResposta(res);

      if (normalized['error'] != null) {
        throw Exception(_extrairMensagemErro(normalized['error']));
      }

      final data = normalized['data'];
      if (data == null) throw Exception('Resposta vazia ao atualizar usuário.');

      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      throw Exception('Formato de resposta inesperado ao atualizar usuário.');
    } catch (e) {
      throw Exception('Falha ao atualizar usuário: $e');
    }
  }

  /// Remove um usuário pelo id.
  Future<bool> deletarUsuario(String id) async {
    try {
      await _client.from('perfis').delete().eq('id', id);
      return true;
    } catch (e) {
      throw Exception('Falha ao deletar usuário: $e');
    }
  }

  /// Helper para extrair mensagem de erro.
  String _extrairMensagemErro(dynamic error) {
    try {
      if (error == null) return 'Erro desconhecido';
      if (error is String) return error;
      final dynamic dyn = error;
      final dynamic msg = dyn.message ?? dyn.msg ?? dyn.toString();
      return msg?.toString() ?? 'Erro desconhecido';
    } catch (_) {
      return error.toString();
    }
  }
}
