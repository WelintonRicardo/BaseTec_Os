import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

Widget buildListaTecnicos(List<Map<String, dynamic>> tecnicos) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppCores.cardEscuro,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppCores.bordaEscura),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.engineering_rounded, color: AppCores.primaria),
            SizedBox(width: 10),
            Text("Técnicos", style: TextStyle(color: AppCores.textoBranco, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 14),
        if (tecnicos.isEmpty)
          const Center(child: Text("Nenhum técnico encontrado", style: TextStyle(color: AppCores.textoCinza))),
        if (tecnicos.isNotEmpty)
          ...tecnicos.map((t) {
            return buildItemTecnico(
              nome: t['nome']?.toString() ?? 'Sem nome',
              totalOsMes: int.tryParse(t['total_os_mes']?.toString() ?? '0') ?? 0,
              concluidas: int.tryParse(t['concluidas']?.toString() ?? '0') ?? 0,
            );
          }).toList(),
      ],
    ),
  );
}

Widget buildItemTecnico({required String nome, required int totalOsMes, required int concluidas}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppCores.fundoEscuro, borderRadius: BorderRadius.circular(16)),
    child: Row(
      children: [
        CircleAvatar(backgroundColor: AppCores.primaria.withOpacity(0.2), child: const Icon(Icons.person, color: AppCores.primaria)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nome, style: const TextStyle(color: AppCores.textoBranco, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  _badge('OS no mês: $totalOsMes', AppCores.primaria, AppCores.primaria.withOpacity(0.15)),
                  const SizedBox(width: 8),
                  _badge('Concluídas: $concluidas', Colors.green, Colors.green.withOpacity(0.15)),
                ],
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppCores.textoCinza),
      ],
    ),
  );
}

Widget _badge(String texto, Color corTexto, Color corFundo) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // ✅ menor
    decoration: BoxDecoration(
      color: corFundo,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      texto,
      style: TextStyle(
        color: corTexto,
        fontSize: 9, // ✅ fonte menor
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

