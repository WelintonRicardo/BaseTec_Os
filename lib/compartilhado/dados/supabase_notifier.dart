// lib/compartilhado/dados/supabase_notifier.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseNotifier {
  SupabaseNotifier._internal();

  static final SupabaseNotifier _instance =
      SupabaseNotifier._internal();

  factory SupabaseNotifier() => _instance;

  final SupabaseClient client =
      Supabase.instance.client;

  bool _started = false;

  RealtimeChannel? _osChannel;
  RealtimeChannel? _execucaoChannel;
  RealtimeChannel? _perfilChannel;

  final _osController =
      StreamController<Map<String, dynamic>>.broadcast();

  final _execucaoController =
      StreamController<Map<String, dynamic>>.broadcast();

  final _perfilController =
      StreamController<Map<String, dynamic>>.broadcast();

  // =====================================================
  // START
  // =====================================================

  void iniciar() {
    if (_started) return;

    _started = true;

    _iniciarOrdensServico();

    _iniciarExecucoesOS();

    _iniciarPerfis();

    debugPrint(
      'SupabaseNotifier iniciado',
    );
  }

  // =====================================================
  // ORDENS SERVIÇO
  // =====================================================

  void _iniciarOrdensServico() {
    _osChannel =
        client.channel('public:ordens_servico');

    _osChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'ordens_servico',
          callback: (payload) {
            _osController.add({
              'event': payload.eventType.name,
              'new': payload.newRecord,
              'old': payload.oldRecord,
              
            });
            
          },
          
        )
        .subscribe();
  }
  

  // =====================================================
  // EXECUÇÕES OS
  // =====================================================

  void _iniciarExecucoesOS() {
    _execucaoChannel =
        client.channel('public:execucoes_os');

    _execucaoChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'execucoes_os',
          callback: (payload) {
            _execucaoController.add({
              'event': payload.eventType.name,
              'new': payload.newRecord,
              'old': payload.oldRecord,
            });
          },
        )
        .subscribe();
  }

  // =====================================================
  // PERFIS
  // =====================================================

  void _iniciarPerfis() {
    _perfilChannel =
        client.channel('public:perfis');

    _perfilChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'perfis',
          callback: (payload) {
            _perfilController.add({
              'event': payload.eventType.name,
              'new': payload.newRecord,
              'old': payload.oldRecord,
            });
          },
        )
        .subscribe();
  }

  // =====================================================
  // STREAMS
  // =====================================================

  Stream<Map<String, dynamic>>
      onOrdensServicoChange() {
    iniciar();

    return _osController.stream;
  }

  Stream<Map<String, dynamic>>
      onExecucoesOSChange() {
    iniciar();

    return _execucaoController.stream;
  }

  Stream<Map<String, dynamic>>
      onProfilesChange() {
    iniciar();

    return _perfilController.stream;
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  Future<void> dispose() async {
    await _osChannel?.unsubscribe();
    await _execucaoChannel?.unsubscribe();
    await _perfilChannel?.unsubscribe();

    await _osController.close();
    await _execucaoController.close();
    await _perfilController.close();

    _started = false;
  }
}