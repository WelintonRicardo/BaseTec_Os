import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../dados/fontes_dados/os_storage_service.dart';
import '../dados/repositorios/os_repository.dart';
import '../modelos/os_fotos_model.dart';
import 'package:uuid/uuid.dart';

// Estados
abstract class OSFormState {}
class OSFormInitial extends OSFormState {}
class OSFormCarregando extends OSFormState {}
class OSFormSucesso extends OSFormState { final String url; OSFormSucesso(this.url); }
class OSFormErro extends OSFormState { final String mensagem; OSFormErro(this.mensagem); }

class OSFormularioCubit extends Cubit<OSFormState> {
  final OSStorageService storage = OSStorageService();
  final OSRepository repository = OSRepository();

  OSFormularioCubit() : super(OSFormInitial());

  Future<void> tirarFoto(String osId, String tipo) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (image == null) return;

    emit(OSFormCarregando());

    try {
      final file = File(image.path);
      final url = await storage.uploadFoto(file, osId);

      final fotoModel = OSFotoModel(
        id: const Uuid().v4(),
        osId: osId,
        url: url,
        tipo: tipo,
        criadoEm: DateTime.now(),
      );

      await repository.salvarDadosFoto(fotoModel);
      emit(OSFormSucesso(url));
    } catch (e) {
      emit(OSFormErro("Erro ao enviar foto: $e"));
    }
  }
}
