  import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class PainelResumoWidget extends StatelessWidget {
  const PainelResumoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildCard("Total O.S", "125", Icons.assignment, AppCores.primaria),
        _buildCard("Clientes Ausentes", "12", Icons.person_off, AppCores.ausente),
        _buildCard("Concluídos", "85", Icons.check_circle, AppCores.concluido),
        _buildCard("Aguardando Peças", "08", Icons.settings_input_component, AppCores.pendente),
        _buildCard("Canceladas", "05", Icons.cancel, AppCores.cancelado),
      ],
    );
  }

  Widget _buildCard(String label, String valor, IconData icone, Color cor) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppCores.cardEscuro,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icone, color: cor, size: 30),
          const SizedBox(height: 10),
          Text(valor, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }
}
