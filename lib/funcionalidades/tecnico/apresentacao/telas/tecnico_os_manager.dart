import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';
import 'tecnico_os_card.dart';

class TecnicoOSManager extends StatefulWidget {
  final DateTime selectedDate;

  const TecnicoOSManager({super.key, required this.selectedDate});

  @override
  State<TecnicoOSManager> createState() => _TecnicoOSManagerState();
}

class _TecnicoOSManagerState extends State<TecnicoOSManager> {
  List<Map<String, dynamic>> osList = [];

  @override
  void initState() {
    super.initState();
    _loadOSDoDia(widget.selectedDate);
  }

  void _loadOSDoDia(DateTime date) {
    // ⚠️ Mock: depois vamos buscar do Supabase
    setState(() {
      osList = List.generate(
        date.day % 4 + 1, // gera entre 1 e 4 OS só para simular
        (i) => {
          'titulo': 'OS #${i + 1} - Cliente ${i + 1}',
          'status': i % 2 == 0 ? 'Concluído' : 'Em andamento',
          'endereco': 'Rua Exemplo ${i + 10}, Bairro Centro',
          'horario': i % 2 == 0 ? 'Manhã' : 'Tarde',
        },
      );
    });
  }

  void _onCalcularRota() {
    // Aqui vamos chamar o arquivo rota_calculadora.dart
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calcular melhor rota entre as OS...'),
        backgroundColor: AppCores.cardEscuro,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TecnicoOSCard(selectedDate: widget.selectedDate, osList: osList),
      ),
      floatingActionButton: osList.length > 1
          ? FloatingActionButton.extended(
              backgroundColor: AppCores.primaria,
              icon: const Icon(Icons.alt_route, color: Colors.white),
              label: const Text("Calcular Rota"),
              onPressed: _onCalcularRota,
            )
          : null,
    );
  }
}
