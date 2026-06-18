import 'package:supabase_flutter/supabase_flutter.dart';

class PdfOsRepository {
  // =====================================================
  // CLIENT
  // =====================================================

  final SupabaseClient _client = Supabase.instance.client;

  // =====================================================
  // BUSCAR PRIMEIRA OS
  // =====================================================

  Future<Map<String, dynamic>?> buscarPrimeiraOs() async {
    try {
      final response = await _client
          .from('ordens_servico')
          .select('''
            *,
            execucoes_os (
              id,
  checklist,
  observacoes,
  observacao_final,
  status_final,
  inicio_execucao,
  fim_execucao,
  criado_em,
  solicitacao_cliente,
  defeito_constatado,
  solucao_aplicada,
  reparo_efetuado,
  assinatura_cliente_url,
  assinatura_tecnico_url,
  foto_inicio,
  foto_fim
            )
          ''')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      print('================================');
      print('OS PDF COMPLETA');
      print(response);
      print('================================');

      print('================================');
      print('EXECUCOES OS');
      print(response?['execucoes_os']);
      print('================================');

      final execucoes = response?['execucoes_os'];

      if (execucoes is List && execucoes.isNotEmpty) {
        final execucoesOrdenadas =
    List<Map<String, dynamic>>.from(execucoes);

execucoesOrdenadas.sort(
  (a, b) => DateTime.parse(
    b['criado_em'],
  ).compareTo(
    DateTime.parse(a['criado_em']),
  ),
);

final ultimaExecucaoFinalizada =
    execucoesOrdenadas.firstWhere(
      (e) =>
          e['status_execucao']
              .toString()
              .toLowerCase() ==
          'finalizado',
      orElse: () => execucoesOrdenadas.first,
    );

        print('================================');
        print('ULTIMA EXECUCAO');
        print(ultimaExecucaoFinalizada);
        print('================================');

        print('================================');
        print('SOLICITACAO');
        print(ultimaExecucaoFinalizada['solicitacao_cliente']);
        print('================================');

        print('================================');
        print('DEFEITO');
        print(ultimaExecucaoFinalizada['defeito_constatado']);
        print('================================');

        print('================================');
        print('SOLUCAO');
        print(ultimaExecucaoFinalizada['solucao_aplicada']);
        print('================================');

        print('================================');
        print('OBSERVACAO FINAL');
        print(ultimaExecucaoFinalizada['observacao_final']);
        print('================================');

        print('================================');
        print('FOTO INICIO');
        print(ultimaExecucaoFinalizada['foto_inicio']);
        print('================================');

        print('================================');
        print('FOTO FIM');
        print(ultimaExecucaoFinalizada['foto_fim']);
        print('================================');

        print('================================');
        print('ASSINATURA CLIENTE');
        print(ultimaExecucaoFinalizada['assinatura_cliente_url']);
        print('================================');

        print('================================');
        print('ASSINATURA TECNICO');
        print(ultimaExecucaoFinalizada['assinatura_tecnico_url']);
        print('================================');

        print('================================');
        print('CHECKLIST');
        print(ultimaExecucaoFinalizada['checklist']);
        print('================================');
      } else {
        print('================================');
        print('NENHUMA EXECUCAO ENCONTRADA');
        print('================================');
      }

      return response;
    } catch (e, stack) {
      print('================================');
      print('ERRO BUSCAR OS PDF');
      print(e);
      print(stack);
      print('================================');

      return null;
    }
  }

  Future<Map<String, dynamic>?> buscarOsPorId(dynamic id) async {
    try {
      final response = await _client
          .from('ordens_servico')
          .select('''
          *,
              execucoes_os(
                *,
                tecnico:tecnico_id(*)
              )
        ''')
          .eq('id', id)
          .maybeSingle();

      print('================================');
      print('OS COMPLETA PDF');
      print(response);
      print('================================');

      return response;
    } catch (e, stack) {
      print('================================');
      print('ERRO BUSCAR OS COMPLETA');
      print(e);
      print(stack);
      print('================================');

      return null;
    }
  }
}
