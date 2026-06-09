import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../compartilhado/tema_cores.dart';

class TecnicoOSDetalhes extends StatelessWidget {
  final Map<String, dynamic> os;

  const TecnicoOSDetalhes({
    super.key,
    required this.os,
  });

  // =========================================================
  // FORMATAR HORÁRIO
  // =========================================================

  String formatarHorario(dynamic data) {
    if (data == null) {
      return '--:--';
    }

    try {
      final dt = DateTime.parse(data.toString());

      final hora =
          dt.hour.toString().padLeft(2, '0');

      final minuto =
          dt.minute.toString().padLeft(2, '0');

      return '$hora:$minuto';
    } catch (e) {
      return '--:--';
    }
  }

  // =========================================================
  // ABRIR MAPA
  // =========================================================

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

  // =========================================================
  // LIGAR CLIENTE
  // =========================================================

  Future<void> _ligarCliente(String telefone) async {
    final url = Uri.parse("tel:$telefone");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // =========================================================
  // WHATSAPP
  // =========================================================

  Future<void> _abrirWhatsApp(String telefone) async {
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

  // =========================================================
  // MINI CAMPO
  // =========================================================

  Widget _miniCampo(
    String titulo,
    String valor,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 120,
        maxWidth: 220,
      ),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            titulo,

            style: const TextStyle(
              color: AppCores.primaria,

              fontWeight: FontWeight.bold,

              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            valor,

            style: const TextStyle(
              color: AppCores.textoBranco,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TAG INFO
  // =========================================================

  Widget _tagInfo(
    IconData icon,
    String texto,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.18),

        borderRadius: BorderRadius.circular(30),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            icon,

            size: 16,

            color: AppCores.primaria,
          ),

          const SizedBox(width: 6),

          Text(
            texto,

            style: const TextStyle(
              color: AppCores.textoBranco,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BOTÃO AÇÃO
  // =========================================================

  Widget _botaoAcao({
    required IconData icon,
    required String titulo,
    required Color cor,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 160,

      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,

          minimumSize: const Size(
            160,
            50,
          ),
        ),

        onPressed: onTap,

        icon: Icon(
          icon,
          color: Colors.white,
        ),

        label: Text(
          titulo,

          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {


    final numeroOS =
        os['numero_os']?.toString() ??
            '---';

    final segurado =
        os['nome_segurado']
                ?.toString() ??
            'Não informado';

    final seguradora =
        os['seguradora']
                ?.toString() ??
            'Não informado';

    final tipoServico =
        os['tipo_servico']
                ?.toString() ??
            'Não informado';

    final status =
        os['status']?.toString() ??
            'Não informado';

    final telefone =
        os['telefone']
                ?.toString() ??
            '';

    final cep =
        os['cep']?.toString() ??
            'Não informado';

    final cidade =
        os['cidade']
                ?.toString() ??
            'Não informado';

    final rua =
        os['rua']?.toString() ??
            'Não informado';

    final numero =
        os['numero']
                ?.toString() ??
            'S/N';

    final complemento =
        os['complemento']
                ?.toString() ??
            '';

    final enderecoCompleto =
        '$rua, $numero - $cidade';

    final descricaoServico =
        os['descricao_servico']
                ?.toString() ??
            'Sem descrição';

    final horarioInicio =
        formatarHorario(
      os['janela_inicio_agendada'],
    );

    final horarioFim =
        formatarHorario(
      os['janela_fim_agendada'],
    );

    return Scaffold(
      backgroundColor:
          AppCores.fundoEscuro,

      appBar: AppBar(
        backgroundColor:
            AppCores.cardEscuro,

        title: Text(
          "OS $numeroOS",

          style: const TextStyle(
            color:
                AppCores.textoBranco,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // =========================================================
            // HEADER
            // =========================================================

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color:
                    AppCores.cardEscuro,

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Row(
                    children: [

                      CircleAvatar(
                        radius: 28,

                        backgroundColor:
                            AppCores
                                .primaria
                                .withOpacity(
                          0.2,
                        ),

                        child: const Icon(
                          Icons
                              .assignment_rounded,

                          color:
                              AppCores
                                  .primaria,

                          size: 28,
                        ),
                      ),

                      const SizedBox(
                          width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              segurado,

                              style:
                                  const TextStyle(
                                color: AppCores
                                    .textoBranco,

                                fontSize: 20,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                                height: 4),

                            Text(
                              "OS: $numeroOS",

                              style:
                                  const TextStyle(
                                color: AppCores
                                    .textoCinza,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 18),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,

                    children: [

                      _tagInfo(
                        Icons.access_time,
                        "$horarioInicio às $horarioFim",
                      ),

                      _tagInfo(
                        Icons.info_outline,
                        status,
                      ),

                      _tagInfo(
                        Icons.shield_outlined,
                        seguradora,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =========================================================
            // ENDEREÇO
            // =========================================================

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color:
                    AppCores.cardEscuro,

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const Row(
                    children: [

                      Icon(
                        Icons.location_on,

                        color:
                            AppCores
                                .primaria,
                      ),

                      SizedBox(width: 8),

                      Text(
                        "Endereço",

                        style: TextStyle(
                          color:
                              AppCores
                                  .primaria,

                          fontWeight:
                              FontWeight
                                  .bold,

                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 16),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,

                    children: [

                      _miniCampo(
                        "Cidade",
                        cidade,
                      ),

                      _miniCampo(
                        "CEP",
                        cep,
                      ),

                      _miniCampo(
                        "Rua",
                        rua,
                      ),

                      _miniCampo(
                        "Número",
                        numero,
                      ),

                      if (complemento
                          .isNotEmpty)

                        _miniCampo(
                          "Complemento",
                          complemento,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =========================================================
            // SERVIÇO
            // =========================================================

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color:
                    AppCores.cardEscuro,

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const Row(
                    children: [

                      Icon(
                        Icons
                            .build_circle_outlined,

                        color:
                            AppCores
                                .primaria,
                      ),

                      SizedBox(width: 8),

                      Text(
                        "Serviço",

                        style: TextStyle(
                          color:
                              AppCores
                                  .primaria,

                          fontWeight:
                              FontWeight
                                  .bold,

                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 16),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,

                    children: [

                      _miniCampo(
                        "Tipo Serviço",
                        tipoServico,
                      ),

                      _miniCampo(
                        "Seguradora",
                        seguradora,
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 18),

                  const Text(
                    "Descrição do Serviço",

                    style: TextStyle(
                      color:
                          AppCores.primaria,

                      fontWeight:
                          FontWeight.bold,

                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  Text(
                    descricaoServico,

                    style: const TextStyle(
                      color: AppCores
                          .textoBranco,

                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // =========================================================
            // AÇÕES
            // =========================================================

            Wrap(
              spacing: 12,
              runSpacing: 12,

              children: [

                _botaoAcao(
                  icon: Icons.map,
                  titulo: "Mapa",
                  cor: AppCores.primaria,

                  onTap: () =>
                      _abrirMapa(
                    enderecoCompleto,
                  ),
                ),

                _botaoAcao(
                  icon: Icons.phone,
                  titulo: "Ligar",
                  cor: AppCores
                      .emAndamento,

                  onTap: telefone
                          .isEmpty
                      ? null
                      : () =>
                          _ligarCliente(
                            telefone,
                          ),
                ),

                _botaoAcao(
                  icon: Icons.chat,
                  titulo: "WhatsApp",
                  cor:
                      AppCores.concluido,

                  onTap: telefone
                          .isEmpty
                      ? null
                      : () =>
                          _abrirWhatsApp(
                            telefone,
                          ),
                ),

                _botaoAcao(
                  icon:
                      Icons.person_off,
                  titulo: "Ausente",
                  cor: AppCores.ausente,

                  onTap: () {

                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Cliente ausente...",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            // =========================================================
            // INICIAR EXECUÇÃO
            // =========================================================

            SizedBox(
              width: double.infinity,

              child:
                  ElevatedButton.icon(
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      AppCores.primaria,

                  minimumSize:
                      const Size(
                    double.infinity,
                    54,
                  ),
                ),

                onPressed: () {

                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Execução iniciada...",
                      ),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.play_arrow,

                  color: Colors.white,
                ),

                label: const Text(
                  "Iniciar Execução",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}