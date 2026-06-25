import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

import 'tecnico_os_detalhes.dart';

class TecnicoOSCard extends StatelessWidget {
  final DateTime selectedDate;

  final List<Map<String, dynamic>> osList;

  const TecnicoOSCard({
    super.key,
    required this.selectedDate,
    required this.osList,
  });

  String formatarHorario(dynamic data) {
    if (data == null) {
      return '--:--';
    }

    try {
      final dt = DateTime.parse(data.toString());

      final hora = dt.hour.toString().padLeft(2, '0');

      final minuto = dt.minute.toString().padLeft(2, '0');

      return '$hora:$minuto';
    } catch (e) {
      return '--:--';
    }
  }

  Color corStatus(String status) {
    switch (status.toLowerCase()) {
      case 'concluído':
      case 'concluido':
        return AppCores.concluido;

      case 'em andamento':
        return AppCores.emAndamento;

      case 'aguardando peça':
      case 'aguardando peca':
        return Colors.orange;

      case 'cancelado':
        return Colors.red;

      default:
        return AppCores.primaria;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (osList.isEmpty) {
      return Card(
        color: AppCores.cardEscuro,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        child: const Padding(
          padding: EdgeInsets.all(20),

          child: Center(
            child: Text(
              "Nenhuma ordem de serviço encontrada",

              style: TextStyle(color: AppCores.textoCinza),
            ),
          ),
        ),
      );
    }

    final osFiltradas = osList.where((os) {
      final dataIso = os['janela_inicio_agendada'];

      if (dataIso == null) {
        return false;
      }

      try {
        final dt = DateTime.parse(dataIso.toString());

        return dt.year == selectedDate.year &&
            dt.month == selectedDate.month &&
            dt.day == selectedDate.day;
      } catch (e) {
        return false;
      }
    }).toList();

    return Column(
      children: osFiltradas.map((os) {
        final numeroOS = os['numero_os']?.toString() ?? '---';

        final segurado = os['nome_segurado']?.toString() ?? 'Sem segurado';

        final status = os['status']?.toString() ?? 'Sem status';

        final endereco =
            os['endereco']?.toString() ??
            os['rua']?.toString() ??
            'Sem endereço';

        final inicio = formatarHorario(os['janela_inicio_agendada']);

        final fim = formatarHorario(os['janela_fim_agendada']);

        final cidade = os['cidade']?.toString() ?? 'Sem cidade';

        final descricaoServico =
            os['descricao_servico']?.toString() ?? 'Sem descrição';
        final ordemRota = os['ordem_rota'] ?? 0;

        final kmTrecho = (os['km_trecho'] ?? 0).toDouble();

        final kmAcumulado = (os['km_acumulado'] ?? 0).toDouble();

        final minutosTrecho = os['minutos_trecho'] ?? 0;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => TecnicoOSDetalhes(os: os)),
            );
          },

          child: Container(
            margin: const EdgeInsets.only(bottom: 14),

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: AppCores.cardEscuro,

              borderRadius: BorderRadius.circular(18),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // HEADER
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppCores.primaria.withOpacity(0.2),

                      child: const Icon(
                        Icons.assignment_rounded,

                        color: AppCores.primaria,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "OS: $numeroOS",

                            style: const TextStyle(
                              color: AppCores.textoBranco,

                              fontWeight: FontWeight.bold,

                              fontSize: 14,
                            ),
                          ),

                          Text(
                            segurado,

                            style: const TextStyle(color: AppCores.textoCinza),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: corStatus(status).withOpacity(0.15),

                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: Text(
                        status,

                        style: TextStyle(
                          color: corStatus(status),

                          fontWeight: FontWeight.bold,

                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ENDEREÇO
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,

                      color: AppCores.textoCinza,

                      size: 18,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        endereco,

                        style: const TextStyle(color: AppCores.textoCinza),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // CIDADE
                Row(
                  children: [
                    const Icon(
                      Icons.location_city,

                      color: AppCores.textoCinza,

                      size: 18,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        cidade,

                        style: const TextStyle(color: AppCores.textoCinza),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // DESCRIÇÃO SERVIÇO
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.build_circle_outlined,

                            color: AppCores.primaria,

                            size: 18,
                          ),

                          SizedBox(width: 6),

                          Text(
                            "Serviço",

                            style: TextStyle(
                              color: AppCores.primaria,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      Text(
                        descricaoServico,

                        maxLines: 3,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: AppCores.textoBranco,

                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // HORÁRIO
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,

                      color: AppCores.textoCinza,

                      size: 18,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      "$inicio às $fim",

                      style: const TextStyle(
                        color: AppCores.textoBranco,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: AppCores.primaria.withOpacity(0.08),

                    borderRadius: BorderRadius.circular(12),

                    border: Border.all(
                      color: AppCores.primaria.withOpacity(0.3),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        '🚩 Parada #$ordemRota',

                        style: const TextStyle(
                          color: AppCores.primaria,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '🚗 Trecho: ${kmTrecho.toStringAsFixed(1)} km',

                        style: const TextStyle(color: AppCores.textoBranco),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '📊 Acumulado: ${kmAcumulado.toStringAsFixed(1)} km',

                        style: const TextStyle(color: AppCores.textoCinza),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '🕒 Deslocamento: $minutosTrecho min',

                        style: const TextStyle(color: AppCores.textoCinza),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),
                // BOTÕES
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) => TecnicoOSDetalhes(os: os),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppCores.primaria,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        icon: const Icon(Icons.visibility, color: Colors.white),

                        label: const Text(
                          "Detalhes",

                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
