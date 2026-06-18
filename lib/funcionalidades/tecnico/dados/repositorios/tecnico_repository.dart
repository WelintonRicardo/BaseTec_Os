// lib/funcionalidades/tecnico/dados/repositorios/tecnico_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class TecnicoRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ======================================================
  // BUSCA DADOS DO DASHBOARD DO TÉCNICO
  // ======================================================
  //
  // Responsável por:
  //
  // - Buscar técnico logado
  // - Buscar empresa do técnico
  // - Buscar OS do técnico
  // - Calcular estatísticas
  //
  // ======================================================

  Future<Map<String, dynamic>> carregarDashboardTecnico() async {
  try {
    // ======================================================
    // USUÁRIO LOGADO
    // ======================================================

    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    // ======================================================
    // TÉCNICO
    // ======================================================

    final tecnico = await _supabase
        .from('tecnicos')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (tecnico == null) {
      throw Exception('Técnico não encontrado');
    }

    // ======================================================
    // EMPRESA
    // ======================================================

    String empresaNome = 'Empresa';

    final empresaId = tecnico['empresa_id'];

    if (empresaId != null) {
      final empresa = await _supabase
          .from('empresas')
          .select('nome')
          .eq('id', empresaId)
          .maybeSingle();

      if (empresa != null) {
        empresaNome = empresa['nome'] ?? 'Empresa';
      }
    }

    // ======================================================
    // ORDENS DE SERVIÇO
    // ======================================================

    final ordens = await _supabase
        .from('ordens_servico')
        .select()
        .eq('tecnico_id', tecnico['id']);

    // ======================================================
    // CONTADORES
    // ======================================================

    int concluidos = 0;
    int pendentes = 0;
    int aguardandoPeca = 0;
    int ausentes = 0;

    for (final os in ordens) {
      final status = (os['status'] ?? '')
          .toString()
          .trim()
          .toLowerCase();
          

      switch (status) {
        case 'concluido':
        case 'concluida':
          concluidos++;
          break;

        case 'pendente':
          pendentes++;
          break;

        case 'aguardando_peca':
          aguardandoPeca++;
          break;

        case 'cliente ausente':
          ausentes++;
          break;
      }
    }

    // ======================================================
    // TOTAL REAL
    // ======================================================

    final totalOS =
        concluidos +
        pendentes +
        aguardandoPeca +
        ausentes;

    // ======================================================
    // RETORNO
    // ======================================================

    return {
      'empresa': empresaNome,
      'nomeTecnico': tecnico['nome'] ?? 'Técnico',

      'concluidos': concluidos,
      'pendentes': pendentes,
      'aguardandoPeca': aguardandoPeca,
      'ausentes': ausentes,

      'totalMes': totalOS,
    };
  } catch (e) {
    return {
      'empresa': 'Empresa',
      'nomeTecnico': 'Técnico',

      'concluidos': 0,
      'pendentes': 0,
      'aguardandoPeca': 0,
      'ausentes': 0,

      'totalMes': 0,
    };
  }
}

  // ======================================================
  // LISTAR TÉCNICOS
  // ======================================================

  Future<List<Map<String, dynamic>>> listarTecnicos() async {
    try {
      final response = await _supabase
          .from('tecnicos')
          .select()
          .order('nome', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  // ======================================================
  // BUSCAR TÉCNICO POR ID
  // ======================================================

  Future<Map<String, dynamic>?> buscarTecnicoPorId(String id) async {
    try {
      final response = await _supabase
          .from('tecnicos')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return Map<String, dynamic>.from(response);
    } catch (e) {
      return null;
    }
  }

  // ======================================================
  // CRIAR TÉCNICO
  // ======================================================

  Future<bool> criarTecnico(Map<String, dynamic> dados) async {
    try {
      await _supabase.from('tecnicos').insert(dados);

      return true;
    } catch (e) {
      return false;
    }
  }

  // ======================================================
  // ATUALIZAR TÉCNICO
  // ======================================================

  Future<bool> atualizarTecnico(String id, Map<String, dynamic> dados) async {
    try {
      await _supabase.from('tecnicos').update(dados).eq('id', id);

      return true;
    } catch (e) {
      return false;
    }
  }

  // ======================================================
  // DELETAR TÉCNICO
  // ======================================================

  Future<bool> deletarTecnico(String id) async {
    try {
      await _supabase.from('tecnicos').delete().eq('id', id);

      return true;
    } catch (e) {
      return false;
    }
  }

  // ======================================================
  // BUSCAR TÉCNICO LOGADO
  // ======================================================

  Future<Map<String, dynamic>?> buscarTecnicoLogado() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        return null;
      }

      final tecnico = await _supabase
          .from('tecnicos')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (tecnico == null) {
        return null;
      }

      return Map<String, dynamic>.from(tecnico);
    } catch (e) {
      return null;
    }
  }

  // ======================================================
  // BUSCAR OS DO TÉCNICO
  // ======================================================

  Future<List<Map<String, dynamic>>> buscarOSDoTecnico({
    required String tecnicoId,
    required DateTime data,
  }) async {
    try {
      // ==================================================
      // BUSCA TODAS AS OS DO TÉCNICO
      // ==================================================

      final response = await _supabase
          .from('ordens_servico')
          .select()
          .eq('tecnico_id', tecnicoId)
          .order('janela_inicio_agendada', ascending: true);

      // ==================================================
      // FILTRO MANUAL DA DATA
      // ==================================================

      final listaFiltrada = response.where((os) {
        final dataOsString = os['janela_inicio_agendada'];

        if (dataOsString == null) {
          return false;
        }

        final dataOs = DateTime.parse(dataOsString);

        return dataOs.year == data.year &&
            dataOs.month == data.month &&
            dataOs.day == data.day;
      }).toList();

      return List<Map<String, dynamic>>.from(listaFiltrada);
    } catch (e) {
      return [];
    }
  }
}
