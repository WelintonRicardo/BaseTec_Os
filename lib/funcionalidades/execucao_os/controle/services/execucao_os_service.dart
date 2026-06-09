import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class ExecucaoOSService {
  final supabase = Supabase.instance.client;

  // =========================================================
  // SALVAR EXECUÇÃO COMPLETA
  // =========================================================

  Future<void> salvarExecucaoCompleta({
    required String execucaoId,
    required String solicitacao,
    required String defeito,
    required String solucao,
    required String observacaoFinal,
    required String statusFinal,
    required bool reparoEfetuado,
    List<Map<String, dynamic>>? checklist, // <-- NOVO
  }) async {
    try {
      debugPrint('================================');
      debugPrint('SALVAR EXECUCAO COMPLETA');
      debugPrint('EXECUCAO ID: $execucaoId');

      if (execucaoId.trim().isEmpty) {
        throw Exception('Execução ID inválido');
      }

      final dados = {
        'solicitacao_cliente': solicitacao.trim(),
        'defeito_constatado': defeito.trim(),
        'solucao_aplicada': solucao.trim(),
        'observacao_final': observacaoFinal.trim(),
        'status_final': statusFinal,
        'reparo_efetuado': reparoEfetuado,
        'updated_at': DateTime.now().toIso8601String(),
        if (checklist != null) 'checklist': jsonEncode(checklist), // <-- aqui
      };

      debugPrint('DADOS ENVIADOS:');
      debugPrint(dados.toString());

      final response = await supabase
          .from('execucoes_os')
          .update(dados)
          .eq('id', execucaoId)
          .select();

      if (response.isEmpty) {
        throw Exception('Nenhuma execução foi atualizada no banco');
      }

      debugPrint('================================');
      debugPrint('EXECUÇÃO SALVA COM SUCESSO');
      debugPrint(response.toString());
      debugPrint('================================');
    } on PostgrestException catch (e) {
      debugPrint('POSTGREST ERROR SALVAR EXECUCAO');
      debugPrint(e.message);
      throw Exception('Erro banco salvar execução: ${e.message}');
    } catch (e, stack) {
      debugPrint('================================');
      debugPrint('ERRO SALVAR EXECUCAO COMPLETA');
      debugPrint(e.toString());
      debugPrint(stack.toString());
      debugPrint('================================');
      rethrow;
    }
  }

  // =========================================================
  // FINALIZAR EXECUÇÃO
  // =========================================================

  Future<void> finalizarExecucao({
    required String execucaoId,
    required dynamic ordemServicoId,
    required int duracaoSegundos,
    required String statusFinal,
  }) async {
    try {
      debugPrint('================================');
      debugPrint('FINALIZAR EXECUCAO');
      debugPrint('EXECUCAO ID: $execucaoId');
      debugPrint('OS ID: $ordemServicoId');
      debugPrint('STATUS FINAL: $statusFinal');
      debugPrint('DURACAO: $duracaoSegundos');
      debugPrint('================================');

      if (execucaoId.trim().isEmpty) {
        throw Exception('Execução ID inválido');
      }

      if (ordemServicoId == null) {
        throw Exception('Ordem de serviço inválida');
      }

      // =========================================================
      // ATUALIZA EXECUÇÃO
      // =========================================================

      final dadosExecucao = {
        'fim_execucao': DateTime.now().toIso8601String(),
        'duracao_segundos': duracaoSegundos,
        'status_execucao': 'finalizado',
        'status_final': statusFinal,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final responseExecucao = await supabase
          .from('execucoes_os')
          .update(dadosExecucao)
          .eq('id', execucaoId)
          .select();

      if (responseExecucao.isEmpty) {
        throw Exception('Falha ao finalizar execução no banco');
      }

      debugPrint('================================');
      debugPrint('EXECUÇÃO FINALIZADA');
      debugPrint(responseExecucao.toString());
      debugPrint('================================');

      // =========================================================
      // ATUALIZA STATUS DA OS
      // =========================================================

      final responseOs = await supabase
          .from('ordens_servico')
          .update({
            'status': statusFinal,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', ordemServicoId)
          .select();

      if (responseOs.isEmpty) {
        throw Exception('Falha ao atualizar status da OS');
      }

      debugPrint('================================');
      debugPrint('STATUS OS ATUALIZADO');
      debugPrint(responseOs.toString());
      debugPrint('================================');

      // =========================================================
      // BUSCAR EXECUÇÃO FINAL
      // =========================================================

      final execucaoFinal = await supabase
          .from('execucoes_os')
          .select()
          .eq('id', execucaoId)
          .maybeSingle();

      if (execucaoFinal == null) {
        throw Exception('Execução final não encontrada');
      }

      debugPrint('================================');
      debugPrint('EXECUCAO FINAL BANCO');
      debugPrint(execucaoFinal.toString());
      debugPrint('================================');
    } on PostgrestException catch (e) {
      debugPrint('POSTGREST ERROR FINALIZAR');
      debugPrint(e.message);

      throw Exception('Erro banco finalizar execução: ${e.message}');
    } catch (e, stack) {
      debugPrint('================================');
      debugPrint('ERRO FINALIZAR EXECUCAO');
      debugPrint(e.toString());
      debugPrint(stack.toString());
      debugPrint('================================');

      rethrow;
    }
  }
}
