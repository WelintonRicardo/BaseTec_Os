import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../compartilhado/dados/supabase_notifier.dart';
import '../dados/repositorios/tecnico_repository.dart';
import '../../rota/services/routes_api_service.dart';

class TecnicoController extends ChangeNotifier {
  final SupabaseNotifier notifier = SupabaseNotifier();

  final TecnicoRepository repository = TecnicoRepository();
  final RoutesApiService routesApi = RoutesApiService();

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

  int totalAtendimentosDia = 0;
  int minutosEstimadosDia = 0;
  double kmEstimadosDia = 0;
  double valorKmEstimadoDia = 0;
  int tempoDeslocamentoDia = 0;

  double kmRetornoResidencia = 0;

  bool rotaOtimizada = true;

  int tempoServicoDia = 0;

  // =====================================================
  // INIT
  // =====================================================

  Future<void> inicializar() async {
    loading = true;
    print('ola passei 1');

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

      await _organizarRotaDoDia();

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

  Future<void> iniciarDeslocamento(Map<String, dynamic> os) async {
    final osId = os['id'];

    if (osId == null) return;

    try {
      await supabase
          .from('ordens_servico')
          .update({'status': 'em_deslocamento'})
          .eq('id', osId);

      await carregarOS(selectedDate);
    } catch (e) {
      debugPrint('ERRO INICIAR DESLOCAMENTO: $e');
    }
  }

  Future<void> _organizarRotaDoDia() async {
    final origemLat = _parseDouble(dadosTecnico?['latitude_residencia']);

    final origemLng = _parseDouble(dadosTecnico?['longitude_residencia']);

    totalAtendimentosDia = osList.length;

    minutosEstimadosDia = 0;
    tempoDeslocamentoDia = 0;

    kmEstimadosDia = 0;
    kmRetornoResidencia = 0;

    valorKmEstimadoDia = 0;

    if (origemLat == null || origemLng == null) {
      return;
    }

    final pendentes = List<Map<String, dynamic>>.from(osList);

    final ordenadas = <Map<String, dynamic>>[];

    double latAtual = origemLat;
    double lngAtual = origemLng;

    while (pendentes.isNotEmpty) {
      int melhorIndice = 0;

      double menorKm = double.infinity;

      RouteInfo? melhorRota;

      for (int i = 0; i < pendentes.length; i++) {
        final os = pendentes[i];

        final lat = _parseDouble(os['latitude_local']);

        final lng = _parseDouble(os['longitude_local']);

        if (lat == null || lng == null) continue;

        final rota = await routesApi.calcularRota(
          origemLat: latAtual,
          origemLng: lngAtual,
          destinoLat: lat,
          destinoLng: lng,
        );

        if (rota == null) continue;

        if (rota.km < menorKm) {
          menorKm = rota.km;

          melhorIndice = i;

          melhorRota = rota;
        }
      }

      final proxima = Map<String, dynamic>.from(
        pendentes.removeAt(melhorIndice),
      );

      final kmTrecho = melhorRota?.km ?? 0;

      final minutosTrecho = melhorRota?.minutos ?? 0;

      proxima['ordem_rota'] = ordenadas.length + 1;

      proxima['km_trecho'] = kmTrecho;

      proxima['minutos_trecho'] = minutosTrecho;

      proxima['km_acumulado'] = kmEstimadosDia + kmTrecho;

      kmEstimadosDia += kmTrecho;

      tempoDeslocamentoDia += minutosTrecho;

      final tempoServico = _calcularMinutosOS(proxima);

      tempoServicoDia += tempoServico;

      final lat = _parseDouble(proxima['latitude_local']);

      final lng = _parseDouble(proxima['longitude_local']);

      if (lat != null && lng != null) {
        latAtual = lat;
        lngAtual = lng;
      }
      minutosEstimadosDia = tempoServicoDia + tempoDeslocamentoDia;
      ordenadas.add(proxima);
    }

    // ==========================
    // RETORNO PARA CASA
    // ==========================

    if (ordenadas.isNotEmpty) {
      final ultima = ordenadas.last;

      final latFinal = _parseDouble(ultima['latitude_local']);

      final lngFinal = _parseDouble(ultima['longitude_local']);

      if (latFinal != null && lngFinal != null) {
        final retorno = await routesApi.calcularRota(
          origemLat: latFinal,
          origemLng: lngFinal,
          destinoLat: origemLat,
          destinoLng: origemLng,
        );

        if (retorno != null) {
          kmRetornoResidencia = retorno.km;

          kmEstimadosDia += retorno.km;

          tempoDeslocamentoDia += retorno.minutos;
        }
      }
    }

    osList = ordenadas;
  }

  int _calcularMinutosOS(Map<String, dynamic> os) {
    final tempo = os['tempo_estimado_minutos'];

    if (tempo == null) {
      return 60;
    }

    if (tempo is int) {
      return tempo;
    }

    return int.tryParse(tempo.toString()) ?? 60;
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString().replaceAll(',', '.'));
  }

  double _calcularDistanciaKm(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const raioTerraKm = 6371.0;
    final dLat = _grausParaRadianos(lat2 - lat1);
    final dLng = _grausParaRadianos(lng2 - lng1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_grausParaRadianos(lat1)) *
            cos(_grausParaRadianos(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    return raioTerraKm * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _grausParaRadianos(double graus) {
    return graus * pi / 180;
  }

  // =====================================================
  // CONTADORES
  // =====================================================

  int contarStatus(String status) {
    final statusFiltro = status.trim().toLowerCase();

    return osList.where((os) {
      final statusOs = os['status']?.toString().trim().toLowerCase() ?? '';

      switch (statusFiltro) {
        case 'concluida':
        case 'concluido':
          return statusOs == 'concluida' || statusOs == 'concluido';

        case 'em_execucao':
        case 'agendada':
          return statusOs == 'em_execucao' || statusOs == 'agendada';

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

    _osSubscription = notifier.onOrdensServicoChange().listen((event) async {
      await _processarEvento(event);
    });

    _execucaoSubscription = notifier.onExecucoesOSChange().listen((
      event,
    ) async {
      await _processarEvento(event);
    });
  }

  Future<void> _processarEvento(Map<String, dynamic> event) async {
    if (dadosTecnico == null) return;

    final novo = event['new'] ?? {};
    final antigo = event['old'] ?? {};

    final tecnicoEvento = novo['tecnico_id'] ?? antigo['tecnico_id'];

    if (tecnicoEvento == null) return;

    if (tecnicoEvento.toString() != dadosTecnico!['id'].toString()) {
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
