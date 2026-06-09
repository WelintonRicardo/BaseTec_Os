import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../modelos/checklist_modelo.dart';
import '../dados/repositorios/checklist_repository.dart';

/// ===============================================
/// STATES
/// ===============================================

abstract class ChecklistState {
  const ChecklistState();
}

class ChecklistInitial extends ChecklistState {}

class ChecklistEnviando extends ChecklistState {}

class ChecklistSucesso extends ChecklistState {}

class ChecklistErro extends ChecklistState {
  final String mensagem;

  const ChecklistErro(this.mensagem);
}

/// ===============================================
/// CUBIT
/// ===============================================

class ChecklistCubit extends Cubit<ChecklistState> {
  final ChecklistRepository _repository = ChecklistRepository();

  ChecklistCubit() : super(ChecklistInitial());

  /// ===============================================
  /// PERGUNTAS
  /// ===============================================

  final List<PerguntaRespondida> perguntas = [
    PerguntaRespondida(
      pergunta: "O equipamento está ligando?",
      resposta: "",
      tipo: "checkbox",
    ),

    PerguntaRespondida(
      pergunta: "Houve troca de peças?",
      resposta: "",
      tipo: "checkbox",
    ),

    PerguntaRespondida(
      pergunta: "Local ficou limpo e organizado?",
      resposta: "",
      tipo: "checkbox",
    ),
  ];

  /// ===============================================
  /// ATUALIZAR RESPOSTA
  /// ===============================================

  void atualizarResposta(int index, String valor) {
    perguntas[index] = PerguntaRespondida(
      pergunta: perguntas[index].pergunta,
      resposta: valor,
      tipo: perguntas[index].tipo,
    );

    emit(ChecklistInitial());
  }

  /// ===============================================
  /// FINALIZAR
  /// ===============================================

  Future<void> finalizarAtendimento(
    String osIdStr,
    String nomeRecebedor,
  ) async {
    emit(ChecklistEnviando());

    try {
      /// ===========================================
      /// GPS
      /// ===========================================

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.deniedForever) {
          throw Exception("Permissão de GPS negada permanentemente.");
        }
      }

      /// ===========================================
      /// POSIÇÃO
      /// ===========================================

      Position posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      /// ===========================================
      /// CONVERTE ID
      /// ===========================================

      final int osIdInt = int.parse(osIdStr);

      /// ===========================================
      /// CHECKLIST MODEL
      /// ===========================================

      final checklistParaSalvar = ChecklistModelo(
        osId: osIdStr,
        itens: perguntas,
        nomeRecebedor: nomeRecebedor,
      );

      /// ===========================================
      /// SALVAR
      /// ===========================================

      await _repository.concluirAtendimento(
        osId: osIdInt,

        checklist: checklistParaSalvar,

        lat: posicao.latitude,

        lng: posicao.longitude,
      );

      emit(ChecklistSucesso());
    } catch (e) {
      emit(ChecklistErro("Falha na finalização: ${e.toString()}"));
    }
  }
}
