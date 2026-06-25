import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    await _atualizarLocalizacaoTecnicoAoLogar();

    return response;
  }

  Future<void> logout() async => await _supabase.auth.signOut();

  Future<void> _atualizarLocalizacaoTecnicoAoLogar() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) return;

      final tecnico = await _supabase
          .from('tecnicos')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (tecnico == null) return;

      final servicoHabilitado = await Geolocator.isLocationServiceEnabled();
      if (!servicoHabilitado) return;

      var permissao = await Geolocator.checkPermission();

      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }

      if (permissao == LocationPermission.denied ||
          permissao == LocationPermission.deniedForever) {
        return;
      }

      final posicao = await Geolocator.getCurrentPosition();

      await _supabase
          .from('tecnicos')
          .update({
            'latitude_residencia': posicao.latitude,
            'longitude_residencia': posicao.longitude,
          })
          .eq('id', tecnico['id']);
    } catch (_) {
      return;
    }
  }
}
