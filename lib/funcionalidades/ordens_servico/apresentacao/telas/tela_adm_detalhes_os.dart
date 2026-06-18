import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

class TelaAdmDetalhesOS extends StatelessWidget {
  final Map<String, dynamic> os;

  const TelaAdmDetalhesOS({
    super.key,
    required this.os,
  });

  @override
  Widget build(BuildContext context) {
    final numeroOS = os['numero_os']?.toString() ?? '---';

    final segurado =
        os['nome_segurado']?.toString() ?? 'Não informado';

    final status =
        os['status']?.toString() ?? 'Não informado';

    final seguradora =
        os['seguradora']?.toString() ?? 'Não informado';

    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      appBar: AppBar(
        backgroundColor: AppCores.cardEscuro,
        title: Text(
          'OS $numeroOS',
          style: const TextStyle(
            color: AppCores.textoBranco,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCabecalho(
              numeroOS,
              segurado,
              status,
              seguradora,
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Próxima etapa: Card Segurado',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCabecalho(
    String numeroOS,
    String segurado,
    String status,
    String seguradora,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: AppCores.cardEscuro,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OS $numeroOS',
            style: const TextStyle(
              color: AppCores.textoBranco,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            segurado,
            style: const TextStyle(
              color: AppCores.textoBranco,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _tag(status),
              _tag(seguradora),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: AppCores.primaria.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Text(
        texto,
        style: const TextStyle(
          color: AppCores.primaria,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}