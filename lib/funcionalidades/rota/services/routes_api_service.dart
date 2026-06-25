import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../compartilhado/config/app_secrets.dart';

class RouteInfo {
  final double km;
  final int minutos;

  const RouteInfo({
    required this.km,
    required this.minutos,
  });
}

class RoutesApiService {
  Future<RouteInfo?> calcularRota({
    required double origemLat,
    required double origemLng,
    required double destinoLat,
    required double destinoLng,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://routes.googleapis.com/directions/v2:computeRoutes',
        ),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': AppSecrets.googleMapsApiKey,
          'X-Goog-FieldMask':
              'routes.distanceMeters,routes.duration',
        },
        body: jsonEncode({
          'origin': {
            'location': {
              'latLng': {
                'latitude': origemLat,
                'longitude': origemLng,
              },
            },
          },
          'destination': {
            'location': {
              'latLng': {
                'latitude': destinoLat,
                'longitude': destinoLng,
              },
            },
          },
          'travelMode': 'DRIVE',
        }),
      );

      if (response.statusCode != 200) {
        print('ERRO ROUTES API');
        print(response.body);
        return null;
      }

      final data = jsonDecode(response.body);

      if (data['routes'] == null ||
          (data['routes'] as List).isEmpty) {
        return null;
      }

      final rota = data['routes'][0];

      final distanciaMetros =
          (rota['distanceMeters'] as num).toDouble();

      final durationString =
          rota['duration'].toString();

      final segundos = int.parse(
        durationString.replaceAll('s', ''),
      );

      return RouteInfo(
        km: distanciaMetros / 1000,
        minutos: (segundos / 60).round(),
      );
    } catch (e) {
      print('ERRO ROUTES API: $e');
      return null;
    }
  }
}