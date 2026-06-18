import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


class OsVisualizadorPage extends StatefulWidget {
  final String token;

  const OsVisualizadorPage({
    super.key,
    required this.token,
  });

  @override
  State<OsVisualizadorPage> createState() => _OsVisualizadorPageState();
}

class _OsVisualizadorPageState extends State<OsVisualizadorPage> {
  Map<String, dynamic>? os;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarOS();
  }

  Future<void> _carregarOS() async {
    final response = await http.get(
      Uri.parse("https://api.seudominio.com/os/publica/${widget.token}"),
    );

    if (response.statusCode == 200) {
      setState(() {
        os = jsonDecode(response.body);
        carregando = false;
      });
    } else {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (os == null) {
      return const Scaffold(
        body: Center(child: Text("OS não encontrada")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 20),
                _cardInfo(),
                const SizedBox(height: 20),
                _cardDetalhes(),
                const SizedBox(height: 20),
                _acoes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ordem de Serviço #${os!['numero_os']}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            os!['nome_segurado'] ?? '',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _cardInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _info("Status", os!['status']),
          _info("Cidade", os!['cidade']),
          _info("Tipo", os!['tipo_servico']),
        ],
      ),
    );
  }

  Widget _cardDetalhes() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detalhes",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            os!['observacoes'] ?? 'Sem observações',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
Widget _acoes() {
  final link = "https://seusistema.com/os/${widget.token}";

  return Row(
    children: [
      ElevatedButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: link));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Link copiado para a área de transferência"),
            ),
          );
        },
        child: const Text("Copiar link"),
      ),
      const SizedBox(width: 10),
      ElevatedButton(
        onPressed: () async {
          final whatsapp = Uri.parse("https://wa.me/?text=Veja sua OS: $link");
          if (await canLaunchUrl(whatsapp)) {
            await launchUrl(whatsapp, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Não foi possível abrir o WhatsApp"),
              ),
            );
          }
        },
        child: const Text("WhatsApp"),
      ),
    ],
  );
}


  Widget _info(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value?.toString() ?? '-',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}