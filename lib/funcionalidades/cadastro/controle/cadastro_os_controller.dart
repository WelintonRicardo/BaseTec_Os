// lib/funcionalidades/cadastro/controle/cadastro_os_controller.dart

import 'package:flutter/material.dart';
import '../dominio/cadastro_os_model.dart';
import '../regras/service_rules.dart';

/// Controller para Cadastro de OS
/// - Mantém TextEditingControllers expostos para a UI
/// - Aplica regras de negócio (via ServiceRules) ao alterar tipoServico
/// - Valida, monta modelo e simula envio (substituir TODO pelo repositório real)
class CadastroOsController extends ChangeNotifier {
  // Text controllers
  final TextEditingController osController = TextEditingController();
  final TextEditingController seguradoraController = TextEditingController();
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController servicoController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();

  final TextEditingController infoAdicionaisController = TextEditingController();
  final TextEditingController valorMaoObraController = TextEditingController();
  final TextEditingController valorDeslocamentoController = TextEditingController();
  final TextEditingController valorPecasController = TextEditingController();

  // Seleções e horários
  String? _tipoServico;
  DateTime? dataAgendamento; // data base para início/fim
  TimeOfDay? horaInicio;
  TimeOfDay? horaFim;
  String? tecnicoSelecionado;

  // Estado
  bool isLoading = false;
  String? errorMessage;

  // Getter/Setter para tipoServico com aplicação de regras centralizadas
  String? get tipoServico => _tipoServico;

  set tipoServico(String? value) {
    _tipoServico = value;

    // Aplica regras centralizadas quando o tipo muda (ex: Emergencial)
    ServiceRules.applyOnTipoChange(
      tipo: value,
      nowProvider: () => DateTime.now(),
      onApply: (data, hInicio, hFim) {
        // Define dataAgendamento como a data de 'data' (preserva dia)
        dataAgendamento = DateTime(data.year, data.month, data.day);
        horaInicio = hInicio;
        horaFim = hFim;
      },
    );

    notifyListeners();
  }

  // Validações
  String? validarObrigatorio(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
    return null;
  }

  // Parse decimal (aceita vírgula ou ponto)
  double? parseDecimal(String? s) {
    if (s == null) return null;
    final t = s.trim();
    if (t.isEmpty) return null;
    final normalized = t.replaceAll(',', '.').replaceAll(' ', '');
    try {
      return double.parse(normalized);
    } catch (_) {
      return null;
    }
  }

  // Monta DateTime de início/fim a partir de dataAgendamento + TimeOfDay
  DateTime? montarAgendamentoInicio() {
    if (dataAgendamento == null || horaInicio == null) return null;
    return DateTime(
      dataAgendamento!.year,
      dataAgendamento!.month,
      dataAgendamento!.day,
      horaInicio!.hour,
      horaInicio!.minute,
    );
  }

  DateTime? montarAgendamentoFim() {
    if (dataAgendamento == null || horaFim == null) return null;
    return DateTime(
      dataAgendamento!.year,
      dataAgendamento!.month,
      dataAgendamento!.day,
      horaFim!.hour,
      horaFim!.minute,
    );
  }

  // Valida o formulário (recebe GlobalKey<FormState> da UI)
  bool validarFormulario(GlobalKey<FormState> formKey) {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return false;

    if (tipoServico == null) {
      errorMessage = 'Selecione o tipo de serviço.';
      notifyListeners();
      return false;
    }
    if (montarAgendamentoInicio() == null) {
      errorMessage = 'Selecione data e horário de início.';
      notifyListeners();
      return false;
    }
    // hora fim é opcional, mas se preenchido deve ser >= inicio
    final inicio = montarAgendamentoInicio();
    final fim = montarAgendamentoFim();
    if (fim != null && inicio != null && fim.isBefore(inicio)) {
      errorMessage = 'Horário fim deve ser igual ou posterior ao início.';
      notifyListeners();
      return false;
    }
    if (tecnicoSelecionado == null) {
      errorMessage = 'Selecione o técnico responsável.';
      notifyListeners();
      return false;
    }

    // valida campos numéricos se preenchidos
    if (valorMaoObraController.text.trim().isNotEmpty && parseDecimal(valorMaoObraController.text) == null) {
      errorMessage = 'Valor mão de obra inválido.';
      notifyListeners();
      return false;
    }
    if (valorDeslocamentoController.text.trim().isNotEmpty && parseDecimal(valorDeslocamentoController.text) == null) {
      errorMessage = 'Valor deslocamento inválido.';
      notifyListeners();
      return false;
    }
    if (valorPecasController.text.trim().isNotEmpty && parseDecimal(valorPecasController.text) == null) {
      errorMessage = 'Valor peças inválido.';
      notifyListeners();
      return false;
    }

    errorMessage = null;
    notifyListeners();
    return true;
  }

  // Monta o modelo a partir dos controllers e seleções
  CadastroOsModel montarModelo() {
    return CadastroOsModel(
      os: osController.text,
      seguradora: seguradoraController.text,
      cliente: clienteController.text,
      servico: servicoController.text.isEmpty ? null : servicoController.text,
      tipoServico: tipoServico,
      cep: cepController.text,
      cidade: cidadeController.text,
      rua: ruaController.text,
      numero: numeroController.text,
      complemento: complementoController.text.isEmpty ? null : complementoController.text,
      agendamentoInicio: montarAgendamentoInicio(),
      agendamentoFim: montarAgendamentoFim(),
      tecnico: tecnicoSelecionado,
      informacoesAdicionais: infoAdicionaisController.text.isEmpty ? null : infoAdicionaisController.text,
      valorMaoObra: parseDecimal(valorMaoObraController.text),
      valorDeslocamentoKm: parseDecimal(valorDeslocamentoController.text),
      valorPecas: parseDecimal(valorPecasController.text),
    );
  }

  // Envio (simulado) — substituir pelo repositório real
  Future<bool> enviar(GlobalKey<FormState> formKey) async {
    if (!validarFormulario(formKey)) return false;
    final modelo = montarModelo();

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // TODO: substituir pelo repositório real (ex: cadastroOsRepository.criar(modelo.toMap()))
      await Future.delayed(const Duration(seconds: 1)); // simula envio
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Erro ao enviar: $e';
      notifyListeners();
      return false;
    }
  }

  // Limpa todos os campos e estado
  void limpar() {
    osController.clear();
    seguradoraController.clear();
    clienteController.clear();
    servicoController.clear();
    cepController.clear();
    cidadeController.clear();
    ruaController.clear();
    numeroController.clear();
    complementoController.clear();
    infoAdicionaisController.clear();
    valorMaoObraController.clear();
    valorDeslocamentoController.clear();
    valorPecasController.clear();

    _tipoServico = null;
    dataAgendamento = null;
    horaInicio = null;
    horaFim = null;
    tecnicoSelecionado = null;

    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    osController.dispose();
    seguradoraController.dispose();
    clienteController.dispose();
    servicoController.dispose();
    cepController.dispose();
    cidadeController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    infoAdicionaisController.dispose();
    valorMaoObraController.dispose();
    valorDeslocamentoController.dispose();
    valorPecasController.dispose();
    super.dispose();
  }
}
