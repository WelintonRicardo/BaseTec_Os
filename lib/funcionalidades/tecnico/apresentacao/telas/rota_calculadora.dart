import 'dart:math';

class RotaCalculadora {
  final String enderecoTecnico;
  final String enderecoRetorno;
  final String localizacaoAtual;

  RotaCalculadora({
    required this.enderecoTecnico,
    required this.enderecoRetorno,
    required this.localizacaoAtual,
  });

  /// Estrutura da OS:
  /// {
  ///   'titulo': 'OS #1 - Cliente X',
  ///   'endereco': 'Rua Exemplo 123',
  ///   'horario': 'Manhã' ou 'Tarde'
  /// }
  List<Map<String, dynamic>> calcularMelhorRota(
      List<Map<String, dynamic>> osList) {
    if (osList.isEmpty) return [];

    // 1. Separar OS por período (manhã/tarde)
    final manha = osList.where((os) => os['horario'] == 'Manhã').toList();
    final tarde = osList.where((os) => os['horario'] == 'Tarde').toList();

    // 2. Ordenar cada grupo por "distância simulada"
    // ⚠️ Aqui usamos um mock de distância aleatória.
    // Depois vamos integrar com API de mapas (Google Maps, Mapbox).
    manha.sort((a, b) => _distanciaMock(a['endereco'])
        .compareTo(_distanciaMock(b['endereco'])));
    tarde.sort((a, b) => _distanciaMock(a['endereco'])
        .compareTo(_distanciaMock(b['endereco'])));

    // 3. Construir rota: manhã → tarde → retorno
    final rota = [
      {'ponto': 'Início', 'endereco': enderecoTecnico},
      ...manha,
      ...tarde,
      {'ponto': 'Retorno', 'endereco': enderecoRetorno},
    ];

    return rota;
  }

  /// Mock de cálculo de distância
  int _distanciaMock(String endereco) {
    // gera um número aleatório só para simular
    return Random().nextInt(50); // km
  }
}
