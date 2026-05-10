import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';

class ModalAssinaturaWidget extends StatefulWidget {
  const ModalAssinaturaWidget({super.key});

  @override
  State<ModalAssinaturaWidget> createState() => _ModalAssinaturaWidgetState();
}

class _ModalAssinaturaWidgetState extends State<ModalAssinaturaWidget> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );
  final TextEditingController _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Força a tela a ficar deitada ao abrir o modal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Volta para o modo vertical ao fechar
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Assinatura do Cliente"),
        actions: [
          IconButton(icon: const Icon(Icons.clear), onPressed: () => _controller.clear()),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () async {
              if (_controller.isNotEmpty && _nomeController.text.isNotEmpty) {
                final imagem = await _controller.toPngBytes();
                Navigator.pop(context, {'nome': _nomeController.text, 'imagem': imagem});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Preencha o nome e faça a assinatura!")),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome de quem está recebendo o técnico",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Signature(
                controller: _controller,
                backgroundColor: Colors.grey[50]!,
              ),
            ),
          ),
          const Text("Assine no campo acima com o celular deitado", 
            style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
