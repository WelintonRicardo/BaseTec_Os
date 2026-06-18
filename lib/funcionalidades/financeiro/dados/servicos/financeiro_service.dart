import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositorios/financeiro_repository.dart';

import '../../dominio/modelos/transacao_model.dart';

class FinanceiroService {
  final SupabaseClient _supabase = Supabase.instance.client;

  final FinanceiroRepository _repository = FinanceiroRepository();

  RealtimeChannel? _canal;

  // ==========================================================
  // BUSCAR LANÇAMENTOS FINANCEIROS
  // ==========================================================

  Future<List<Transacao>> buscarTransacoes() async {
    final dados = await _repository.listarLancamentos();

    debugPrint('LANÇAMENTOS FINANCEIRO: ${dados.length}');

    return dados.map((item) {
      return Transacao(
        id: item['id'].toString(),

        descricao: item['titulo'] ?? 'Sem descrição',

        valor: double.tryParse(item['valor'].toString()) ?? 0,

        data:
            DateTime.tryParse(item['data_lancamento']?.toString() ?? '') ??
            DateTime.now(),

        isReceita: item['tipo'].toString().toLowerCase() == 'receita',

        categoria: item['categoria'] ?? 'Geral',
      );
    }).toList();
  }

  // ==========================================================
  // INICIAR ESCUTA DAS O.S
  // ==========================================================

  Future<void> iniciar() async {
    final empresaId = await _repository.obterEmpresaId();

    if (empresaId == null) {
      debugPrint('Empresa não encontrada');

      return;
    }

    await _canal?.unsubscribe();

    _canal = _supabase.channel('financeiro-os-$empresaId');

    _canal!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,

          schema: 'public',

          table: 'ordens_servico',

          callback: (payload) async {
            try {
              final novaOS = payload.newRecord;

              if (novaOS['empresa_id']?.toString() != empresaId) {
                return;
              }

              await gerarReceitaOS(novaOS);
            } catch (e) {
              debugPrint('Erro realtime financeiro: $e');
            }
          },
        )
        .subscribe();

    debugPrint('Realtime financeiro iniciado empresa $empresaId');
  }

  // ==========================================================
  // GERAR RECEITA DA O.S
  // ==========================================================

  Future<void> gerarReceitaOS(Map<String, dynamic> os) async {
    try {
      final origemId = os['id']?.toString();

      if (origemId == null) {
        return;
      }

      final existe = await _supabase
          .from('financeiro_lancamentos')
          .select('id')
          .eq('origem', 'os')
          .eq('origem_id', origemId)
          .maybeSingle();

      if (existe != null) {
        return;
      }

      await _repository.gerarLancamentoPorOS(os);

      debugPrint('Financeiro criado para OS $origemId');
    } catch (e) {
      debugPrint('Erro gerarReceitaOS: $e');
    }
  }

  // ==========================================================
  // IMPORTAR O.S EXISTENTES
  // ==========================================================

  Future<void> sincronizarOSExistentes() async {
    final empresaId = await _repository.obterEmpresaId();

    if (empresaId == null) {
      return;
    }

    final listaOS = await _supabase
        .from('ordens_servico')
        .select()
        .eq('empresa_id', empresaId);

    debugPrint('OS encontradas: ${listaOS.length}');

    for (final item in listaOS) {
      await gerarReceitaOS(Map<String, dynamic>.from(item));
    }
  }

  // ==========================================================
  // FINALIZAR
  // ==========================================================

  Future<void> dispose() async {
    await _canal?.unsubscribe();
  }
}
