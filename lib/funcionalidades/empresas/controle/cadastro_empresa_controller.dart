import 'package:flutter/material.dart';

class CadastroEmpresaController extends ChangeNotifier {

  bool isLoading = false;
  String? errorMessage;

  /// plano selecionado no onboarding
  String planoSelecionado = "professional";

  void selecionarPlano(String plano) {
    planoSelecionado = plano;
    notifyListeners();
  }

  Future<bool> criarConta(GlobalKey<FormState> formKey) async {

    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      // aqui depois entra API / Firebase / backend
      return true;

    } catch (e) {
      errorMessage = "Erro ao criar empresa";
      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}