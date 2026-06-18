import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class AdminSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const AdminSearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      constraints: const BoxConstraints(
        maxWidth: 650,
      ),
      decoration: BoxDecoration(
        color: AppCores.cardEscuro,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppCores.bordaEscura,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),

          const Icon(
            Icons.search_rounded,
            color: AppCores.primaria,
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                color: AppCores.textoBranco,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText:
                    'Buscar segurado, telefone ou número da OS...',
                hintStyle: TextStyle(
                  color: AppCores.textoCinza,
                ),
              ),
            ),
          ),

          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                tooltip: 'Limpar',
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppCores.textoCinza,
                ),
              );
            },
          ),

          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppCores.primaria.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              tooltip: 'Filtros',
              onPressed: () {},
              icon: const Icon(
                Icons.tune_rounded,
                color: AppCores.primaria,
              ),
            ),
          ),
        ],
      ),
    );
  }
}