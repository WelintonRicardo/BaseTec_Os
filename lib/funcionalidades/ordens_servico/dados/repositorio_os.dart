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

  // ==========================================
  // UPLOAD STORAGE
  // ==========================================

  await _supabase.storage
      .from('fotos_os')
      .upload(
        caminho,
        arquivo,
        fileOptions: const FileOptions(
          upsert: true,
        ),
      );

  final urlPublica = _supabase.storage
      .from('fotos_os')
      .getPublicUrl(caminho);

  print('================================');
  print('FOTO ENVIADA');
  print(urlPublica);
  print('================================');

  // ==========================================
  // BUSCA EXECUÇÃO MAIS RECENTE
  // ==========================================

  final execucao = await _supabase
      .from('execucoes_os')
      .select('id')
      .eq('ordem_servico_id', int.parse(osId))
      .order(
        'criado_em',
        ascending: false,
      )
      .limit(1)
      .maybeSingle();

  print('================================');
  print('EXECUCAO');
  print(execucao);
  print('================================');

  if (execucao != null) {
    print('================================');
    print('EXECUCAO ENCONTRADA');
    print(execucao['id']);
    print('TIPO FOTO: $tipo');
    print('================================');

    if (tipo == 'inicio') {
      await _supabase
          .from('execucoes_os')
          .update({
            'foto_inicio': urlPublica,
          })
          .eq(
            'id',
            execucao['id'],
          );

      print('FOTO INICIO SALVA');
    }

    if (tipo == 'fim') {
      await _supabase
          .from('execucoes_os')
          .update({
            'foto_fim': urlPublica,
          })
          .eq(
            'id',
            execucao['id'],
          );

      print('FOTO FIM SALVA');
    }
  } else {
    print('================================');
    print('NENHUMA EXECUCAO ENCONTRADA');
    print('OS ID: $osId');
    print('================================');
  }

  return urlPublica;
}

}