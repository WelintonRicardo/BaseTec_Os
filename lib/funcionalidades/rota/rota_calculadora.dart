import 'dart:convert';
import 'package:http/http.dart' as http;

class RotaCalculadora {
  final String enderecoTecnico;
  final String enderecoRetorno;
  final String localizacaoAtual;
  final String googleApiKey;

  RotaCalculadora({
    required this.enderecoTecnico,
    required this.enderecoRetorno,
    required this.localizacaoAtual,
    required this.googleApiKey,
  });

  /// OS:
  /// {
  ///   'titulo': '',
  ///   'endereco': '',
  ///   'lat': '',
  ///   'lng': '',
  ///   'horario': '',
  /// }

  Future<List<Map<String, dynamic>>> calcularMelhorRota(
    List<Map<String, dynamic>> osList,
  ) async {
    if (osList.isEmpty) return [];

    final restantes = List<Map<String, dynamic>>.from(osList);
    final rota = <Map<String, dynamic>>[];

    String pontoAtual = localizacaoAtual;

    rota.add({
      'tipo': 'inicio',
      'endereco': enderecoTecnico,
      'status': 'inicio',
    });

    // 🧠 algoritmo tipo Uber + trânsito real
    while (restantes.isNotEmpty) {
      final tempos = await _buscarTemposReais(
        origem: pontoAtual,
        destinos: restantes.map((e) => e['endereco'].toString()).toList(),
      );

      // associa tempo com OS
      for (int i = 0; i < restantes.length; i++) {
        restantes[i]['tempo'] = tempos[i];
      }

      // escolhe menor tempo REAL
      restantes.sort((a, b) => a['tempo'].compareTo(b['tempo']));

      final proxima = restantes.removeAt(0);

      rota.add({...proxima, 'status': 'emRota'});

      pontoAtual = proxima['endereco'];
    }

    rota.add({
      'tipo': 'retorno',
      'endereco': enderecoRetorno,
      'status': 'retorno',
    });

    return rota;
  }

  /// 🌍 GOOGLE DISTANCE MATRIX (TRÂNSITO REAL)
  Future<List<int>> _buscarTemposReais({
    required String origem,
    required List<String> destinos,
  }) async {
    final destinosFormatados = destinos.join('|');

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json'
      '?origins=$origem'
      '&destinations=$destinosFormatados'
      '&departure_time=now'
      '&traffic_model=best_guess'
      '&mode=driving'
      '&key=$googleApiKey',
    );

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    final rows = data['rows'][0]['elements'];

    return rows.map<int>((e) {
      return e['duration_in_traffic']?['value'] ?? e['duration']['value'];
    }).toList();
  }
}
