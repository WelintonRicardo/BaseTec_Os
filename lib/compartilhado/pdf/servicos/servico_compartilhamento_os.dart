import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../dados/repositorios/pdf_os_repository.dart';
import '../gerador_pdf_os.dart';

class ServicoCompartilhamentoOS {
  final SupabaseClient _supabase = Supabase.instance.client;

  final PdfOsRepository _osRepository = PdfOsRepository();

  // =====================================================
  // OBTER OU CRIAR LINK DO PDF
  // =====================================================

  Future<String> obterOuCriarLink(int osId) async {
    try {
      // =================================================
      // 1 - BUSCAR EXECUÇÃO DA OS
      // =================================================

      final execucao = await _supabase
          .from('execucoes_os')
          .select('id,pdf_link,status_execucao,criado_em')
          .eq('ordem_servico_id', osId)
          .order('criado_em', ascending: false)
          .limit(1)
          .maybeSingle();

      if (execucao == null) {
        throw Exception('Nenhuma execução encontrada para esta OS');
      }

      // =================================================
      // 2 - SE JÁ EXISTE PDF RETORNA
      // =================================================

      final pdfExistente = execucao['pdf_link'];

      if (pdfExistente != null && pdfExistente.toString().isNotEmpty) {
        return pdfExistente;
      }

      // =================================================
      // 3 - BUSCAR OS COMPLETA
      // =================================================

      final os = await _osRepository.buscarOsPorId(osId);

      if (os == null) {
        throw Exception('OS não encontrada');
      }

      // =================================================
      // 4 - PEGAR TÉCNICO DO RELACIONAMENTO
      // =================================================

      Map<String, dynamic>? tecnico;

      final execucoes = os['execucoes_os'];

      if (execucoes is List && execucoes.isNotEmpty) {
        Map<String, dynamic>? execucaoSelecionada;

        // Prioriza execução finalizada
        for (final execucao in execucoes) {
          if (execucao['status_execucao'] == 'finalizado') {
            execucaoSelecionada = Map<String, dynamic>.from(execucao);
            break;
          }
        }

        // Caso não encontre finalizada, pega a primeira
        execucaoSelecionada ??= Map<String, dynamic>.from(execucoes.first);

        if (execucaoSelecionada['tecnico'] != null) {
          tecnico = Map<String, dynamic>.from(execucaoSelecionada['tecnico']);
        }
      }

      if (tecnico == null) {
        throw Exception('Dados do técnico não encontrados');
      }

      // =================================================
      // 5 - GERAR PDF EM MEMÓRIA
      // =================================================

      final Uint8List pdfBytes = await GeradorPdfOs.gerar(
        os: os,
        tecnico: tecnico,
      );

      // =================================================
      // 6 - NOME DO ARQUIVO
      // =================================================

      final nomeArquivo = 'OS_$osId.pdf';

      final caminho = 'compartilhamentos/$nomeArquivo';

      // =================================================
      // 7 - UPLOAD STORAGE
      // =================================================

      await _supabase.storage
          .from('os_pdfs')
          .uploadBinary(
            caminho,
            pdfBytes,
            fileOptions: const FileOptions(
              contentType: 'application/pdf',
              upsert: true,
            ),
          );
          

      // =================================================
      // 8 - GERAR URL PUBLICA
      // =================================================

      final url = _supabase.storage.from('os_pdfs').getPublicUrl(caminho);

      // =================================================
      // 9 - SALVAR LINK NA EXECUÇÃO
      // =================================================

      await _supabase
          .from('execucoes_os')
          .update({'pdf_link': url})
          .eq('id', execucao['id']);

      return url;
    } catch (e, stack) {
      print('ERRO COMPARTILHAR PDF');

      print(e);

      print(stack);

      throw Exception('Erro ao gerar compartilhamento da OS');
    }
  }
}
