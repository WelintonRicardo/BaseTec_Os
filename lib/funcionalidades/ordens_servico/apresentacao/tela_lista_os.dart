import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controle/controle_os_cubit.dart';
import '../modelos/ordem_servico_modelo.dart';

class TelaListaOS extends StatelessWidget {
  const TelaListaOS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BaseTec OS - Minha Rota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              // No Real-time não precisa, mas deixamos para garantir
            },
          ),
        ],
      ),
      body: BlocBuilder<ControleOSCubit, EstadoOS>(
        builder: (context, estado) {
          if (estado is EstadoOSCarregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (estado is EstadoOSErro) {
            return Center(child: Text(estado.mensagem));
          }

          if (estado is EstadoOSSucesso) {
            final ordens = estado.listaOrdens;

            if (ordens.isEmpty) {
              return const Center(child: Text('Nenhuma O.S. enviada hoje.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: ordens.length,
              itemBuilder: (context, index) {
                final os = ordens[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text('O.S: ${os.numeroAssistencia}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cliente: ${os.nomeSegurado}'),
                        Text('Janela: ${os.janelaInicioAgendada.hour}:00 - ${os.janelaFimAgendada.hour}:00'),
                      ],
                    ),
                    trailing: _buildBadgeStatus(os.status),
                    onTap: () {
                      // Próximo passo: Tela de detalhes (Check-in)
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // Widget para mostrar o status bonitinho
  Widget _buildBadgeStatus(String status) {
    Color cor = Colors.grey;
    if (status == 'em_rota') cor = Colors.orange;
    if (status == 'concluida') cor = Colors.green;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
