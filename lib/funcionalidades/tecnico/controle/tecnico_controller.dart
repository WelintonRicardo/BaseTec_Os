import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../compartilhado/dados/supabase_notifier.dart';
import '../dados/repositorios/tecnico_repository.dart';

class TecnicoController extends ChangeNotifier {

  final SupabaseNotifier notifier =
    SupabaseNotifier();

StreamSubscription? _osSubscription;

  final TecnicoRepository repository =
      TecnicoRepository();

  final SupabaseClient supabase =
      Supabase.instance.client;

  bool loading = true;

  DateTime selectedDate =
      DateTime.now();

  DateTime? dataCadastro;

  Map<String, dynamic>? dadosTecnico;

  List<Map<String, dynamic>> osList = [];

  // =====================================================
  // INIT
  // =====================================================

  Future<void> inicializar() async {

    loading = true;

    notifyListeners();

    try {

      await carregarTecnico();

      await carregarOS(
        selectedDate,
      );

    } catch (e) {

      print(
        'ERRO INIT TECNICO: $e',
      );

    } finally {

      loading = false;

      notifyListeners();
    }
  }

  // =====================================================
  // CARREGAR TÉCNICO
  // =====================================================

  Future<void> carregarTecnico() async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) {
        return;
      }

      final tecnico =
      await repository
        .buscarTecnicoLogado();

      if (tecnico == null) {
        return;
      }

      dadosTecnico = tecnico;

      dataCadastro =
          DateTime.tryParse(
        tecnico['data_cadastro']
                ?.toString() ??
            '',
      );

      notifyListeners();

    } catch (e) {

      print(
        'ERRO CARREGAR TECNICO: $e',
      );
    }
  }

  // =====================================================
  // CARREGAR OS
  // =====================================================

  Future<void> carregarOS(
    DateTime date,
  ) async {

    try {

      if (dadosTecnico == null) {
        return;
      }

      final tecnicoId =
          dadosTecnico!['id']
              .toString();

      final empresaId =
          dadosTecnico!['empresa_id']
              .toString();

      final inicioDia = DateTime(
        date.year,
        date.month,
        date.day,
      );

      final fimDia =
          inicioDia.add(
        const Duration(days: 1),
      );

      osList =
          await repository
              .buscarOSDoTecnico(
        tecnicoId: tecnicoId,
       
        data: selectedDate,
      );

      notifyListeners();

    } catch (e) {

      print(
        'ERRO CARREGAR OS: $e',
      );
    }
  }

  // =====================================================
  // ALTERAR DATA
  // =====================================================

  Future<void> alterarData(
    DateTime date,
  ) async {

    selectedDate = date;

    notifyListeners();

    await carregarOS(date);
  }

  // =====================================================
  // CONTADORES
  // =====================================================

  int contarStatus(
    String status,
  ) {
    return osList.where((os) {

      return os['status']
              ?.toString()
              .toLowerCase() ==
          status.toLowerCase();

    }).length;
  }

  // =====================================================
// REALTIME
// =====================================================

void iniciarRealtime() {

  _osSubscription?.cancel();

  _osSubscription =
      notifier
          .onOrdensServicoChange()
          .listen((event) async {


    await carregarOS(selectedDate);

  });
}
}
