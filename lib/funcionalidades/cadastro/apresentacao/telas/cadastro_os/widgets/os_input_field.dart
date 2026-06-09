// lib/funcionalidades/cadastro/apresentacao/telas/cadastro_os/widgets/os_input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../compartilhado/tema_cores.dart';

class OsInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscure;
  final bool optional;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const OsInputField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscure = false,
    this.optional = false,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        color: AppCores.textoBranco,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: optional ? '$label (Opcional)' : label,
        hintText: hint,
        hintStyle: TextStyle(
          color: AppCores.textoCinza.withOpacity(0.5),
        ),
        labelStyle: TextStyle(
          color: AppCores.textoCinza.withOpacity(0.9),
        ),
        filled: true,
        fillColor: AppCores.cardEscuro.withOpacity(0.75),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppCores.bordaEscura,
            width: 1.2,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppCores.primaria,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppCores.cancelado,
            width: 1.5,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppCores.cancelado,
            width: 2,
          ),
        ),
      ),
    );
  }
}