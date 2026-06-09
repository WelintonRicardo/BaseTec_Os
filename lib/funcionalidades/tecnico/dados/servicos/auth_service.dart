import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signUpTecnico({
    required String email,
    required String senha,
    required Map<String, dynamic> profileData,
  }) async {
    final res = await _client.auth.signUp(email: email, password: senha);

    final userId = res.user?.id;
    if (userId == null) {
      throw Exception('Usuário não criado');
    }

    await _client.from('perfis').insert({
      'id': userId,
      ...profileData,
      'role': 'tecnico',
    });

    return res;
  }

  Future<AuthResponse> login({
    required String email,
    required String senha,
  }) async {
    return await _client.auth.signInWithPassword(email: email, password: senha);
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
}
