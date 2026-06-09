import 'package:supabase_flutter/supabase_flutter.dart';
import '../modelos/ordem_servico_modelo.dart';
import 'dart:io';

class RepositorioOS {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<List<OrdemServicoModelo>> streamOrdens(
    String tecnicoId,
    String empresaId,
  ) {
    return _supabase
        .from('ordens_servico')
        .stream(primaryKey: ['id'])
        .map(
          (dados) => dados
              .where(
                (mapa) =>
                    mapa['empresa_id'].toString() == empresaId &&
                    mapa['tecnico_id'].toString() == tecnicoId,
              )
              .map((mapa) {
                try {
                  return OrdemServicoModelo.fromMap(mapa);
                } catch (e) {
            
                  rethrow;
                }
              }).toList(),
        );
  }

  Future<void> atualizarStatusOS(
    String osId,
    String novoStatus,
    Map<String, dynamic> dadosExtras,
  ) async {
    await _supabase.from('ordens_servico').update({
      'status': novoStatus,
      ...dadosExtras,
    }).eq('id', osId);
  }

  Future<String> enviarFoto(
    String osId,
    File arquivo,
    String tipo,
  ) async {
    final nomeArquivo =
        '${tipo}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final caminho = '$osId/$nomeArquivo';

    // Upload da foto
    await _supabase.storage
        .from('fotos_os')
        .upload(caminho, arquivo);

    // URL pública
    final urlPublica = _supabase.storage
        .from('fotos_os')
        .getPublicUrl(caminho);

    // Salva referência
    await _supabase.from('midias_os').insert({
      'os_id': osId,
      'url_foto': urlPublica,
      'tipo': tipo,
    });

    return urlPublica;
  }
}