import 'package:flutter/material.dart';
import '../../../../../compartilhado/tema_cores.dart';

class BotaoCadastroTecnico extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const BotaoCadastroTecnico({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,

      child: ElevatedButton(
        onPressed: loading ? null : onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.primaria,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        child: loading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                "Cadastrar Técnico",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
