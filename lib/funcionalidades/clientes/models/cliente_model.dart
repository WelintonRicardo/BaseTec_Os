class ClienteModel {
  final String? id;

  final String empresaId;

  final String nome;

  final String? telefone;

  final String? cep;

  final String? estado;

  final String? cidade;

  final String? bairro;

  final String? rua;

  final String? numero;

  final String? complemento;

  ClienteModel({
    this.id,
    required this.empresaId,
    required this.nome,
    this.telefone,
    this.cep,
    this.estado,
    this.cidade,
    this.bairro,
    this.rua,
    this.numero,
    this.complemento,
  });

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'],
      empresaId: map['empresa_id'] ?? '',
      nome: map['nome_segurado'] ?? '',
      telefone: map['telefone'],
      cep: map['cep'],
      estado: map['estado'],
      cidade: map['cidade'],
      bairro: map['bairro'],
      rua: map['rua'],
      numero: map['numero'],
      complemento: map['complemento'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'empresa_id': empresaId,
      'nome_segurado': nome,
      'telefone': telefone,
      'cep': cep,
      'estado': estado,
      'cidade': cidade,
      'bairro': bairro,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
    };
  }
}