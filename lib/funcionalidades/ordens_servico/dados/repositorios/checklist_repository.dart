import 'package:supabase_flutter/supabase_flutter.dart';
import '../../modelos/checklist_modelo.dart';

class ChecklistRepository {
  final _supabase = Supabase.instance.client;

  Future<void> concluirAtendimento({
    required int osId,
    required ChecklistModelo checklist,
    required double lat,
    required double lng,
  }) async {
    // 1. Salva o Checklist na tabela 'checklists'
    await _supabase.from('checklists').insert({
      'os_id': osId,
      'dados': checklist.itens.map((e) => e.toMap()).toList(),
      'nome_recebedor': checklist.nomeRecebedor,
      'assinatura_cliente_url': checklist.assinaturaClienteUrl,
    });

    // 2. Atualiza a Ordem de Serviço com Check-out e GPS
    await _supabase.from('ordens_servico').update({
      'status': 'concluida',
      'horario_saida_real': DateTime.now().toIso8601String(),
      'latitude_local': lat,
      'longitude_local': lng,
    }).eq('id', osId);
  }
}
