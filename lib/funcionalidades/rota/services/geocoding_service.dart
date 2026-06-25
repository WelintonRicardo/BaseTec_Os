import 'dart:convert';

import 'package:http/http.dart' as http;

class GeocodingResult {
  final double latitude;
  final double longitude;

  const GeocodingResult({required this.latitude, required this.longitude});
}

class GeocodingService {
  final String apiKey;

  GeocodingService({required this.apiKey});

  Future<GeocodingResult?> buscarCoordenadas({
    required String rua,
    required String numero,
    required String cidade,
    required String estado,
    String? cep,
  }) async {
    try {
      final endereco = [
        rua,
        numero,
        cidade,
        estado,
        cep,
        'Brasil',
      ].where((e) => e != null && e.trim().isNotEmpty).join(', ');

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?address=${Uri.encodeComponent(endereco)}'
        '&key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body);

      if (data['status'] != 'OK') {
        return null;
      }

      final location = data['results'][0]['geometry']['location'];

      return GeocodingResult(
        latitude: (location['lat'] as num).toDouble(),
        longitude: (location['lng'] as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}
