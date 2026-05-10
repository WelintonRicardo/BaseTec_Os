import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controle/controle_os_cubit.dart';
import '../../modelos/ordem_servico_modelo.dart';
import '../widgets/card_os_widget.dart'; // Nosso componente novo
import '../tela_detalhes_os.dart';

class TelaListaOS extends StatelessWidget {
  const TelaListaOS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BaseTec OS - Minha Rota'),
        centerTitle: true,
      ),
      body: BlocBuilder<ControleOSCubit, EstadoOS>(
        builder: (context, estado) {
          if (estado is EstadoOSCarregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (estado is EstadoOSErro) {
            return _buildViewErro(context, estado.mensagem);
          }

          if (estado is EstadoOSSucesso) {
            final ordens = estado.listaOrdens;

            if (ordens.isEmpty) {
              return const Center(child: Text('Nenhuma O.S. encontrada.'));
            }

            return RefreshIndicator(
              onRefresh: () async => _recarregarRota(context),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: ordens.length,
                itemBuilder: (context, index) {
                  final os = ordens[index];

                  // A mágica acontece aqui: O CardOSWidget resolve 
                  // sozinho as cores, ícones e nomes de status.
                  return CardOSWidget(
                    os: os,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TelaDetalhesOS(os: os),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Lógica de recarregamento centralizada
  void _recarregarRota(BuildContext context) {
    context.read<ControleOSCubit>().escutarOrdens(
          'TECNICO_TESTE_01',
          'f52fe913-5a03-4c27-9509-2bbff81aa63a',
        );
  }

  // Widget de Erro separado para limpar o build principal
  Widget _buildViewErro(BuildContext context, String mensagem) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _recarregarRota(context),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
