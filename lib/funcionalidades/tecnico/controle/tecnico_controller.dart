import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../compartilhado/dados/supabase_notifier.dart';
import '../dados/repositorios/tecnico_repository.dart';

class TecnicoController extends ChangeNotifier {
  final SupabaseNotifier notifier = SupabaseNotifier();

  final TecnicoRepository repository = TecnicoRepository();

  final SupabaseClient supabase = Supabase.instance.client;

  StreamSubscription? _osSubscription;
  StreamSubscription? _execucaoSubscription;

  bool _realtimeIniciado = false;
  bool _disposed = false;

  bool loading = true;

  DateTime selectedDate = DateTime.now();

  DateTime? dataCadastro;

  Map<String, dynamic>? dadosTecnico;

  List<Map<String, dynamic>> osList = [];

  // =====================================================
  // INIT
  // =====================================================

  Future<void> inicializar() async {
    loading = true;

    _safeNotify();

    try {
      await carregarTecnico();

      await carregarOS(selectedDate);

      if (!_realtimeIniciado) {
        iniciarRealtime();
        _realtimeIniciado = true;
      }
    } catch (e) {
      debugPrint('ERRO INIT TECNICO: $e');
    } finally {
      loading = false;

      _safeNotify();
    }
  }

  // =====================================================
  // CARREGAR TÉCNICO
  // =====================================================

  Future<void> carregarTecnico() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) return;

      final tecnico = await repository.buscarTecnicoLogado();

      if (tecnico == null) return;

      dadosTecnico = tecnico;

      dataCadastro = DateTime.tryParse(
        tecnico['data_cadastro']?.toString() ?? '',
      );

      _safeNotify();
    } catch (e) {
      debugPrint('ERRO CARREGAR TECNICO: $e');
    }
  }

  // =====================================================
  // CARREGAR OS
  // =====================================================

  Future<void> carregarOS(DateTime date) async {
    try {
      if (dadosTecnico == null) return;

      final tecnicoId = dadosTecnico!['id'].toString();

      osList = await repository.buscarOSDoTecnico(
        tecnicoId: tecnicoId,
        data: date,
      );

      _safeNotify();
    } catch (e) {
      debugPrint('ERRO CARREGAR OS: $e');
    }
  }

  // =====================================================
  // ALTERAR DATA
  // =====================================================

  Future<void> alterarData(DateTime date) async {
    selectedDate = date;

    _safeNotify();

    await carregarOS(date);
  }

  // =====================================================
// CONTADORES
// =====================================================

int contarStatus(String status) {
  final statusFiltro =
      status.trim().toLowerCase();

  return osList.where((os) {
    final statusOs =
        os['status']
            ?.toString()
            .trim()
            .toLowerCase() ??
        '';

    switch (statusFiltro) {
      case 'concluida':
      case 'concluido':
        return statusOs == 'concluida' ||
            statusOs == 'concluido';

      case 'em_execucao':
      case 'agendada':
        return statusOs == 'em_execucao' ||
            statusOs == 'agendada';

      case 'aguardando_peca':
        return statusOs == 'aguardando_peca';

      case 'retorno':
        return statusOs == 'retorno';

      case 'cancelada':
        return statusOs == 'cancelada';

      case 'pendente':
        return statusOs == 'pendente';

      default:
        return statusOs == statusFiltro;
    }
  }).length;
}

  // =====================================================
  // REALTIME
  // =====================================================

  void iniciarRealtime() {
    _osSubscription?.cancel();
    _execucaoSubscription?.cancel();

    _osSubscription =
        notifier.onOrdensServicoChange().listen(
      (event) async {
        await _processarEvento(event);
      },
    );

    _execucaoSubscription =
        notifier.onExecucoesOSChange().listen(
      (event) async {
        await _processarEvento(event);
      },
    );
  }

  Future<void> _processarEvento(
    Map<String, dynamic> event,
  ) async {
    if (dadosTecnico == null) return;

    final novo = event['new'] ?? {};
    final antigo = event['old'] ?? {};

    final tecnicoEvento =
        novo['tecnico_id'] ??
        antigo['tecnico_id'];

    if (tecnicoEvento == null) return;

    if (tecnicoEvento.toString() !=
        dadosTecnico!['id'].toString()) {
      return;
    }

    await carregarOS(selectedDate);
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;

    _osSubscription?.cancel();
    _execucaoSubscription?.cancel();

    super.dispose();
  }
}