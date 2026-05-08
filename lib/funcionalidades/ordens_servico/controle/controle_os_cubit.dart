import 'package:flutter_bloc/flutter_bloc.dart';
import '../dados/repositorio_os.dart';
import '../modelos/ordem_servico_modelo.dart';

// Definição dos Estados
abstract class EstadoOS {}
class EstadoOSCarregando extends EstadoOS {}
class EstadoOSSucesso extends EstadoOS {
  final List<OrdemServicoModelo> listaOrdens;
  EstadoOSSucesso(this.listaOrdens);
}
class EstadoOSErro extends EstadoOS {
  final String mensagem;
  EstadoOSErro(this.mensagem);
}

class ControleOSCubit extends Cubit<EstadoOS> {
  final RepositorioOS _repositorio = RepositorioOS();

  ControleOSCubit() : super(EstadoOSCarregando());

  // Escuta as ordens em tempo real (Real-time)
  void escutarOrdens(String tecnicoId, String empresaId) {
    emit(EstadoOSCarregando());

    // Aqui chamamos o 'streamOrdens' que definimos no RepositorioOS
    _repositorio.streamOrdens(tecnicoId, empresaId).listen(
      (novasOrdens) {
        emit(EstadoOSSucesso(novasOrdens));
      },
      onError: (erro) {
        emit(EstadoOSErro("Erro ao sincronizar dados: $erro"));
      },
    );
  }

  // Função para o técnico bater o ponto (Check-in/Out)
  Future<void> mudarStatus(String osId, String novoStatus, Map<String, dynamic> dados) async {
    try {
      await _repositorio.atualizarStatusOS(osId, novoStatus, dados);
    } catch (e) {
      emit(EstadoOSErro("Não foi possível atualizar o status."));
    }
  }
}
