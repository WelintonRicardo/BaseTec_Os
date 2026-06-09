import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

class InputLoginWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;

  const InputLoginWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppCores.cardEscuro.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(
          color: AppCores.textoBranco,
          fontSize: larguraTela < 600 ? 14 : 16,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppCores.primaria,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppCores.textoCinza.withOpacity(0.8),
            fontSize: larguraTela < 600 ? 13 : 15,
          ),
          prefixIcon: Icon(icon, color: AppCores.primaria),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppCores.bordaEscura, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppCores.primaria, width: 1.8),
          ),
        ),
      ),
    );
  }
}
