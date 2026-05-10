import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controle/os_formulario_cubit.dart';
import '../widgets/secao_fotos_widget.dart';

class OSDetalheFormulario extends StatelessWidget {
  final String osId;

  const OSDetalheFormulario({super.key, required this.osId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provedor do Cubit que gerencia a lógica de upload
      create: (context) => OSFormularioCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ordem de Serviço #$osId"),
          centerTitle: true,
        ),
        body: BlocBuilder<OSFormularioCubit, OSFormState>(
          builder: (context, state) {
            // Pegamos a lista de fotos do estado do Cubit (se houver)
            // Para a Fase 1, se não houver fotos, passamos uma lista vazia
            List<String> fotosAtuais = [];
            bool estaCarregando = state is OSFormCarregando;

            if (state is OSFormSucesso) {
              // Em um cenário real, você acumularia as URLs aqui
              fotosAtuais.add(state.url);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações Básicas da O.S.
                  const Card(
                    elevation: 0,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.white),
                      title: Text("João Silva", 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text("Reparo de Ar Condicionado", 
                        style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Chamada CORRIGIDA para o novo nome do Widget
                  SecaoFotosWidget(
                    titulo: "Fotos do Serviço (Evidências)",
                    fotos: fotosAtuais,
                    carregando: estaCarregando,
                    aoClicarCapturar: () {
                      // Chama a função de tirar foto passando o ID da OS e o tipo
                      context.read<OSFormularioCubit>().tirarFoto(osId, 'servico');
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Botão de Finalização
                  ElevatedButton(
                    onPressed: estaCarregando ? null : () {
                      // Lógica da Fase 1 para encerrar a O.S.
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("FINALIZAR ATENDIMENTO", 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
