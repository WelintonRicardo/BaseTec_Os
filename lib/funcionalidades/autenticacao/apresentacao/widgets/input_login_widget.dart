import 'package:flutter/material.dart';

class InputLoginWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;

  const InputLoginWidget({
    super.key, required this.label, required this.icon, 
    this.isPassword = false, required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
