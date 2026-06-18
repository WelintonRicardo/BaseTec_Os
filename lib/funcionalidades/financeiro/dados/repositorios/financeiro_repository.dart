import 'package:supabase_flutter/supabase_flutter.dart';


class FinanceiroRepository {

  final SupabaseClient _supabase =
      Supabase.instance.client;



  // ==========================================================
  // BUSCAR EMPRESA DO USUÁRIO LOGADO
  // ==========================================================

  Future<String?> obterEmpresaId() async {

    final user =
        _supabase.auth.currentUser;


    if(user == null){

      return null;

    }



    final perfil =
        await _supabase
            .from('perfis')
            .select('empresa_id')
            .eq(
              'id',
              user.id,
            )
            .maybeSingle();



    return perfil?['empresa_id']
        ?.toString();

  }





  // ==========================================================
  // LISTAR LANÇAMENTOS DA EMPRESA
  // ==========================================================

  Future<List<Map<String,dynamic>>>
  listarLancamentos() async {


    final empresaId =
        await obterEmpresaId();



    if(empresaId == null){

      return [];

    }



    final resposta =
        await _supabase
            .from('financeiro_lancamentos')
            .select()
            .eq(
              'empresa_id',
              empresaId,
            )
            .order(
              'data_lancamento',
              ascending:false,
            );



    return List<Map<String,dynamic>>
        .from(resposta);

  }





  // ==========================================================
  // INSERIR LANÇAMENTO MANUAL
  // ==========================================================

  Future<void> inserirLancamento({

    required String titulo,

    required String categoria,

    required double valor,

    required String tipo,

    required String status,

    required String formaPagamento,

    required bool recorrente,

    String? descricao,

    String? observacoes,

  }) async {



    final empresaId =
        await obterEmpresaId();



    if(empresaId == null){

      throw Exception(
        'Empresa não encontrada',
      );

    }



    await _supabase
        .from('financeiro_lancamentos')
        .insert({

          'empresa_id': empresaId,

          'titulo': titulo,

          'descricao': descricao,

          'categoria': categoria,

          'valor': valor,

          'tipo': tipo,

          'status': status,

          'forma_pagamento':
              formaPagamento,

          'recorrente':
              recorrente,

          'observacoes':
              observacoes,

          'data_lancamento':
              DateTime.now()
                  .toIso8601String(),

        });

  }





  // ==========================================================
  // EXCLUIR LANÇAMENTO
  // ==========================================================

  Future<void> excluirLancamento(
    String id,
  ) async {


    final empresaId =
        await obterEmpresaId();



    if(empresaId == null){

      throw Exception(
        'Empresa não encontrada',
      );

    }



    await _supabase
        .from('financeiro_lancamentos')
        .delete()
        .eq(
          'id',
          id,
        )
        .eq(
          'empresa_id',
          empresaId,
        );

  }





  // ==========================================================
  // ATUALIZAR LANÇAMENTO
  // ==========================================================

  Future<void> atualizarLancamento({

    required String id,

    required String titulo,

    required String categoria,

    required double valor,

    required String tipo,

    required String status,

    required String formaPagamento,

    required bool recorrente,

    String? descricao,

    String? observacoes,

  }) async {


    final empresaId =
        await obterEmpresaId();



    if(empresaId == null){

      throw Exception(
        'Empresa não encontrada',
      );

    }



    await _supabase
        .from('financeiro_lancamentos')
        .update({

          'titulo':titulo,

          'descricao':descricao,

          'categoria':categoria,

          'valor':valor,

          'tipo':tipo,

          'status':status,

          'forma_pagamento':
              formaPagamento,

          'recorrente':
              recorrente,

          'observacoes':
              observacoes,

          'atualizado_em':
              DateTime.now()
                  .toIso8601String(),

        })
        .eq(
          'id',
          id,
        )
        .eq(
          'empresa_id',
          empresaId,
        );

  }





  // ==========================================================
  // GERAR FINANCEIRO AUTOMÁTICO DA O.S
  // ==========================================================

  Future<void> gerarLancamentoPorOS(
    Map<String,dynamic> os,
  ) async {


    final empresaId =
        os['empresa_id']
            ?.toString();



    if(empresaId == null){

      return;

    }



    final maoObra =
        double.tryParse(
          os['valor_mao_obra']
              ?.toString() ?? '0',
        ) ?? 0;



    final deslocamento =
        double.tryParse(
          os['valor_deslocamento']
              ?.toString() ?? '0',
        ) ?? 0;



    final pecas =
        double.tryParse(
          os['valor_pecas']
              ?.toString() ?? '0',
        ) ?? 0;



    final total =
        maoObra +
        deslocamento +
        pecas;



    if(total <= 0){

      return;

    }



    await _supabase
        .from('financeiro_lancamentos')
        .insert({

          'empresa_id':
              empresaId,

          'titulo':
              'OS ${os['numero_os'] ?? os['id']}',


          'numero_os':
              os['numero_os'],


          'descricao':
              os['descricao_servico'],


          'categoria':
              'Serviços',


          'valor':
              total,


          'tipo':
              'receita',


          'status':
              'pendente',


          'forma_pagamento':
              'PIX',


          'origem':
              'os',


          'origem_id':
              os['id']
                  .toString(),


          'data_lancamento':
              DateTime.now()
                  .toIso8601String(),

        });

  }

}