import 'package:flutter/material.dart';
import '../tema_cores.dart';

typedef MenuCallback = void Function(String key);

class AdminLayout extends StatelessWidget {
  final String titulo;
  final Widget body;
  final Widget? sidePanel; // painel lateral (ex: lista de técnicos)
  final List<Widget>? actions;
  final FloatingActionButton? floatingActionButton;
  final MenuCallback? onMenuSelected;
  final bool showSearchBar;

  const AdminLayout({
    super.key,
    required this.titulo,
    required this.body,
    this.sidePanel,
    this.actions,
    this.floatingActionButton,
    this.onMenuSelected,
    this.showSearchBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,
      appBar: AppBar(
        backgroundColor: AppCores.cardEscuro,
        title: showSearchBar ? _buildSearchBar() : Text(titulo, style: const TextStyle(color: Colors.white)),
        actions: [
          if (actions != null) ...actions!,
          PopupMenuButton<String>(
            color: AppCores.cardEscuro,
            onSelected: (v) {
              if (onMenuSelected != null) onMenuSelected!(v);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'cad_tecnico', child: Text('Cadastro de técnico', style: TextStyle(color: Colors.white))),
              PopupMenuItem(value: 'config', child: Text('Configurações', style: TextStyle(color: Colors.white))),
              PopupMenuItem(value: 'financeiro', child: Text('Aba financeiro', style: TextStyle(color: Colors.white))),
              PopupMenuItem(value: 'rel_os', child: Text('Relatório de OS', style: TextStyle(color: Colors.white))),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Row(
        children: [
          if (sidePanel != null)
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: sidePanel,
              ),
            ),
          Expanded(
            flex: sidePanel != null ? 7 : 10,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: body,
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
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
}
