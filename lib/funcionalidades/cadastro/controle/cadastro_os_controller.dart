// lib/funcionalidades/cadastro/controle/cadastro_os_controller.dart
//
// Controller responsável pelo cadastro de Ordem de Serviço.
//
// Funções:
// - Gerenciar estado da tela
// - Validar formulário
// - Buscar técnicos no Supabase
// - Buscar clientes da empresa
// - Buscar endereço via CEP
// - Salvar clientes automaticamente
// - Montar modelo da OS
// - Enviar OS
// - Notificar UI automaticamente
//
// Estrutura preparada para crescimento SaaS multiempresa.

import 'dart:convert';
import '../../../compartilhado/config/app_secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dominio/cadastro_os_model.dart';
import '../regras/service_rules.dart';
import '../../clientes/regras/cliente_sync_rule.dart';

import '../../clientes/models/cliente_model.dart';
import '../../clientes/services/cliente_service.dart';
import '../../rota/services/geocoding_service.dart';

class CadastroOsController extends ChangeNotifier {
  // =========================================================
  // SUPABASE
  // =========================================================

  final SupabaseClient _client = Supabase.instance.client;

  // =========================================================
  // LISTA DE TÉCNICOS
  // =========================================================

  List<Map<String, dynamic>> tecnicos = [];

  // =========================================================
  // CONTROLLERS
  // =========================================================

  final TextEditingController osController = TextEditingController();

  final TextEditingController seguradoraController = TextEditingController();

  final TextEditingController clienteController = TextEditingController();

  final TextEditingController telefoneController = TextEditingController();

  final TextEditingController servicoController = TextEditingController();

  final TextEditingController cepController = TextEditingController();

  final TextEditingController estadoController = TextEditingController();

  final TextEditingController cidadeController = TextEditingController();

  final TextEditingController bairroController = TextEditingController();

  final TextEditingController ruaController = TextEditingController();

  final TextEditingController numeroController = TextEditingController();

  final TextEditingController complementoController = TextEditingController();

  final TextEditingController infoAdicionaisController =
      TextEditingController();

  final TextEditingController valorMaoObraController = TextEditingController();

  final TextEditingController valorDeslocamentoController =
      TextEditingController();

  final TextEditingController valorPecasController = TextEditingController();

  // =========================================================
  // CAMPOS DE ESTADO
  // =========================================================

  String? _tipoServico;

  DateTime? dataAgendamento;

  TimeOfDay? horaInicio;

  TimeOfDay? horaFim;

  String? tecnicoSelecionado;

  bool isLoading = false;

  String? errorMessage;

  // =========================================================
  // CONSTRUTOR
  // =========================================================

  CadastroOsController() {
    carregarTecnicos();
  }

  // =========================================================
  // CARREGAR TÉCNICOS
  // =========================================================

  Future<void> carregarTecnicos() async {
    try {
      final response = await _client
          .from('tecnicos')
          .select('id, nome')
          .order('nome');

      tecnicos = List<Map<String, dynamic>>.from(response);

      notifyListeners();
    } catch (e) {
      debugPrint('ERRO AO CARREGAR TECNICOS: $e');
    }
  }

  // =========================================================
  // BUSCAR CLIENTES DA EMPRESA
  // =========================================================

