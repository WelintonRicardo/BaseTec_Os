// lib/funcionalidades/cadastro/dominio/cadastro_os_model.dart

/// Modelo de dados para Cadastro de OS (atualizado com agendamento inicio/fim)
class CadastroOsModel {
  String os;
  String seguradora;
  String cliente;
  String? servico; // novo campo: descrição do serviço para o técnico
  String? tipoServico;

  // Endereço
  String cep;
  String cidade;
  String rua;
  String numero;
  String? complemento;

  // Agendamento: início e fim (opcionais)
  DateTime? agendamentoInicio;
  DateTime? agendamentoFim;

  // Técnico
  String? tecnico;

  // Complementos e valores
  String? informacoesAdicionais;
  double? valorMaoObra;
  double? valorDeslocamentoKm;
  double? valorPecas;

  CadastroOsModel({
    required this.os,
    required this.seguradora,
    required this.cliente,
    this.servico,
    this.tipoServico,
    required this.cep,
    required this.cidade,
    required this.rua,
    required this.numero,
    this.complemento,
    this.agendamentoInicio,
    this.agendamentoFim,
    this.tecnico,
    this.informacoesAdicionais,
    this.valorMaoObra,
    this.valorDeslocamentoKm,
    this.valorPecas,
  });

  Map<String, dynamic> toMap() {
    return {
      'os': os.trim(),
      'seguradora': seguradora.trim(),
      'cliente': cliente.trim(),
      'servico': servico?.trim(),
      'tipo_servico': tipoServico,
      'endereco': {
        'cep': cep.trim(),
        'cidade': cidade.trim(),
        'rua': rua.trim(),
        'numero': numero.trim(),
        'complemento': complemento?.trim(),
      },
      'agendamento_inicio': agendamentoInicio?.toIso8601String(),
      'agendamento_fim': agendamentoFim?.toIso8601String(),
      'tecnico': tecnico,
      'informacoes_adicionais': informacoesAdicionais?.trim(),
      'valor_mao_obra': valorMaoObra,
      'valor_deslocamento_km': valorDeslocamentoKm,
      'valor_pecas': valorPecas,
    };
  }
}
