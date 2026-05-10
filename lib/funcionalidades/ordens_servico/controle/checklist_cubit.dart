import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../modelos/checklist_modelo.dart';
import '../dados/repositorios/checklist_repository.dart';

/// Definição dos estados do Checklist para controle da UI
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

/// Gerenciador de Negócio (Cubit) para o Checklist e Check-out Automático
class ChecklistCubit extends Cubit<ChecklistState> {
  // Instância do repositório para persistência no Supabase
  final ChecklistRepository _repository = ChecklistRepository();

  ChecklistCubit() : super(ChecklistInitial());

  // Lista de perguntas dinâmicas (Pode ser carregada do banco na Fase 2)
  final List<PerguntaRespondida> perguntas = [
    PerguntaRespondida(pergunta: "O equipamento está ligando?", resposta: "", tipo: "checkbox"),
    PerguntaRespondida(pergunta: "Houve troca de peças?", resposta: "", tipo: "checkbox"),
    PerguntaRespondida(pergunta: "Local ficou limpo e organizado?", resposta: "", tipo: "checkbox"),
  ];

  /// Atualiza a resposta no índice correspondente e notifica a interface
  void atualizarResposta(int index, String valor) {
    perguntas[index] = PerguntaRespondida(
      pergunta: perguntas[index].pergunta,
      resposta: valor,
      tipo: perguntas[index].tipo,
    );
    
    // Notifica a UI para redesenhar os componentes (ChoiceChips)
    emit(ChecklistInitial());
  }

  /// Processo de encerramento da O.S. (GPS + Checklist + Nome)
  Future<void> finalizarAtendimento(String osIdStr, String nomeRecebedor) async {
    emit(ChecklistEnviando());
    
    try {
      // 1. VERIFICAÇÃO DE PERMISSÃO DE GPS
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          throw Exception("Permissão de GPS negada permanentemente.");
        }
      }

      // 2. CAPTURA DE LOCALIZAÇÃO (Check-out)
      Position posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

      // 3. PREPARAÇÃO DOS DADOS
      // Convertemos o ID para int, pois o banco de dados usa BIGINT
      final int osIdInt = int.parse(osIdStr);

      final checklistParaSalvar = ChecklistModelo(
        osId: osIdStr,
        itens: perguntas,
        nomeRecebedor: nomeRecebedor,
      );

      // 4. PERSISTÊNCIA REAL NO SUPABASE
      await _repository.concluirAtendimento(
        osId: osIdInt,
        checklist: checklistParaSalvar,
        lat: posicao.latitude,
        lng: posicao.longitude,
      );

      // Sucesso total no fluxo
      emit(ChecklistSucesso());
    } catch (e) {
      // Captura erros de GPS, Conversão de ID ou Rede
      emit(ChecklistErro("Falha na finalização: ${e.toString()}"));
    }
  }
}
  