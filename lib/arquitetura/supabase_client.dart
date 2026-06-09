// lib/arquitetura/supabase_client.dart
// Cliente Supabase centralizado para todo o projeto.
// - Inicialize Supabase em main.dart antes de usar (Supabase.initialize).
// - Use SupabaseClientInstance.client para acessar o cliente em repositórios/cubits/widgets.

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientInstance {
  /// Retorna a instância global do SupabaseClient.
  /// Lembre-se: chame Supabase.initialize(...) no main.dart antes de usar.
  static SupabaseClient get client {
    return Supabase.instance.client;
  }

  /// Retorna o usuário atual (null se não autenticado).
  static User? obterUsuarioAtual() {
    return Supabase.instance.client.auth.currentUser;
  }

  /// Faz logout do usuário atual.
  static Future<void> sair() async {
    await Supabase.instance.client.auth.signOut();
  }
}
