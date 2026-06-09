import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cliente_model.dart';
import '../repository/cliente_repository.dart';
import '../regras/cliente_sync_rule.dart';

class ClienteService {
  late final ClienteRepository repository;

  late final ClienteSyncRule syncRule;

  ClienteService() {
    final client = Supabase.instance.client;

    repository = ClienteRepository(client);

    syncRule = ClienteSyncRule(repository);
  }

  // =========================================================
  // SINCRONIZAR CLIENTE
  // =========================================================

  Future<void> sincronizarCliente(ClienteModel cliente) async {
    await syncRule.sincronizar(cliente);
  }
}