import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../compartilhado/regras/regras_os.dart';
import '../../../../compartilhado/tema_cores.dart';

import '../../../execucao_os/apresentacao/telas/tela_execucao_os.dart';
import '../../../execucao_os/dados/repositorios/execucao_os_repository.dart';

class TecnicoOSDetalhes extends StatelessWidget {
  final Map<String, dynamic> os;

  const TecnicoOSDetalhes({
    super.key,
    required this.os,
  });

  // =====================================================
  // ABRIR MAPA
  // =====================================================

  Future<void> _abrirMapa(String endereco) async {
    final urlMaps = Uri.encodeFull(
      "https://www.google.com/maps/search/?api=1&query=$endereco",
    );

    final urlWaze = Uri.encodeFull(
      "https://waze.com/ul?q=$endereco",
    );

    if (await canLaunchUrl(Uri.parse(urlWaze))) {
      await launchUrl(
        Uri.parse(urlWaze),
        mode: LaunchMode.externalApplication,
      );
    } else {
      await launchUrl(
        Uri.parse(urlMaps),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // =====================================================
  // LIGAÇÃO
  // =====================================================

  Future<void> _ligarCliente(
    String telefone,
  ) async {
    final url = Uri.parse(
      "tel:$telefone",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // =====================================================
  // WHATSAPP
  // =====================================================

  Future<void> _abrirWhatsApp(
    String telefone,
  ) async {
    final url = Uri.parse(
      "https://wa.me/$telefone",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // =====================================================
  // FORMATAR HORÁRIO
  // =====================================================

  String _formatarHorario(dynamic data) {
    if (data == null) {
      return '--:--';
    }

    try {
      final dt = DateTime.parse(
        data.toString(),
      );

      final hora =
          dt.hour.toString().padLeft(2, '0');

      final minuto =
          dt.minute.toString().padLeft(2, '0');

      return '$hora:$minuto';
    } catch (e) {
      return '--:--';
    }
  }

  @override
  Widget build(BuildContext context) {

    // =====================================================
    // DADOS DA OS
    // =====================================================

    final segurado =
        os['nome_segurado'] ??
        os['cliente'] ??
        'Não informado';

    final seguradora =
        os['seguradora'] ??
        'Não informado';

    final tipoServico =
        os['tipo_servico'] ??
        'Não informado';

    final status =
        os['status']
            ?.toString() ??
        'PENDENTE';

    final telefone =
        os['telefone'] ?? '';

    final cidade =
        os['cidade'] ??
        'Não informado';

    final cep =
        os['cep'] ??
        'Não informado';

    final rua =
        os['rua'] ??
        'Não informado';

    final numero =
        os['numero'] ??
        'S/N';

    final complemento =
        os['complemento'] ?? '';

    final descricao =
        os['descricao_servico'] ??
        os['descricao'] ??
        'Sem descrição';

    final horario =
        "${_formatarHorario(os['janela_inicio_agendada'])}"
        " - "
        "${_formatarHorario(os['janela_fim_agendada'])}";

    final enderecoCompleto =
        "$rua, $numero, $cidade";

    // =====================================================
    // REGRAS
    // =====================================================

    final podeIniciar =
        RegrasOS.podeIniciarExecucao(
      status,
    );

    final isFinalizada =
        RegrasOS.isStatusFinal(
      status,
    );

    return Scaffold(
      backgroundColor:
          AppCores.fundoEscuro,

      // ===================================================
      // APP BAR
      // ===================================================

      appBar: AppBar(
        backgroundColor:
            AppCores.cardEscuro,

        title: Text(
          "OS ${os['numero_os'] ?? ''}",

          style: const TextStyle(
            color:
                AppCores.textoBranco,
          ),
        ),
      ),

      // ===================================================
      // BODY
      // ===================================================

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // =================================================
            // CARD PRINCIPAL
            // =================================================

            Card(
              color: isFinalizada
                  ? Colors.white10
                  : AppCores.cardEscuro,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),

              child: Padding(
                padding:
                    const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    Text(
                      "Cliente: $segurado",

                      style: const TextStyle(
                        color:
                            AppCores
                                .textoBranco,

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      "Seguradora: $seguradora",

                      style: const TextStyle(
                        color:
                            AppCores
                                .textoBranco,
                      ),
                    ),

                    Text(
                      "Tipo Serviço: $tipoServico",

                      style: const TextStyle(
                        color:
                            AppCores
                                .textoBranco,
                      ),
                    ),

                    Text(
                      "Status: $status",

                      style: TextStyle(
                        color: isFinalizada
                            ? Colors.white54
                            : AppCores
                                .textoBranco,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    Text(
                      "Horário: $horario",

                      style: const TextStyle(
                        color:
                            AppCores
                                .textoBranco,
                      ),
                    ),

                    const Divider(
                      color:
                          AppCores
                              .bordaEscura,
                      height: 24,
                    ),

                    Text(
                      "Cidade: $cidade",

                      style: const TextStyle(
                        color:
                            AppCores
                                .textoBranco,
                      ),
                    ),

                    Text(
                      "CEP: $cep",

                      style: const TextStyle(
                        color:
                            AppCores
                                .textoBranco,
                      ),
                    ),

                    Text(
                      "Rua: $rua",

                      style: const TextStyle(
                        color:
                            AppCores
                                .textoBranco,
                      ),
                    ),

                    Text(
                      "Número: $numero",

                      style: const TextStyle(
                        color:
                            AppCores
                                .textoBranco,
                      ),
                    ),

                    if (complemento
                        .toString()
                        .isNotEmpty)

                      Text(
                        "Complemento: $complemento",

                        style: const TextStyle(
                          color:
                              AppCores
                                  .textoBranco,
                        ),
                      ),

                    const Divider(
                      color:
                          AppCores
                              .bordaEscura,
                      height: 24,
                    ),

                    const Text(
                      "Descrição:",

                      style: TextStyle(
                        color:
                            AppCores
                                .primaria,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      descricao,

                      style: const TextStyle(
                        color:
                            AppCores
                                .textoBranco,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // =================================================
            // MAPA
            // =================================================

            ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppCores.primaria,

                minimumSize:
                    const Size(
                  double.infinity,
                  48,
                ),
              ),

              onPressed: () =>
                  _abrirMapa(
                enderecoCompleto,
              ),

              icon: const Icon(
                Icons.map,
                color:
                    AppCores.textoBranco,
              ),

              label: const Text(
                "Leve-me ao cliente",

                style: TextStyle(
                  color:
                      AppCores.textoBranco,
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            // =================================================
            // CONTATOS
            // =================================================

            Row(
              children: [

                Expanded(
                  child:
                      ElevatedButton.icon(
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          AppCores
                              .emAndamento,
                    ),

                    onPressed: () =>
                        _ligarCliente(
                      telefone,
                    ),

                    icon: const Icon(
                      Icons.phone,
                      color:
                          AppCores
                              .textoBranco,
                    ),

                    label: const Text(
                      "Ligar",

                      style: TextStyle(
                        color:
                            AppCores
                                .textoBranco,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child:
                      ElevatedButton.icon(
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          AppCores
                              .concluido,
                    ),

                    onPressed: () =>
                        _abrirWhatsApp(
                      telefone,
                    ),

                    icon: const Icon(
                      Icons.chat,
                      color:
                          AppCores
                              .textoBranco,
                    ),

                    label: const Text(
                      "WhatsApp",

                      style: TextStyle(
                        color:
                            AppCores
                                .textoBranco,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // =================================================
            // CLIENTE AUSENTE
            // =================================================

            ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppCores.ausente,

                minimumSize:
                    const Size(
                  double.infinity,
                  48,
                ),
              ),

              onPressed: () {

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Gerar relatório de cliente ausente...",
                    ),
                  ),
                );
              },

              icon: const Icon(
                Icons.person_off,
                color:
                    AppCores.textoBranco,
              ),

              label: const Text(
                "Cliente Ausente",

                style: TextStyle(
                  color:
                      AppCores.textoBranco,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // =================================================
            // INICIAR EXECUÇÃO
            // =================================================

            ElevatedButton.icon(

              style:
                  ElevatedButton.styleFrom(

                backgroundColor:
                    podeIniciar
                        ? AppCores.primaria
                        : Colors.grey.shade700,

                minimumSize:
                    const Size(
                  double.infinity,
                  48,
                ),
              ),

              onPressed:
                  podeIniciar
                      ? () async {

                          final confirmar =
                              await showDialog<bool>(

                            context: context,

                            builder:
                                (context) {

                              return AlertDialog(

                                title:
                                    const Text(
                                  'Iniciar Execução',
                                ),

                                content:
                                    const Text(
                                  'Deseja iniciar a execução desta OS agora?',
                                ),

                                actions: [

                                  TextButton(

                                    onPressed:
                                        () {

                                      Navigator.pop(
                                        context,
                                        false,
                                      );
                                    },

                                    child:
                                        const Text(
                                      'Cancelar',
                                    ),
                                  ),

                                  ElevatedButton(

                                    onPressed:
                                        () {

                                      Navigator.pop(
                                        context,
                                        true,
                                      );
                                    },

                                    child:
                                        const Text(
                                      'Iniciar',
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmar != true) {
                            return;
                          }

                          try {

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(

                              const SnackBar(
                                content: Text(
                                  'Iniciando execução...',
                                ),
                              ),
                            );

                            // =================================
                            // USER LOGADO
                            // =================================

                            final authUserId =
                                Supabase
                                    .instance
                                    .client
                                    .auth
                                    .currentUser!
                                    .id;

                            // =================================
                            // ID OS
                            // =================================

                            final ordemServicoId =
                                os['id'];

                            // =================================
                            // BUSCAR TÉCNICO
                            // =================================

                            final tecnico =
                                await Supabase
                                    .instance
                                    .client
                                    .from(
                                      'tecnicos',
                                    )
                                    .select(
                                      'id',
                                    )
                                    .eq(
                                      'user_id',
                                      authUserId,
                                    )
                                    .single();

                            final tecnicoId =
                                tecnico['id'];

                            print(
                              'AUTH USER -> $authUserId',
                            );

                            print(
                              'TECNICO ID -> $tecnicoId',
                            );

                            // =================================
                            // REPOSITORY
                            // =================================

                            final repository =
                                ExecucaoOSRepository();

                            // =================================
                            // INICIAR EXECUÇÃO
                            // =================================

                            final execucaoId =
                                await repository
                                    .iniciarExecucao(

                              ordemServicoId:
                                  ordemServicoId,

                              tecnicoId:
                                  tecnicoId,
                            );

                            if (execucaoId ==
                                null) {

                              throw Exception(
                                'Erro ao criar execução',
                              );
                            }

                            if (!context.mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(

                              const SnackBar(
                                content: Text(
                                  'Execução iniciada com sucesso!',
                                ),
                              ),
                            );

                            // =================================
                            // ABRIR TELA
                            // =================================

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    TelaExecucaoOS(

                                  ordemServico: os,

                                  execucaoId:
                                      execucaoId,
                                ),
                              ),
                            );

                          } catch (e) {

                            print(
                              'ERRO INICIAR EXECUÇÃO: $e',
                            );

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(

                              SnackBar(
                                content: Text(
                                  'Erro ao iniciar execução: $e',
                                ),
                              ),
                            );
                          }
                        }
                      : null,

              icon: Icon(

                podeIniciar
                    ? Icons.play_arrow
                    : Icons.lock,

                color:
                    AppCores.textoBranco,
              ),

              label: Text(

                podeIniciar
                    ? 'Iniciar Execução do Serviço'
                    : 'OS Finalizada',

                style: const TextStyle(
                  color:
                      AppCores.textoBranco,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}