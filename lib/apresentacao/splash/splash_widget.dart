// lib/apresentacao/splash/splash_widget.dart
// Widget de splash / carregamento com opção de tela de erro e retry.
// Correção: construtor redirecionador não usa `super.key` diretamente.
// Salve este arquivo no caminho acima e ajuste imports se necessário.

import 'package:flutter/material.dart';
import '../../compartilhado/tema_basetec.dart';

class SplashWidget extends StatelessWidget {
  final String? mensagem;
  final String? detalhe;
  final VoidCallback? onRetry;

  /// Construtor principal (gerador) — pode usar `super.key`.
  const SplashWidget({super.key, this.mensagem, this.detalhe, this.onRetry});

  /// Construtor redirecionador corrigido:
  /// recebe `Key? key` e repassa para o construtor principal.
  const SplashWidget.error({
    Key? key,
    required String mensagem,
    String? detalhe,
    required VoidCallback onRetry,
  }) : this(key: key, mensagem: mensagem, detalhe: detalhe, onRetry: onRetry);

  @override
  Widget build(BuildContext context) {
    // Se onRetry for fornecido, exibimos uma tela com botão de retry e detalhes do erro.
    if (onRetry != null) {
      return Scaffold(
        backgroundColor: TemaBaseTec.temaClaro.scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mensagem ?? 'Erro',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                if (detalhe != null) ...[
                  const SizedBox(height: 8),
                  Text(detalhe!, style: const TextStyle(color: Colors.white70)),
                ],
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Caso contrário, mostramos um indicador de carregamento simples.
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
