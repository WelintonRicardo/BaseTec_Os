// lib/compartilhado/dados/supabase_notifier.dart

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseNotifier {
  final client = Supabase.instance.client;

  /// Escuta mudanças realtime em qualquer tabela.
  ///
  /// Retorna:
  /// {
  ///   'event': 'INSERT|UPDATE|DELETE',
  ///   'new': {},
  ///   'old': {},
  /// }
  Stream<Map<String, dynamic>> onTableChange(String table) {
    late final StreamController<Map<String, dynamic>> controller;

    final channel = client.channel('public:$table');

    controller = StreamController<Map<String, dynamic>>(
      onCancel: () async {
        await client.removeChannel(channel);
      },
    );

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          callback: (payload) {
          
            controller.add({
              'event': payload.eventType.name,
              'new': payload.newRecord,
              'old': payload.oldRecord,
            });
          },
        )
        .subscribe();

    return controller.stream;
  }

  // ==========================================
  // ORDENS SERVIÇO
  // ==========================================

  Stream<Map<String, dynamic>> onOrdensServicoChange() {
    return onTableChange('ordens_servico');
  }

  // ==========================================
  // EXECUÇÕES OS
  // ==========================================

  Stream<Map<String, dynamic>> onExecucoesOSChange() {
    return onTableChange('execucoes_os');
  }

  // ==========================================
  // PERFIS
  // ==========================================

  Stream<Map<String, dynamic>> onProfilesChange() {
    return onTableChange('perfis');
  }
}