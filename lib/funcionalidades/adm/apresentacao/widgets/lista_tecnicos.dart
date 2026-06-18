import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

Widget buildListaTecnicos(List<Map<String, dynamic>> tecnicos) {
  return Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppCores.cardEscuro, AppCores.cardEscuro.withOpacity(0.85)],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppCores.primaria.withOpacity(0.15)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.30),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.engineering_rounded, color: AppCores.primaria, size: 24),
            SizedBox(width: 10),
            Text(
              "Técnicos",
              style: TextStyle(
                color: AppCores.textoBranco,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        if (tecnicos.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                "Nenhum técnico encontrado",
                style: TextStyle(color: AppCores.textoCinza),
              ),
            ),
          ),

        if (tecnicos.isNotEmpty)
          ...tecnicos.map((t) {
  return buildItemTecnico(
    nome: t['nome']?.toString() ?? 'Sem nome',

    totalOsMes:
        int.tryParse(t['total_os_mes']?.toString() ?? '0') ?? 0,

    concluidas:
        int.tryParse(t['concluidas']?.toString() ?? '0') ?? 0,

    pendentes:
        int.tryParse(t['pendentes']?.toString() ?? '0') ?? 0,

    aguardandoPeca:
        int.tryParse(t['aguardando_peca']?.toString() ?? '0') ?? 0,

    clienteAusente:
        int.tryParse(t['cliente_ausente']?.toString() ?? '0') ?? 0,
  );
}).toList(),
      ],
    ),
  );
}

Widget buildItemTecnico({
  required String nome,
  required int totalOsMes,
  required int concluidas,
  required int pendentes,
  required int aguardandoPeca,
  required int clienteAusente,
}) {

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppCores.fundoEscuro,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withOpacity(0.05)),
    ),
    child: Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppCores.primaria.withOpacity(0.15),
          ),
          child: Center(
            child: Text(
              nome.isNotEmpty ? nome.substring(0, 1).toUpperCase() : "T",
              style: const TextStyle(
                color: AppCores.primaria,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nome,
                style: const TextStyle(
                  color: AppCores.textoBranco,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Wrap(
  spacing: 6,
  runSpacing: 6,
  children: [
    _badge(
      'Pendentes: $pendentes',
      AppCores.pendente,
      AppCores.pendente.withOpacity(0.15),
    ),

    _badge(
      'Aguardando: $aguardandoPeca',
      Colors.indigoAccent,
      Colors.indigoAccent.withOpacity(0.15),
    ),

    _badge(
      'Ausente: $clienteAusente',
      AppCores.ausente,
      AppCores.ausente.withOpacity(0.15),
    ),

    _badge(
      'Concluídas: $concluidas',
      AppCores.concluido,
      AppCores.concluido.withOpacity(0.15),
    ),
  ],
),
                ],
              ),
            ],
          ),
        ),

        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppCores.textoCinza,
          ),
        ),
      ],
    ),
  );
}

Widget _badge(String texto, Color corTexto, Color corFundo) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: corFundo,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      texto,
      style: TextStyle(
        color: corTexto,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
