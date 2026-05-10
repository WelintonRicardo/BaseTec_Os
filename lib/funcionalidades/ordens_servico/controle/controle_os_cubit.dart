import 'package:flutter_bloc/flutter_bloc.dart';
import '../dados/repositorio_os.dart';
import '../modelos/ordem_servico_modelo.dart';
import '../../../arquitetura/servico_localizacao.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  Future<void> realizarCheckIn(String osId) async {
    try {
      final posicao = await ServicoLocalizacao().obterPosicaoAtual();
      
      final dadosCheckIn = {
        'status': 'em_atendimento',
        'horario_chegada_real': DateTime.now().toIso8601String(),
        'latitude_local': posicao.latitude,
        'longitude_local': posicao.longitude,
      };

      await _repositorio.atualizarStatusOS(osId, 'em_atendimento', dadosCheckIn);
    } catch (e) {
      emit(EstadoOSErro("Falha no Check-in: $e"));
    }
  }

  Future<void> capturarEFazerUploadFoto(String osId, String tipo) async {
    final picker = ImagePicker();
    final XFile? foto = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (foto != null) {
      try {
        // Aqui você pode emitir um estado de "Enviando Foto..."
        await _repositorio.enviarFoto(osId, File(foto.path), tipo);
        // Sucesso! O Real-time pode atualizar a UI se necessário
      } catch (e) {
        emit(EstadoOSErro("Erro ao enviar foto: $e"));
      }
    }
  }
}
                  