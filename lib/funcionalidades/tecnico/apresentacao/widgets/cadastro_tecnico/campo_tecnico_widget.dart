import 'package:flutter/material.dart';
import '../../../../../compartilhado/tema_cores.dart';

class CampoTecnicoWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;
  final String? Function(String?)? validator;

  const CampoTecnicoWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.obscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,

      style: const TextStyle(
        color: AppCores.textoBranco,
      ),

      decoration: InputDecoration(
        hintText: label,

        hintStyle: TextStyle(
          color:
              AppCores.textoCinza.withOpacity(0.7),
        ),

        prefixIcon: Icon(
          icon,
          color: AppCores.primaria,
        ),

        filled: true,
        fillColor:
            AppCores.fundoEscuro.withOpacity(0.35),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppCores.bordaEscura,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppCores.primaria,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}