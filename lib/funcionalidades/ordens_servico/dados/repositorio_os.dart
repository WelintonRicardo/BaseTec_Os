import 'package:supabase_flutter/supabase_flutter.dart';
import '../modelos/ordem_servico_modelo.dart';

class RepositorioOS {
  final _supabase = Supabase.instance.client;

  Stream<List<OrdemServicoModelo>> streamOrdens(String tecnicoId, String empresaId) {
    // No Supabase, o stream escuta a tabela toda e você filtra os dados que chegam
    return _supabase
        .from('ordens_servico')
        .stream(primaryKey: ['id'])
        .map((dados) => dados
            .where((mapa) => 
                mapa['empresa_id'].toString() == empresaId && 
                mapa['tecnico_id'].toString() == tecnicoId)
            .map((mapa) => OrdemServicoModelo.fromMap(mapa))
            .toList());
  }

  Future<void> atualizarStatusOS(String osId, String novoStatus, Map<String, dynamic> dadosExtras) async {
    await _supabase
        .from('ordens_servico')
        .update({
          'status': novoStatus,
          ...dadosExtras,
        })
        .eq('id', osId);
  }
}
