import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this); // 6 abas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,
      appBar: AppBar(
        backgroundColor: AppCores.cardEscuro,
        title: const Text("Configurações"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppCores.primaria,
          tabs: const [
            Tab(text: "Conta"),
            Tab(text: "Empresa"),
            Tab(text: "OS"),
            Tab(text: "Notificações"),
            Tab(text: "Integrações"),
            Tab(text: "Segurança"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConta(),
          _buildEmpresa(),
          _buildOS(),
          _buildNotificacoes(),
          _buildIntegracoes(),
          _buildSeguranca(),
        ],
      ),
    );
  }

  // ==============================
  // Abas de Configuração
  // ==============================

  Widget _buildConta() {
    return _gridOpcoes([
      {"titulo": "Alterar Senha", "icone": Icons.lock},
      {"titulo": "Idioma", "icone": Icons.language},
      {"titulo": "Fuso Horário", "icone": Icons.access_time},
    ]);
  }

  Widget _buildEmpresa() {
    return _gridOpcoes([
      {"titulo": "Dados da Empresa", "icone": Icons.business},
      {"titulo": "Logotipo", "icone": Icons.image},
      {"titulo": "Identidade Visual", "icone": Icons.color_lens},
    ]);
  }

  Widget _buildOS() {
    return _gridOpcoes([
      {"titulo": "Status Personalizados", "icone": Icons.list},
      {"titulo": "Prazos Padrão", "icone": Icons.schedule},
      {"titulo": "Regras de Notificação", "icone": Icons.notifications_active},
    ]);
  }

  Widget _buildNotificacoes() {
    return _gridOpcoes([
      {"titulo": "E-mails Automáticos", "icone": Icons.email},
      {"titulo": "Push Notifications", "icone": Icons.phone_android},
      {"titulo": "Lembretes Automáticos", "icone": Icons.alarm},
    ]);
  }

  Widget _buildIntegracoes() {
    return _gridOpcoes([
      {"titulo": "WhatsApp", "icone": Icons.chat},
      {"titulo": "E-mail Corporativo", "icone": Icons.mail},
      {"titulo": "ERP/Estoque", "icone": Icons.storage},
    ]);
  }

  Widget _buildSeguranca() {
    return _gridOpcoes([
      {"titulo": "Autenticação 2FA", "icone": Icons.security},
      {"titulo": "Políticas de Senha", "icone": Icons.vpn_key},
      {"titulo": "Logs de Acesso", "icone": Icons.history},
    ]);
  }

  // ==============================
  // Grid de opções
  // ==============================
  Widget _gridOpcoes(List<Map<String, dynamic>> opcoes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // dois cards por linha
        childAspectRatio: 1.2, // proporção mais quadrada
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: opcoes.length,
      itemBuilder: (context, index) {
        final item = opcoes[index];
        return InkWell(
          onTap: () {
            // Aqui você implementa a navegação ou ação
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Abrindo ${item['titulo']}...")),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: AppCores.cardEscuro,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icone'], color: AppCores.primaria, size: 32),
                const SizedBox(height: 8),
                Text(
                  item['titulo'],
                  style: const TextStyle(
                    color: AppCores.textoBranco,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
