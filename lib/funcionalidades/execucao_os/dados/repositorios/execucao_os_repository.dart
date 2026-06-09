import 'package:supabase_flutter/supabase_flutter.dart';

class ExecucaoOSRepository {
  final supabase = Supabase.instance.client;

  // =====================================
  // INICIAR EXECUÇÃO
  // =====================================

  Future<String?> iniciarExecucao({
    required int ordemServicoId,
    required String tecnicoId,
  }) async {
    try {
      print('====================================');
      print('INICIANDO EXECUÇÃO');
      print('OS ID: $ordemServicoId');
      print('TECNICO ID: $tecnicoId');
      print('====================================');

      final dados = {
        'ordem_servico_id': ordemServicoId,
        'tecnico_id': tecnicoId,
        'status_execucao': 'EM_EXECUCAO',
        'inicio_execucao': DateTime.now().toIso8601String(),
      };

      print('DADOS ENVIADOS PARA EXECUCAO');
      print(dados);

      final response = await supabase
          .from('execucoes_os')
          .insert(dados)
          .select()
          .single();

      print('====================================');
      print('EXECUÇÃO CRIADA');
      print(response);
      print('====================================');

      // =====================================
      // ATUALIZAR STATUS DA OS
      // =====================================

      await supabase
          .from('ordens_servico')
          .update({'status': 'EM_EXECUCAO'})
          .eq('id', ordemServicoId);

      print('STATUS DA OS ATUALIZADO');

      return response['id'].toString();
    } catch (e, stack) {
      print('====================================');
      print('ERRO INICIAR EXECUCAO');
      print(e);
      print(stack);
      print('====================================');

      return null;
    }
  }

  // =====================================
  // CRIAR EXECUÇÃO
  // =====================================

  Future<String?> criarExecucao({
    required dynamic ordemServicoId,
    required dynamic tecnicoId,
  }) async {
    try {
      print('====================================');
      print('CRIAR EXECUÇÃO');
      print('ORDEM SERVIÇO ID: $ordemServicoId');
      print('TECNICO ID: $tecnicoId');
      print('====================================');

      final dados = {
        'ordem_servico_id': ordemServicoId,
        'tecnico_id': tecnicoId,
        'status_execucao': 'EM_EXECUCAO',
        'inicio_execucao': DateTime.now().toIso8601String(),
      };

      print('DADOS ENVIADOS');
      print(dados);

      final response = await supabase
          .from('execucoes_os')
          .insert(dados)
          .select()
          .single();

      print('====================================');
      print('EXECUÇÃO CRIADA COM SUCESSO');
      print(response);
      print('====================================');

      return response['id'].toString();
    } catch (e, stack) {
      print('====================================');
      print('ERRO CRIAR EXECUCAO');
      print(e);
      print(stack);
      print('====================================');

      return null;
    }
  }

  // =====================================
  // BUSCAR EXECUÇÃO
  // =====================================

  Future<Map<String, dynamic>?> buscarExecucao(String execucaoId) async {
    try {
      print('====================================');
      print('BUSCANDO EXECUÇÃO');
      print('EXECUCAO ID: $execucaoId');
      print('====================================');

      final response = await supabase
          .from('execucoes_os')
          .select()
          .eq('id', execucaoId)
          .single();

      print('====================================');
      print('EXECUÇÃO ENCONTRADA');
      print(response);
      print('====================================');

      print('CHECKLIST ENCONTRADO');
      print(response['checklist']);

      print('TIPO CHECKLIST');
      print(response['checklist'].runtimeType);

      return response;
    } catch (e, stack) {
      print('====================================');
      print('ERRO BUSCAR EXECUCAO');
      print(e);
      print(stack);
      print('====================================');

      return null;
    }
  }

  // =====================================
  // ATUALIZAR EXECUÇÃO
  // =====================================

  Future<void> atualizarExecucao({
    required String execucaoId,
    required Map<String, dynamic> dados,
  }) async {
    try {
      print('====================================');
      print('ATUALIZANDO EXECUÇÃO');
      print('EXECUCAO ID: $execucaoId');
      print('====================================');

      print('DADOS RECEBIDOS');
      print(dados);

      // =====================================
      // DEBUG CHECKLIST
      // =====================================

      if (dados.containsKey('checklist')) {
        print('====================================');
        print('CHECKLIST ENVIADO');
        print(dados['checklist']);
        print('TIPO CHECKLIST');
        print(dados['checklist'].runtimeType);
        print('====================================');
      }

      await supabase.from('execucoes_os').update(dados).eq('id', execucaoId);

      print('====================================');
      print('EXECUÇÃO ATUALIZADA');
      print('====================================');

      // =====================================
      // VALIDAR SALVAMENTO
      // =====================================

      final validacao = await supabase
          .from('execucoes_os')
          .select()
          .eq('id', execucaoId)
          .single();

      print('====================================');
      print('VALIDAÇÃO APÓS UPDATE');
      print(validacao);
      print('====================================');

      print('CHECKLIST SALVO');
      print(validacao['checklist']);

      print('TIPO CHECKLIST SALVO');
      print(validacao['checklist'].runtimeType);
    } catch (e, stack) {
      print('====================================');
      print('ERRO ATUALIZAR EXECUCAO');
      print(e);
      print(stack);
      print('====================================');
    }
  }

  // =====================================
  // FINALIZAR EXECUÇÃO
  // =====================================

  Future<void> finalizarExecucao({
    required String execucaoId,
    required int duracaoSegundos,
  }) async {
    try {
      print('====================================');
      print('FINALIZANDO EXECUÇÃO');
      print('EXECUCAO ID: $execucaoId');
      print('DURAÇÃO: $duracaoSegundos');
      print('====================================');

      await supabase
          .from('execucoes_os')
          .update({
            'fim_execucao': DateTime.now().toIso8601String(),
            'duracao_segundos': duracaoSegundos,
            'status_execucao': 'FINALIZADO',
          })
          .eq('id', execucaoId);

      print('EXECUÇÃO FINALIZADA');
    } catch (e, stack) {
      print('====================================');
      print('ERRO FINALIZAR EXECUCAO');
      print(e);
      print(stack);
      print('====================================');
    }
  }

  // =====================================
  // EXCLUIR EXECUÇÃO
  // =====================================

  Future<void> excluirExecucao(String execucaoId) async {
    try {
      print('====================================');
      print('EXCLUINDO EXECUÇÃO');
      print('EXECUCAO ID: $execucaoId');
      print('====================================');

      await supabase.from('execucoes_os').delete().eq('id', execucaoId);

      print('EXECUÇÃO EXCLUÍDA');
    } catch (e, stack) {
      print('====================================');
      print('ERRO EXCLUIR EXECUCAO');
      print(e);
      print(stack);
      print('====================================');
    }
  }
}
