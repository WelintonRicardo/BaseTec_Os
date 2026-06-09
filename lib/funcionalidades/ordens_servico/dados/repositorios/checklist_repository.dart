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
    /// ==========================================
    /// SALVA TABELA CHECKLISTS
    /// ==========================================

    await _supabase.from('checklists').insert({
      'os_id': osId,

      'dados': checklist.itens
          .map((e) => e.toMap())
          .toList(),

      'nome_recebedor':
          checklist.nomeRecebedor,

      'assinatura_cliente_url':
          checklist.assinaturaClienteUrl,
    });

    /// ==========================================
    /// BUSCA ÚLTIMA EXECUÇÃO
    /// ==========================================

    final execucao = await _supabase
        .from('execucoes_os')
        .select('id')
        .eq('ordem_servico_id', osId)
        .order('inicio_execucao',
            ascending: false)
        .limit(1)
        .maybeSingle();

    /// ==========================================
    /// SALVA CHECKLIST NA EXECUÇÃO
    /// ==========================================

    if (execucao != null) {
      await _supabase
          .from('execucoes_os')
          .update({
            'checklist': checklist.itens
                .map((e) => e.toMap())
                .toList(),
          })
          .eq('id', execucao['id']);
    }

    /// ==========================================
    /// ATUALIZA OS
    /// ==========================================

    await _supabase
        .from('ordens_servico')
        .update({
          'status': 'concluida',

          'horario_saida_real':
              DateTime.now()
                  .toIso8601String(),

          'latitude_local': lat,

          'longitude_local': lng,
        })
        .eq('id', osId);
  }
}