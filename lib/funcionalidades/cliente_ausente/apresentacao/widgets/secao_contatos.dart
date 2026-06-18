import 'package:flutter/material.dart';

import '../../../../../compartilhado/tema_cores.dart';
import '../../aplicacao/cliente_ausente_controller.dart';

class SecaoContatos extends StatefulWidget {
  final ClienteAusenteController controller;

  const SecaoContatos({
    super.key,
    required this.controller,
  });

  @override
  State<SecaoContatos> createState() =>
      _SecaoContatosState();
}

class _SecaoContatosState
    extends State<SecaoContatos> {
  final List<String> contatos = [
    'Ligação',
    'WhatsApp',
    'Interfone',
    'SMS',
  ];

  final List<String> resultados = [
    'Sem Resposta',
    'Caixa Postal',
    'Telefone Desligado',
    'Número Inválido',
    'Não Visualizou',
    'Sem Retorno',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppCores.cardEscuro,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Row(
            children: [
              Icon(
                Icons.phone_in_talk,
                color: AppCores.primaria,
              ),

              SizedBox(width: 8),

              Text(
                'Tentativas de Contato',

                style: TextStyle(
                  color: AppCores.textoBranco,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Informe as tentativas realizadas antes de registrar a ausência.',

            style: TextStyle(
              color: Colors.white60,
            ),
          ),

          const SizedBox(height: 20),

          // =====================================================
          // CONTATO 1
          // =====================================================

          const Text(
            'Tentativa 1',

            style: TextStyle(
              color: AppCores.textoBranco,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            value: widget.controller.contato1,

            dropdownColor: AppCores.cardEscuro,

            decoration: InputDecoration(
              labelText: 'Tipo de contato',

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),

            items: contatos.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                widget.controller.contato1 = value;
              });
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: widget.controller.resultado1,

            dropdownColor: AppCores.cardEscuro,

            decoration: InputDecoration(
              labelText: 'Resultado',

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),

            items: resultados.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                widget.controller.resultado1 =
                    value;
              });
            },
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CONTATO 2
          // =====================================================

          const Text(
            'Tentativa 2',

            style: TextStyle(
              color: AppCores.textoBranco,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            value: widget.controller.contato2,

            dropdownColor: AppCores.cardEscuro,

            decoration: InputDecoration(
              labelText: 'Tipo de contato',

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),

            items: contatos.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                widget.controller.contato2 = value;
              });
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: widget.controller.resultado2,

            dropdownColor: AppCores.cardEscuro,

            decoration: InputDecoration(
              labelText: 'Resultado',

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),

            items: resultados.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                widget.controller.resultado2 =
                    value;
              });
            },
          ),
        ],
      ),
    );
  }
}