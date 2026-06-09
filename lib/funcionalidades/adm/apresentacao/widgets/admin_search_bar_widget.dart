import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';

class AdminSearchBarWidget extends StatelessWidget {
  const AdminSearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppCores.cardEscuro,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppCores.bordaEscura,
        ),
      ),
      child: const TextField(
        style: TextStyle(
          color: AppCores.textoBranco,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Buscar O.S ou cliente...",
          hintStyle: TextStyle(
            color: AppCores.textoCinza,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppCores.primaria,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12,
          ),
        ),
      ),
    );
  }
}