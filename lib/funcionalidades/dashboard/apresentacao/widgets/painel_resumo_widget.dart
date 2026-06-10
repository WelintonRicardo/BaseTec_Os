import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class PainelResumoWidget extends StatelessWidget {
  final List<Map<String, dynamic>> usuarios;
  final List<Map<String, dynamic>> ordensServico;

  const PainelResumoWidget({
    super.key,
    required this.usuarios,
    required this.ordensServico,
  });

  @override
  Widget build(BuildContext context) {
    // calcular estatísticas
    final totalUsuarios = usuarios.length.toString();
    final totalOS = ordensServico.length.toString();
    final concluidas = ordensServico.where((os) => os['status'] == 'concluida').length.toString();
    final canceladas = ordensServico.where((os) => os['status'] == 'cancelada').length.toString();
    final pendentes = ordensServico.where((os) => os['status'] == 'pendente').length.toString();
    final aguardandoPeca = ordensServico.where((os) => os['status'] == 'aguardando_peca').length.toString();

    final List<Map<String, String>> dados = [
      {"titulo": "Usuários", "valor": totalUsuarios, "cor": "primaria"},
      {"titulo": "Total OS", "valor": totalOS, "cor": "secundaria"},
      {"titulo": "Concluídas", "valor": concluidas, "cor": "concluido"},
      {"titulo": "Canceladas", "valor": canceladas, "cor": "cancelado"},
      {"titulo": "Pendentes", "valor": pendentes, "cor": "pendente"},
      {"titulo": "Aguardando Peça", "valor": aguardandoPeca, "cor": "ausente"},
    ];

    // Responsividade
    final largura = MediaQuery.of(context).size.width;
    int crossAxisCount = 2; // mobile
    if (largura >= 600 && largura < 1024) {
      crossAxisCount = 3; // tablet
    } else if (largura >= 1024) {
      crossAxisCount = 6; // desktop
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2, // ✅ mais alto (cards maiores)
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: dados.length,
      itemBuilder: (context, index) {
        final item = dados[index];
        return _cardResumo(item["titulo"]!, item["valor"]!, _mapCor(item["cor"]!));
      },
    );
  }

  Color _mapCor(String cor) {
    switch (cor) {
      case "primaria":
        return AppCores.primaria;
      case "secundaria":
        return AppCores.secundaria;
      case "concluido":
        return AppCores.concluido;
      case "cancelado":
        return AppCores.cancelado;
      case "pendente":
        return AppCores.pendente;
      case "ausente":
        return AppCores.ausente;
      default:
        return AppCores.textoBranco;
    }
  }

  Widget _cardResumo(String titulo, String valor, Color cor) {
    return InkWell( // ✅ já preparado para ser tocável
      onTap: () {
        // ação futura aqui
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14), // ✅ mais espaçamento
        decoration: BoxDecoration(
          color: AppCores.cardEscuro,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              valor,
              style: TextStyle(
                color: cor,
                fontSize: 18, // ✅ fonte maior
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              titulo,
              style: const TextStyle(
                color: AppCores.textoBranco,
                fontSize: 12, // ✅ fonte maior
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
