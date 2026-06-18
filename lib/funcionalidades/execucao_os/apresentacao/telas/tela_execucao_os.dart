import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../compartilhado/tema_cores.dart';

import '../../controle/services/execucao_os_service.dart';

import '../widgets/card_assinaturas.dart';
import '../widgets/card_defeito.dart';
import '../widgets/card_fotos.dart';
import '../widgets/card_observacao_final.dart';
import '../widgets/card_solicitacao.dart';
import '../widgets/card_solucao.dart';
import '../widgets/card_status.dart';

class TelaExecucaoOS extends StatefulWidget {
  final Map<String, dynamic> ordemServico;
  final String execucaoId;

  const TelaExecucaoOS({
    super.key,
    required this.ordemServico,
    required this.execucaoId,
  });

  @override
  State<TelaExecucaoOS> createState() => _TelaExecucaoOSState();
}

class _TelaExecucaoOSState extends State<TelaExecucaoOS> {
  final execucaoService = ExecucaoOSService();
  final picker = ImagePicker();

  Timer? timer;
  int segundos = 0;
  bool carregando = false;

  final solicitacaoController = TextEditingController();
  final defeitoController = TextEditingController();
  final solucaoController = TextEditingController();
  final observacaoFinalController = TextEditingController();

  bool reparoEfetuado = false;
  String statusFinal = 'concluido';

  File? fotoInicio;
  File? fotoFim;

  // URLs usadas principalmente no Web
String? fotoInicioUrl;
String? fotoFimUrl;

  final assinaturaClienteController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.white,
  );

  final assinaturaTecnicoController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.white,
  );

  final supabase = Supabase.instance.client;

  // =========================================================
  // CHECKLIST
  // =========================================================
  List<Map<String, dynamic>> checklistItens = [
    {'titulo': 'Reparo executado', 'checked': false},
    {'titulo': 'Segurado acompanhou serviços', 'checked': false},
    {
      'titulo':
          'Todas as informações foram passadas ao segurado e ele está de acordo',
      'checked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    iniciarTimer();
  }

  void iniciarTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        segundos++;
      });
    });
  }

  // =========================================================
  // FOTO
  // =========================================================
  Future<void> capturarFotoInicio() async {
  try {
    final imagem = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (imagem == null) return;

    if (kIsWeb) {
      final bytes = await imagem.readAsBytes();

      await salvarFotoWeb(
        bytes: bytes,
        coluna: 'foto_inicio',
        tipo: 'inicio',
      );
    } else {
      final arquivo = File(imagem.path);

      setState(() {
        fotoInicio = arquivo;
      });

      await salvarFotoMobile(
        arquivo: arquivo,
        coluna: 'foto_inicio',
        tipo: 'inicio',
      );
    }
  } catch (e) {
    mostrarErro(
      'Erro ao capturar foto inicial: $e',
    );
  }
}

  Future<void> capturarFotoFim() async {
  try {
    final imagem = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (imagem == null) return;

    if (kIsWeb) {
      final bytes = await imagem.readAsBytes();

      await salvarFotoWeb(
        bytes: bytes,
        coluna: 'foto_fim',
        tipo: 'fim',
      );
    } else {
      final arquivo = File(imagem.path);

      setState(() {
        fotoFim = arquivo;
      });

      await salvarFotoMobile(
        arquivo: arquivo,
        coluna: 'foto_fim',
        tipo: 'fim',
      );
    }
  } catch (e) {
    mostrarErro(
      'Erro ao capturar foto final: $e',
    );
  }
}

  Future<void> salvarFoto({
    required File arquivo,
    required String coluna,
    required String tipo,
  }) async {
    try {
      print('================================');
      print('SALVANDO FOTO');
      print('TIPO: $tipo');
      print('EXECUCAO: ${widget.execucaoId}');
      print('================================');

      final path =
          'execucoes/${widget.execucaoId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage
          .from('execucoes-os')
          .upload(path, arquivo, fileOptions: const FileOptions(upsert: true));

      final url = supabase.storage.from('execucoes-os').getPublicUrl(path);

      print('URL GERADA');
      print(url);

      final retorno = await supabase
          .from('execucoes_os')
          .update({coluna: url})
          .eq('id', widget.execucaoId)
          .select();

      print('UPDATE EXECUTADO');
      print(retorno);

      final verificacao = await supabase
          .from('execucoes_os')
          .select('foto_inicio,foto_fim')
          .eq('id', widget.execucaoId)
          .single();

      print('VERIFICACAO');
      print(verificacao);

      print('================================');
    } catch (e) {
      print('ERRO AO SALVAR FOTO');
      print(e);

      rethrow;
    }
  }
