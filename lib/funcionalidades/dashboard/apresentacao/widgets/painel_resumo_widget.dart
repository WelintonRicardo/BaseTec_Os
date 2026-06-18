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
    final totalUsuarios = usuarios.length;

    int concluidas = 0;
    int pendentes = 0;
    int aguardandoPeca = 0;
    int clienteAusente = 0;

    for (final os in ordensServico) {
      final status = (os['status'] ?? '').toString().trim().toLowerCase();


      if (status == 'concluido' || status == 'concluida') {
        concluidas++;
      }

      if (status == 'pendente') {
        pendentes++;
      }

      if (status == 'aguardando_peca') {
        aguardandoPeca++;
      }

      if (status == 'cliente ausente') {
        clienteAusente++;
      }
    }

    /// Total refletindo exatamente os cards
    final totalOS = concluidas + pendentes + aguardandoPeca + clienteAusente;
    final cards = [
      _ResumoCard(
        titulo: 'Usuários',
        valor: totalUsuarios.toString(),
        cor: AppCores.primaria,
        icone: Icons.people_alt_rounded,
      ),
      _ResumoCard(
        titulo: 'Total OS',
        valor: totalOS.toString(),
        cor: Colors.deepPurpleAccent,
        icone: Icons.assignment_rounded,
      ),
      _ResumoCard(
        titulo: 'Concluídas',
        valor: concluidas.toString(),
        cor: AppCores.concluido,
        icone: Icons.check_circle_rounded,
      ),

      _ResumoCard(
        titulo: 'Pendentes',
        valor: pendentes.toString(),
        cor: AppCores.pendente,
        icone: Icons.schedule_rounded,
      ),
      _ResumoCard(
        titulo: 'Aguardando Peça',
        valor: aguardandoPeca.toString(),
        cor: Colors.indigoAccent,
        icone: Icons.hourglass_top_rounded,
      ),
      _ResumoCard(
        titulo: 'Cliente Ausente',
        valor: clienteAusente.toString(),
        cor: Colors.orangeAccent,
        icone: Icons.person_off_rounded,
      ),
    ];

    final largura = MediaQuery.of(context).size.width;

    int colunas = 2;

    if (largura > 700) {
      colunas = 3;
    }

    if (largura > 1200) {
      colunas = 6;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: colunas,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.85,
      ),
      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  }
}

class _ResumoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color cor;
  final IconData icone;

  const _ResumoCard({
    required this.titulo,
    required this.valor,
    required this.cor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppCores.cardEscuro, AppCores.cardEscuro.withOpacity(0.85)],
        ),
        border: Border.all(color: cor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: cor.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: cor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icone, color: cor, size: 28),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  style: TextStyle(
                    color: cor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppCores.textoBranco,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'Neste mês',
                  style: TextStyle(color: AppCores.textoCinza, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
