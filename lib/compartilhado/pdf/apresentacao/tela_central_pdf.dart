import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tema_cores.dart';

import '../controle/pdf_central_controller.dart';

import 'widgets/pdf_section_title.dart';
import 'widgets/pdf_template_selector.dart';
import 'widgets/pdf_color_selector.dart';
import 'widgets/pdf_preview_card.dart';
import 'widgets/pdf_action_buttons.dart';

import '../../../compartilhado/pdf/gerador_pdf_os.dart';
import '../../../compartilhado/pdf/servicos/pdf_preview_service.dart';

import '../dados/repositorios/pdf_os_repository.dart';
import '../dados/repositorios/pdf_tecnico_repository.dart';

class TelaCentralPdf extends StatelessWidget {
  const TelaCentralPdf({super.key});

  @override
  Widget build(BuildContext context) {
    print('TELA CENTRAL PDF INICIADA');

    return ChangeNotifierProvider(
      create: (_) {
        print('CRIANDO PDF CENTRAL CONTROLLER');

        return PdfCentralController()..inicializar();
      },

      child: const _TelaCentralPdfBody(),
    );
  }
}

class _TelaCentralPdfBody extends StatelessWidget {
  const _TelaCentralPdfBody();

  @override
  Widget build(BuildContext context) {
    print('BUILD TELA CENTRAL PDF');

    final controller = context.watch<PdfCentralController>();

    print('LOGO URL ATUAL => ${controller.logoUrl}');

    final PdfOsRepository osRepository = PdfOsRepository();

    final PdfTecnicoRepository tecnicoRepository = PdfTecnicoRepository();

    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      // ===================================================
      // APP BAR
      // ===================================================
      appBar: AppBar(
        backgroundColor: AppCores.cardEscuro,

        elevation: 0,

        title: const Text(
          'Central PDF',

          style: TextStyle(color: AppCores.textoBranco),
        ),
      ),

      // ===================================================
      // BODY
      // ===================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =====================================
            // HEADER
            // =====================================
            const PdfSectionTitle(text: 'Personalização PDF'),

            const SizedBox(height: 8),

            const Text(
              'Configure aparência, cores, templates e identidade visual do relatório.',

              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 30),

            // =====================================
            // TEMPLATE
            // =====================================
            const PdfSectionTitle(text: 'Template'),

            const SizedBox(height: 14),

            PdfTemplateSelector(
              template: controller.template,

              corPrimaria: controller.corPrimaria,

              onChanged: controller.alterarTemplate,
            ),

            const SizedBox(height: 30),

            // =====================================
            // CORES
            // =====================================
            const PdfSectionTitle(text: 'Cores do PDF'),

            const SizedBox(height: 14),

            PdfColorSelector(
              corPrimaria: controller.corPrimaria,

              corSecundaria: controller.corSecundaria,

              onPrimaryTap: controller.trocarCorPrimaria,

              onSecondaryTap: controller.trocarCorSecundaria,
            ),

            const SizedBox(height: 30),

            // =====================================
            // LOGO
            // =====================================
            const PdfSectionTitle(text: 'Logo da Empresa'),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: AppCores.cardEscuro,

                borderRadius: BorderRadius.circular(18),

                border: Border.all(color: AppCores.bordaEscura),
              ),

              child: Column(
                children: [
                  // =========================================
                  // PREVIEW LOGO
                  // =========================================
                  if (controller.logoUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),

                      child: Image.network(
                        controller.logoUrl!,

                        height: 110,

                        fit: BoxFit.contain,

                        errorBuilder: (context, error, stackTrace) {
                          print('ERRO IMAGE NETWORK => $error');

                          return const Icon(
                            Icons.broken_image,

                            color: Colors.red,

                            size: 60,
                          );
                        },
                      ),
                    )
                  else
                    const Icon(
                      Icons.image_rounded,

                      color: Colors.white54,

                      size: 60,
                    ),

                  const SizedBox(height: 16),

                  const Text(
                    'Logo da empresa',

                    style: TextStyle(color: AppCores.textoBranco),
                  ),

                  const SizedBox(height: 18),

                  // =====================================
                  // BOTÃO UPLOAD
                  // =====================================
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.corPrimaria,
                    ),

                    onPressed: () async {
                      print('====================================');

                      print('BOTAO ENVIAR LOGO CLICADO');

                      print('CHAMANDO controller.selecionarLogo()');

                      try {
                        await controller.selecionarLogo();

                        print('FINALIZOU selecionarLogo()');

                        print('LOGO URL => ${controller.logoUrl}');

                        if (!context.mounted) {
                          print('CONTEXT NÃO MONTADO');

                          return;
                        }

                        if (controller.logoUrl != null) {
                          print('UPLOAD SUCESSO');

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logo atualizada com sucesso!'),
                            ),
                          );
                        } else {
                          print('UPLOAD FALHOU - URL NULA');

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro ao enviar logo.'),
                            ),
                          );
                        }
                      } catch (e, stack) {
                        print('ERRO BOTAO UPLOAD => $e');

                        print('STACK => $stack');

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
                      }

                      print('====================================');
                    },

                    icon: const Icon(Icons.upload_rounded),

                    label: const Text('Enviar Logo'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =====================================
            // PREVIEW
            // =====================================
            const PdfSectionTitle(text: 'Preview'),

            const SizedBox(height: 14),

            PdfPreviewCard(
              template: controller.template,

              corPrimaria: controller.corPrimaria,

              corSecundaria: controller.corSecundaria,
            ),

            const SizedBox(height: 30),

            // =====================================
            // AÇÕES
            // =====================================
            PdfActionButtons(
              corPrimaria: controller.corPrimaria,

              corSecundaria: controller.corSecundaria,

              salvando: controller.salvando,

              // ===================================
              // VISUALIZAR PDF REAL
              // ===================================
              onVisualizar: () async {
                print('BOTAO VISUALIZAR PDF');

                try {
                  final os = await osRepository.buscarPrimeiraOs();

                  print('OS => $os');

                  if (os == null) {
                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nenhuma OS encontrada.')),
                    );

                    return;
                  }

                  final tecnico = await tecnicoRepository.buscarTecnico();

                  print('TECNICO => $tecnico');

                  if (tecnico == null) {
                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nenhum técnico encontrado.'),
                      ),
                    );

                    return;
                  }

                  final pdfBytes = await GeradorPdfOs.gerar(
                    os: os,
                    tecnico: tecnico,
                  );

                  print('PDF GERADO');

                  await PdfPreviewService.preview(pdfBytes);

                  print('PDF PREVIEW OK');
                } catch (e, stack) {
                  print('ERRO PREVIEW PDF => $e');

                  print('STACK => $stack');

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao gerar PDF: $e')),
                  );
                }
              },

              // ===================================
              // DOWNLOAD
              // ===================================
              onBaixar: () {
                print('BOTAO DOWNLOAD');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Download PDF em desenvolvimento'),
                  ),
                );
              },

              // ===================================
              // COMPARTILHAR
              // ===================================
              onCompartilhar: () {
                print('BOTAO COMPARTILHAR');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Compartilhamento em desenvolvimento'),
                  ),
                );
              },

              // ===================================
              // SALVAR CONFIG
              // ===================================
              onSalvar: () async {
                print('BOTAO SALVAR CONFIG');

                await controller.salvarConfiguracoes();

                print('CONFIG SALVA');

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configurações salvas!')),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