  Future<List<Map<String, dynamic>>> buscarClientes(String nome) async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        return [];
      }

      final perfil = await _client
          .from('perfis')
          .select('empresa_id')
          .eq('id', user.id)
          .single();

      final empresaId = perfil['empresa_id'];

      final response = await _client
          .from('clientes')
          .select()
          .eq('empresa_id', empresaId)
          .ilike('nome_segurado', '%$nome%')
          .limit(10);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('ERRO AO BUSCAR CLIENTES: $e');

      return [];
    }
  }

  // =========================================================
  // PREENCHER CLIENTE AUTOMATICAMENTE
  // =========================================================

  void preencherCliente(Map<String, dynamic> cliente) {
    clienteController.text = cliente['nome_segurado'] ?? '';

    telefoneController.text = cliente['telefone'] ?? '';

    cepController.text = cliente['cep'] ?? '';

    estadoController.text = cliente['estado'] ?? '';

    cidadeController.text = cliente['cidade'] ?? '';

    bairroController.text = cliente['bairro'] ?? '';

    ruaController.text = cliente['rua'] ?? '';

    numeroController.text = cliente['numero'] ?? '';

    complementoController.text = cliente['complemento'] ?? '';

    notifyListeners();
  }

  // =========================================================
  // BUSCAR CEP AUTOMATICAMENTE
  // =========================================================

  Future<void> buscarCep() async {
    final cep = cepController.text.replaceAll('-', '').trim();

    if (cep.length != 8) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cep/json/'),
      );

      final data = jsonDecode(response.body);

      if (data['erro'] == true) {
        return;
      }

      ruaController.text = data['logradouro'] ?? '';

      bairroController.text = data['bairro'] ?? '';

      cidadeController.text = data['localidade'] ?? '';

      estadoController.text = data['uf'] ?? '';

      notifyListeners();
    } catch (e) {
      debugPrint('ERRO AO BUSCAR CEP: $e');
    }
  }

  // =========================================================
  // TIPO DE SERVIÇO
  // =========================================================

  String? get tipoServico => _tipoServico;

  set tipoServico(String? value) {
    _tipoServico = value;

    ServiceRules.applyOnTipoChange(
      tipo: value,

      nowProvider: () => DateTime.now(),

      onApply: (data, hInicio, hFim) {
        dataAgendamento = DateTime(data.year, data.month, data.day);

        horaInicio = hInicio;

        horaFim = hFim;
      },
    );

    notifyListeners();
  }

  // =========================================================
  // VALIDAÇÕES
  // =========================================================

  String? validarObrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  // =========================================================
  // PARSE DECIMAL
  // =========================================================

  double? parseDecimal(String? valor) {
    if (valor == null) {
      return null;
    }

    final texto = valor.trim().replaceAll(',', '.').replaceAll(' ', '');

    if (texto.isEmpty) {
      return null;
    }

    try {
      return double.parse(texto);
    } catch (_) {
      return null;
    }
  }

  // =========================================================
  // MONTAR DATETIME
  // =========================================================

  DateTime? montarAgendamentoInicio() {
    if (dataAgendamento == null || horaInicio == null) {
      return null;
    }

    return DateTime(
      dataAgendamento!.year,
      dataAgendamento!.month,
      dataAgendamento!.day,
      horaInicio!.hour,
      horaInicio!.minute,
    );
  }

  DateTime? montarAgendamentoFim() {
    if (dataAgendamento == null || horaFim == null) {
      return null;
    }

    return DateTime(
      dataAgendamento!.year,
      dataAgendamento!.month,
      dataAgendamento!.day,
      horaFim!.hour,
      horaFim!.minute,
    );
  }

  // =========================================================
  // VALIDAR FORMULÁRIO
  // =========================================================

  bool validarFormulario(GlobalKey<FormState> formKey) {
    final valido = formKey.currentState?.validate() ?? false;

    if (!valido) {
      return false;
    }

    if (tipoServico == null) {
      errorMessage = 'Selecione o tipo de serviço';

      notifyListeners();

      return false;
    }

    if (montarAgendamentoInicio() == null) {
      errorMessage = 'Selecione data e horário';

      notifyListeners();

      return false;
    }

    final inicio = montarAgendamentoInicio();

    final fim = montarAgendamentoFim();

    if (inicio != null && fim != null && fim.isBefore(inicio)) {
      errorMessage = 'Hora final inválida';

      notifyListeners();

      return false;
    }

    if (tecnicoSelecionado == null || tecnicoSelecionado!.isEmpty) {
      errorMessage = 'Selecione um técnico';

      notifyListeners();

      return false;
    }

    errorMessage = null;

    notifyListeners();

    return true;
  }

  // =========================================================
  // MONTAR MODELO
  // =========================================================

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

      complemento: complementoController.text.isEmpty
          ? null
          : complementoController.text,

      agendamentoInicio: montarAgendamentoInicio(),

      agendamentoFim: montarAgendamentoFim(),

      tecnico: tecnicoSelecionado,

      informacoesAdicionais: infoAdicionaisController.text.isEmpty
          ? null
          : infoAdicionaisController.text,

      valorMaoObra: parseDecimal(valorMaoObraController.text),

      valorDeslocamentoKm: parseDecimal(valorDeslocamentoController.text),

      valorPecas: parseDecimal(valorPecasController.text),
    );
  }

  // =========================================================
  // ENVIAR OS
  // =========================================================

  Future<bool> enviar(GlobalKey<FormState> formKey) async {
    if (!validarFormulario(formKey)) {
      return false;
    }

    isLoading = true;

    errorMessage = null;

    notifyListeners();

    try {
      final supabase = Supabase.instance.client;

      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // =====================================================
      // EMPRESA
      // =====================================================

      final perfil = await supabase
          .from('perfis')
          .select('empresa_id')
          .eq('id', user.id)
          .maybeSingle();

      final empresaId = perfil?['empresa_id'];

      if (empresaId == null) {
        throw Exception('empresa_id não encontrado');
      }

      // =====================================================
      // TÉCNICO
      // =====================================================

      final tecnico = tecnicos.firstWhere(
        (t) => t['nome'] == tecnicoSelecionado,
        orElse: () => {},
      );

      final tecnicoId = tecnico['id'];

      if (tecnicoId == null) {
        throw Exception('Técnico inválido');
      }

      // =====================================================
      // SALVAR / ATUALIZAR CLIENTE
      // =====================================================

      final clienteService = ClienteService();

      final geo = await GeocodingService(apiKey: AppSecrets.googleMapsApiKey)
          .buscarCoordenadas(
            rua: ruaController.text,
            numero: numeroController.text,
            cidade: cidadeController.text,
            estado: estadoController.text,
            cep: cepController.text,
          );


      final cliente = ClienteModel(
        empresaId: empresaId,

        nome: clienteController.text,

        telefone: telefoneController.text,

        cep: cepController.text,

        estado: estadoController.text,

        cidade: cidadeController.text,

        bairro: bairroController.text,

        rua: ruaController.text,

        numero: numeroController.text,

        complemento: complementoController.text,
      );

      await clienteService.sincronizarCliente(cliente);

      // =====================================================
      // DADOS DA OS
      // =====================================================

      final dados = {
        'empresa_id': empresaId,

        'numero_os': osController.text.trim(),

        // CLIENTE
        'nome_segurado': clienteController.text.trim(),

        'telefone': telefoneController.text.trim(),

        // SEGURADORA
        'seguradora': seguradoraController.text.trim(),

        // SERVIÇO
        'descricao_servico': servicoController.text.trim(),

        'tipo_servico': tipoServico,

        // ENDEREÇO
        'cep': cepController.text.trim(),

        'estado': estadoController.text.trim(),

        'cidade': cidadeController.text.trim(),

        'bairro': bairroController.text.trim(),

        'rua': ruaController.text.trim(),

        'numero': numeroController.text.trim(),

        'complemento': complementoController.text.trim(),

        // TÉCNICO
        'tecnico_id': tecnicoId,

        // INFORMAÇÕES
        'informacoes_adicionais': infoAdicionaisController.text.trim(),

        // VALORES
        'valor_mao_obra': parseDecimal(valorMaoObraController.text),

        'valor_deslocamento': parseDecimal(valorDeslocamentoController.text),

        'valor_pecas': parseDecimal(valorPecasController.text),

        // AGENDAMENTO
        'janela_inicio_agendada': montarAgendamentoInicio()?.toIso8601String(),

        'janela_fim_agendada': montarAgendamentoFim()?.toIso8601String(),

        'latitude_local': geo?.latitude,
        'longitude_local': geo?.longitude,

        // STATUS
        'status': 'pendente',
      };

      // =====================================================
      // SALVAR OS
      // =====================================================

      final osCriada = await supabase
          .from('ordens_servico')
          .insert(dados)
          .select()
          .single();

      final osId = osCriada['id'] as int;

      // =====================================================
      // GERAR ROTA AUTOMÁTICA
      // =====================================================

      // usa a data do agendamento
      final dataRota = dataAgendamento == null
          ? DateTime.now()
          : DateTime(
              dataAgendamento!.year,
              dataAgendamento!.month,
              dataAgendamento!.day,
            );

      // busca a última posição da rota
      final ultimaRota = await supabase
          .from('rotas')
          .select('ordem_rota')
          .eq('tecnico_id', tecnicoId)
          .eq('data_rota', dataRota.toIso8601String().split('T')[0])
          .order('ordem_rota', ascending: false)
          .limit(1);

      int proximaOrdem = 1;

      if (ultimaRota.isNotEmpty) {
        proximaOrdem = (ultimaRota.first['ordem_rota'] ?? 0) + 1;
      }

      // cria o registro da rota
      await supabase.from('rotas').insert({
        'tecnico_id': tecnicoId,
        'os_id': osId,
        'data_rota': dataRota.toIso8601String().split('T')[0],
        'ordem_rota': proximaOrdem,
        'ordem_original': proximaOrdem,
        'otimizada': false,
      });

      // atualiza a OS com a posição da rota
      await supabase
          .from('ordens_servico')
          .update({'ordem_rota': proximaOrdem})
          .eq('id', osId);

      isLoading = false;

      notifyListeners();

      return true;
    } catch (e) {
      isLoading = false;

      errorMessage = 'Erro ao salvar OS: $e';

      notifyListeners();

      return false;
    }
  }

  // =========================================================
  // LIMPAR FORMULÁRIO
  // =========================================================

  void limpar() {
    osController.clear();

    seguradoraController.clear();

    clienteController.clear();

    telefoneController.clear();

    servicoController.clear();

    cepController.clear();

    estadoController.clear();

    cidadeController.clear();

    bairroController.clear();

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

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    osController.dispose();

    seguradoraController.dispose();

    clienteController.dispose();

    telefoneController.dispose();

    servicoController.dispose();

    cepController.dispose();

    estadoController.dispose();

    cidadeController.dispose();

    bairroController.dispose();

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
