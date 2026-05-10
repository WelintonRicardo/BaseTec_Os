class ChecklistModelo {
  final String? id;
  final String osId;
  final List<PerguntaRespondida> itens;
  final String? nomeRecebedor; // Nome de quem assinou
  final String? assinaturaClienteUrl;
  final String? assinaturaTecnicoUrl;

  ChecklistModelo({
    this.id,
    required this.osId,
    required this.itens,
    this.nomeRecebedor,
    this.assinaturaClienteUrl,
    this.assinaturaTecnicoUrl,
  });

  /// Converte o modelo para JSON para salvar no Supabase
  Map<String, dynamic> toMap() {
    return {
      'os_id': osId,
      'dados': itens.map((e) => e.toMap()).toList(),
      'nome_recebedor': nomeRecebedor,
      'assinatura_cliente': assinaturaClienteUrl,
      'assinatura_tecnico': assinaturaTecnicoUrl,
    };
  }

  /// Cria o modelo a partir de um mapa vindo do banco de dados
  factory ChecklistModelo.fromMap(Map<String, dynamic> mapa) {
    return ChecklistModelo(
      id: mapa['id']?.toString(),
      osId: mapa['os_id']?.toString() ?? '',
      nomeRecebedor: mapa['nome_recebedor']?.toString(),
      assinaturaClienteUrl: mapa['assinatura_cliente']?.toString(),
      assinaturaTecnicoUrl: mapa['assinatura_tecnico']?.toString(),
      itens: (mapa['dados'] as List?)
              ?.map((e) => PerguntaRespondida.fromMap(e))
              .toList() ??
          [],
    );
  }
}

class PerguntaRespondida {
  final String pergunta;
  final String resposta; // "Sim", "Não", "Texto livre"
  final String tipo;     // "checkbox", "texto", "foto"

  PerguntaRespondida({
    required this.pergunta,
    required this.resposta,
    required this.tipo,
  });

  Map<String, dynamic> toMap() => {
        'p': pergunta,
        'r': resposta,
        't': tipo,
      };

  factory PerguntaRespondida.fromMap(Map<String, dynamic> mapa) {
    return PerguntaRespondida(
      pergunta: mapa['p']?.toString() ?? '',
      resposta: mapa['r']?.toString() ?? '',
      tipo: mapa['t']?.toString() ?? 'texto',
    );
  }
}
