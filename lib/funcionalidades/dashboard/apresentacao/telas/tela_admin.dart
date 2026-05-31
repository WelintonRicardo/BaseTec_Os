import 'package:flutter/material.dart';
import '../widgets/painel_resumo_widget.dart';
import '../../../../compartilhado/tema_cores.dart';
import 'package:basetec_os/funcionalidades/cadastro/apresentacao/telas/tela_cadastro_os.dart';

class TelaAdmin extends StatelessWidget {
  const TelaAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,
      appBar: AppBar(
        backgroundColor: AppCores.cardEscuro,
        title: _buildSearchBar(),
        actions: [IconButton(icon: const Icon(Icons.notifications), onPressed: () {})],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildCalendarioBR(),
                  const SizedBox(height: 20),
                  _buildListaTecnicos(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PainelResumoWidget(),
                  const SizedBox(height: 30),
                  const Text(
                    "Ordens de Serviço do Dia",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: _buildListaOSDia()),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaCadastroOS()),
          );
        },
        backgroundColor: AppCores.primaria,
        icon: const Icon(Icons.add),
        label: const Text("Nova O.S"),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45,
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Buscar por Nº O.S ou Nome do Segurado...",
          hintStyle: TextStyle(color: Colors.white38),
          prefixIcon: Icon(Icons.search, color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCalendarioBR() {
    return CalendarDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      onDateChanged: (date) {},
    );
  }

  Widget _buildListaTecnicos() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppCores.cardEscuro, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Técnicos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white10),
          _buildItemTecnico("João Silva", 5, 1),
          _buildItemTecnico("Marcos Souza", 3, 0),
        ],
      ),
    );
  }

  Widget _buildItemTecnico(String nome, int ok, int cancel) {
    return ListTile(
      title: Text(nome, style: const TextStyle(color: Colors.white, fontSize: 14)),
      subtitle: Text("Finalizadas: $ok | Canceladas: $cancel", style: const TextStyle(color: Colors.white38, fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
    );
  }

  Widget _buildListaOSDia() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Card(
        color: AppCores.cardEscuro,
        child: ListTile(
          title: Text("OS #102$index - Nome Segurado", style: const TextStyle(color: Colors.white)),
          subtitle: const Text("Status: Em atendimento", style: TextStyle(color: AppCores.primaria)),
          trailing: const Icon(Icons.more_vert, color: Colors.white70),
        ),
      ),
    );
  }
}