import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../dominio/modelos/cliente_ausente_model.dart';

class ClienteAusenteRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =====================================================
  // SALVAR REGISTRO
  // =====================================================

  Future<void> salvar(ClienteAusenteModel model) async {
    await _supabase.from('cliente_ausente').insert(model.toMap());
  }

  // =====================================================
  // UPLOAD FOTO RESIDÊNCIA
  // =====================================================

  Future<String> uploadFotoResidencia({
    required String ordemServicoId,
    required XFile foto,
  }) async {
    final bytes = await foto.readAsBytes();

    final nomeArquivo =
        'OS_$ordemServicoId/'
        'foto_${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      await _supabase.storage
          .from('cliente-ausente')
          .uploadBinary(
            nomeArquivo,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );
    } catch (e) {
      print('ERRO STORAGE => $e');
      rethrow;
    }

    return _supabase.storage.from('cliente-ausente').getPublicUrl(nomeArquivo);
  }

  // =====================================================
  // ATUALIZAR STATUS DA OS
  // =====================================================

  Future<void> atualizarStatusOS({required String ordemServicoId}) async {
    await _supabase
        .from('ordens_servico')
        .update({'status': 'CLIENTE AUSENTE'})
        .eq('id', ordemServicoId);
  }

  // =====================================================
  // REGISTRAR HISTÓRICO
  // =====================================================

  Future<void> registrarHistorico({
    required String ordemServicoId,
    required String descricao,
  }) async {
    await _supabase.from('historico_os').insert({
      'ordem_servico_id': ordemServicoId,
      'descricao': descricao,
      'criado_em': DateTime.now().toIso8601String(),
    });
  }

  // =====================================================
  // BUSCAR EMPRESA
  // =====================================================

  Future<Map<String, dynamic>> buscarEmpresa(String empresaId) async {
    return await _supabase
        .from('empresas')
        .select('nome, logo_url')
        .eq('id', empresaId)
        .single();
  }

  // =====================================================
  // BUSCAR EMPRESA DA OS
  // =====================================================

  Future<Map<String, dynamic>> buscarEmpresaDaOS(String ordemServicoId) async {
    final os = await _supabase
        .from('ordens_servico')
        .select('empresa_id')
        .eq('id', ordemServicoId)
        .single();

    final empresaId = os['empresa_id'];

    if (empresaId == null) {
      throw Exception('OS sem empresa vinculada.');
    }

    return await buscarEmpresa(empresaId.toString());
  }

  // =====================================================
  // REGISTRAR CLIENTE AUSENTE COMPLETO
  // =====================================================

  Future<void> registrarClienteAusente({
    required ClienteAusenteModel model,
    required String ordemServicoId,
  }) async {
    await salvar(model);

    await atualizarStatusOS(ordemServicoId: ordemServicoId);

    await registrarHistorico(
      ordemServicoId: ordemServicoId,
      descricao: 'Cliente ausente registrado pelo técnico.',
    );
  }
}