Future<void> salvarFotoMobile({
  required File arquivo,
  required String coluna,
  required String tipo,
}) async {
  try {
    print('================================');
    print('UPLOAD MOBILE');
    print('TIPO: $tipo');
    print('================================');

    final path =
        'execucoes/${widget.execucaoId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('execucoes-os')
        .upload(
          path,
          arquivo,
          fileOptions: const FileOptions(
            upsert: true,
          ),
        );

    final url = supabase.storage
        .from('execucoes-os')
        .getPublicUrl(path);

    await supabase
        .from('execucoes_os')
        .update({
          coluna: url,
        })
        .eq(
          'id',
          widget.execucaoId,
        );

    print('FOTO SALVA MOBILE');
    print(url);
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<void> salvarFotoWeb({
  required Uint8List bytes,
  required String coluna,
  required String tipo,
}) async {
  try {
    final path =
        'execucoes/${widget.execucaoId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('execucoes-os')
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
          ),
        );

    final url = supabase.storage
        .from('execucoes-os')
        .getPublicUrl(path);

    setState(() {
      if (tipo == 'inicio') {
        fotoInicioUrl = url;
      } else {
        fotoFimUrl = url;
      }
    });

    await supabase
        .from('execucoes_os')
        .update({
          coluna: url,
        })
        .eq(
          'id',
          widget.execucaoId,
        );

    print('FOTO SALVA WEB');
    print(url);
  } catch (e) {
    print(e);
    rethrow;
  }
}
  // =========================================================
  // ASSINATURA
  // =========================================================
  Future<void> salvarAssinatura({
    required SignatureController controller,
    required String nome,
    required String coluna,
  }) async {
    try {
      final bytes = await controller.toPngBytes();
      if (bytes == null || bytes.isEmpty) {
        throw Exception('Assinatura vazia');
      }
      final path = 'assinaturas/${widget.execucaoId}_$nome.png';
      await supabase.storage
          .from('execucoes-os')
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );
      final url = supabase.storage.from('execucoes-os').getPublicUrl(path);
      await supabase
          .from('execucoes_os')
          .update({coluna: url})
          .eq('id', widget.execucaoId)
          .select();
    } catch (e) {
      rethrow;
    }
  }

  // =========================================================
  // SALVAR EXECUÇÃO
  // =========================================================
  Future<void> salvarExecucao() async {
    await execucaoService.salvarExecucaoCompleta(
      execucaoId: widget.execucaoId,
      solicitacao: solicitacaoController.text.trim(),
      defeito: defeitoController.text.trim(),
      solucao: solucaoController.text.trim(),
      observacaoFinal: observacaoFinalController.text.trim(),
      statusFinal: statusFinal,
      reparoEfetuado: reparoEfetuado,
      checklist: checklistItens, // <-- envia checklist
    );
  }

  // =========================================================
  // FINALIZAR
  // =========================================================
  Future<void> finalizarExecucao() async {
    try {
      if (carregando) return;
      setState(() {
        carregando = true;
      });
      await salvarExecucao();
      await salvarAssinatura(
        controller: assinaturaClienteController,
        nome: 'cliente',
        coluna: 'assinatura_cliente_url',
      );
      await salvarAssinatura(
        controller: assinaturaTecnicoController,
        nome: 'tecnico',
        coluna: 'assinatura_tecnico_url',
      );
      await execucaoService.finalizarExecucao(
        execucaoId: widget.execucaoId,
        ordemServicoId: widget.ordemServico['id'],
        duracaoSegundos: segundos,
        statusFinal: statusFinal,
      );
      timer?.cancel();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Execução finalizada com sucesso')),
      );
      Navigator.pop(context);
    } catch (e) {
      mostrarErro(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  void mostrarErro(String erro) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
  }

  @override
  void dispose() {
    timer?.cancel();
    solicitacaoController.dispose();
    defeitoController.dispose();
    solucaoController.dispose();
    observacaoFinalController.dispose();
    assinaturaClienteController.dispose();
    assinaturaTecnicoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final os = widget.ordemServico;

    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,
      appBar: AppBar(
        backgroundColor: AppCores.cardEscuro,
        title: Text(
          'Execução OS ${os['numero_os'] ?? ''}',
          style: const TextStyle(color: AppCores.textoBranco),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CardSolicitacao(solicitacaoController: solicitacaoController),
            const SizedBox(height: 20),
            CardDefeito(controller: defeitoController),
            const SizedBox(height: 20),
            CardSolucao(controller: solucaoController),
            const SizedBox(height: 20),
            CardObservacaoFinal(controller: observacaoFinalController),
            const SizedBox(height: 20),
            CardFotos(
  fotoInicio: fotoInicio,
  fotoFim: fotoFim,

  fotoInicioUrl: fotoInicioUrl,
  fotoFimUrl: fotoFimUrl,

  onCapturarFotoInicio: capturarFotoInicio,
  onCapturarFotoFim: capturarFotoFim,
),
            const SizedBox(height: 20),
            CardStatus(
              reparoEfetuado: reparoEfetuado,
              statusFinal: statusFinal,
              onReparoAlterado: (value) {
                setState(() {
                  reparoEfetuado = value;
                });
              },
              onStatusAlterado: (value) {
                setState(() {
                  statusFinal = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // =========================================================
            // CHECKLIST
            // =========================================================
            Card(
              color: AppCores.cardEscuro,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Checklist',
                      style: TextStyle(
                        color: AppCores.textoBranco,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...checklistItens.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return CheckboxListTile(
                        title: Text(
                          item['titulo'],
                          style: const TextStyle(color: AppCores.textoBranco),
                        ),
                        value: item['checked'] ?? false,
                        onChanged: (value) {
                          setState(() {
                            checklistItens[index]['checked'] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            CardAssinaturas(
              assinaturaClienteController: assinaturaClienteController,
              assinaturaTecnicoController: assinaturaTecnicoController,
              onLimparCliente: () {
                assinaturaClienteController.clear();
              },
              onLimparTecnico: () {
                assinaturaTecnicoController.clear();
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppCores.primaria,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: carregando
                  ? null
                  : () async {
                      try {
                        await salvarExecucao();

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Execução salva com sucesso'),
                          ),
                        );
                      } catch (e) {
                        mostrarErro(e.toString());
                      }
                    },
              icon: const Icon(Icons.save, color: AppCores.textoBranco),
              label: const Text(
                'Salvar Progresso',
                style: TextStyle(color: AppCores.textoBranco),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppCores.concluido,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: carregando ? null : finalizarExecucao,
              icon: carregando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle, color: AppCores.textoBranco),
              label: Text(
                carregando ? 'Finalizando...' : 'Finalizar Execução',
                style: const TextStyle(color: AppCores.textoBranco),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
