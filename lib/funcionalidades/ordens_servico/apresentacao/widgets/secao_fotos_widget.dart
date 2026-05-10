import 'package:flutter/material.dart';

class SecaoFotosWidget extends StatelessWidget {
  final String titulo;
  final List<String> fotos; // URLs ou Caminhos locais
  final VoidCallback aoClicarCapturar;

  const SecaoFotosWidget({
    super.key, 
    required this.titulo, 
    required this.fotos, 
    required this.aoClicarCapturar
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: fotos.length + 1,
            itemBuilder: (context, index) {
              if (index == fotos.length) {
                return GestureDetector(
                  onTap: aoClicarCapturar,
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: const Icon(Icons.add_a_photo, color: Colors.grey),
                  ),
                );
              }
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(image: NetworkImage(fotos[index]), fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
