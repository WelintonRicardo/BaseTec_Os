import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controle/controle_os_cubit.dart';
import '../modelos/ordem_servico_modelo.dart';

class TelaDetalhesOS extends StatelessWidget {
  final OrdemServicoModelo os;

  const TelaDetalhesOS({super.key, required this.os});

  @override
  Widget build(BuildContext context) {
    // Formatação simples de hora
    final String horaInicio = os.janelaInicioAgendada?.hour.toString().padLeft(2, '0') ?? "00";
    final String horaFim = os.janelaFimAgendada?.hour.toString().padLeft(2, '0') ?? "00";

    return Scaffold(
      appBar: AppBar(
        title: Text('O.S: ${os.numeroAssistencia}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardStatus(),
            const SizedBox(height: 24),
            
            const Text('DADOS DO SEGURADO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(os.nomeSegurado, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Segurado Principal'),
            ),
            
            const SizedBox(height: 24),
            
            const Text('LOCALIZAÇÃO E HORÁRIO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time, color: Colors.blue),
              title: const Text('Janela de Atendimento'),
              subtitle: Text('$horaInicio:00 às $horaFim:00'),
            ),
            
            const SizedBox(height: 40),
            
            // Lógica de Ação
            if (os.status == 'pendente')
              _botaoAcao(
                label: 'REALIZAR CHECK-IN',
                cor: Colors.green,
                icone: Icons.location_on,
                onPressed: () => _executarCheckIn(context),
              )
            else if (os.status == 'em_atendimento')
              Column(
                children: [
                  _statusEmAndamento(),
                  const SizedBox(height: 16),
                  _botaoAcao(
                    label: 'ADICIONAR FOTOS / CHECKLIST',
                    cor: Colors.blue,
                    icone: Icons.camera_alt,
                    onPressed: () {
                      // Aqui chamaremos a tela de fotos que vamos criar
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStatus() {
    final bool isPendente = os.status == 'pendente';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPendente ? Colors.orange.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPendente ? Colors.orange : Colors.blue),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: isPendente ? Colors.orange : Colors.blue),
          const SizedBox(width: 12),
          Text(
            isPendente ? 'AGUARDANDO INÍCIO' : 'SERVIÇO EM ANDAMENTO',
            style: TextStyle(fontWeight: FontWeight.bold, color: isPendente ? Colors.orange.shade900 : Colors.blue.shade900),
          ),
        ],
      ),
    );
  }

  Widget _botaoAcao({required String label, required Color cor, required IconData icone, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        icon: Icon(icone),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _statusEmAndamento() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.blue),
          SizedBox(width: 8),
          Text('Atendimento iniciado!', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _executarCheckIn(BuildContext context) {
    context.read<ControleOSCubit>().realizarCheckIn(os.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Check-in realizado com sucesso!')),
    );
  }
}
