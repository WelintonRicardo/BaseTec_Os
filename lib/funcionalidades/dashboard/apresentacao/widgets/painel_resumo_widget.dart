// lib/funcionalidades/dashboard/apresentacao/widgets/painel_resumo_widget.dart

import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

/// Widget de resumo do painel administrativo.
/// Recebe listas de usuários e ordens de serviço já carregadas do Supabase.
class PainelResumoWidget extends StatelessWidget {
  final List<Map<String, dynamic>> usuarios;
  final List<Map<String, dynamic>> ordensServico;

  const PainelResumoWidget({
    super.key,
    required this.usuarios,
    required this.ordensServico,
  });

  @override
  Widget build(BuildContext context) {
    final totalUsuarios = usuarios.length;
    final totalOS = ordensServico.length;
    final osConcluidas =
        ordensServico.where((os) => os['status'] == 'concluida').length;
    final osCanceladas =
        ordensServico.where((os) => os['status'] == 'cancelada').length;
    final osPendentes =
        ordensServico.where((os) => os['status'] == 'pendente').length;
    final osAguardando =
        ordensServico.where((os) => os['status'] == 'aguardando_peca').length;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildCard("Total O.S", "$totalOS", Icons.assignment, AppCores.primaria),
        _buildCard("Usuários", "$totalUsuarios", Icons.people, AppCores.textoBranco),
        _buildCard("Concluídas", "$osConcluidas", Icons.check_circle, AppCores.concluido),
        _buildCard("Canceladas", "$osCanceladas", Icons.cancel, AppCores.cancelado),
        _buildCard("Pendentes", "$osPendentes", Icons.hourglass_empty, AppCores.pendente),
        _buildCard("Aguardando Peças", "$osAguardando", Icons.settings_input_component, AppCores.ausente),
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
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
