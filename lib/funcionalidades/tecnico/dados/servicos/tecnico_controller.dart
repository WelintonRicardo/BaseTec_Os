import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../compartilhado/regras/regras_acesso.dart';
import '../../../../compartilhado/config/app_secrets.dart';
import '../../../rota/services/geocoding_service.dart';


class TecnicoController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);
  final ValueNotifier<bool> success = ValueNotifier(false);
  

  // =========================
  // VALIDAÇÕES
  // =========================

  String? validateRequired(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Email obrigatório';
    }

    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!regex.hasMatch(v.trim())) {
      return 'Email inválido';
    }

    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) {
      return 'Senha obrigatória';
    }

    if (v.length < 6) {
      return 'Senha deve ter ao menos 6 caracteres';
    }

    return null;
  }

  // =========================
  // CADASTRO TÉCNICO
  // =========================

  Future<void> cadastrarTecnico({
    required String nome,
    required String email,
    required String senha,
    required String cpfRg,
    String? telefone,
    String? cidade,
    String? estado,
    String? rua,
    String? numero,
    String? complemento,
  }) async {
    // VALIDAÇÕES
    final emailErr = validateEmail(email);

    if (emailErr != null) {
      error.value = emailErr;
      return;
    }

    final passErr = validatePassword(senha);

    if (passErr != null) {
      error.value = passErr;
      return;
    }

    if (validateRequired(nome) != null) {
      error.value = 'Nome obrigatório';
      return;
    }

    if (validateRequired(cpfRg) != null) {
      error.value = 'CPF/RG obrigatório';
      return;
    }

    loading.value = true;
    error.value = null;
    success.value = false;

    try {
      // =================================
      // USUÁRIO LOGADO (GESTOR)
      // =================================

      final gestor = _supabase.auth.currentUser;

      if (gestor == null) {
        throw Exception("Gestor não autenticado.");
      }

      // =================================
      // BUSCAR EMPRESA DO GESTOR
      // =================================

      final user = _supabase.auth.currentUser;

      if (user == null) {
        error.value = "Usuário não autenticado.";
        loading.value = false;
        return;
      }

      final perfil = await _supabase
          .from('perfis')
          .select('empresa_id')
          .eq('id', user.id)
          .maybeSingle();

      if (perfil == null) {
        error.value = "Perfil do gestor não encontrado.";
        loading.value = false;
        return;
      }

      final empresaId = perfil['empresa_id'];
      // =================================
      // GEOCODING RESIDÊNCIA
      // =================================

      double? latitudeResidencia;
      double? longitudeResidencia;

      if ((rua ?? '').isNotEmpty &&
          (numero ?? '').isNotEmpty &&
          (cidade ?? '').isNotEmpty &&
          (estado ?? '').isNotEmpty) {
        final geo = await GeocodingService(apiKey: AppSecrets.googleMapsApiKey)
            .buscarCoordenadas(
              rua: rua!,
              numero: numero!,
              cidade: cidade!,
              estado: estado!,
            );

        latitudeResidencia = geo?.latitude;
        longitudeResidencia = geo?.longitude;

        debugPrint(
          'RESIDENCIA TECNICO -> '
          '$latitudeResidencia , $longitudeResidencia',
        );
      }
      // =================================
      // CRIAR USUÁRIO AUTH DO TÉCNICO
      // =================================

      final authRes = await _supabase.auth.signUp(
        email: email,
        password: senha,
      );

      final tecnicoUser = authRes.user;

      if (tecnicoUser == null) {
        throw Exception("Não foi possível criar usuário do técnico.");
      }

      // =================================
      // CRIAR TÉCNICO
      // =================================

      await _supabase.from('tecnicos').insert({
        'user_id': tecnicoUser.id,

        'nome': nome,
        'email': email,
        'cpf_rg': cpfRg,
        'telefone': telefone,

        'cidade': cidade,
        'rua': rua,
        'numero': numero,
        'complemento': complemento,

        'latitude_residencia': latitudeResidencia,
        'longitude_residencia': longitudeResidencia,

        'empresa_id': empresaId,

        'acesso': NivelAcesso.tecnico.name.toUpperCase(),
      });

      success.value = true;
    } catch (e) {
      error.value = "Erro ao cadastrar técnico: $e";
    } finally {
      loading.value = false;
    }
  }

  Future<void> atualizarCoordenadasWelinton() async {
    debugPrint('INICIOU ATUALIZAR COORDENADAS');

    final geo = await GeocodingService(apiKey: AppSecrets.googleMapsApiKey)
        .buscarCoordenadas(
          rua: 'petronio portela',
          numero: '27',
          cidade: 'Franco da Rocha',
          estado: 'SP',
        );

    if (geo == null) {
      debugPrint('Não foi possível localizar endereço');
      return;
    }

    debugPrint('LAT: ${geo.latitude}');
    debugPrint('LNG: ${geo.longitude}');

    await _supabase
        .from('tecnicos')
        .update({
          'latitude_residencia': geo.latitude,
          'longitude_residencia': geo.longitude,
        })
        .eq('id', '9eb689e4-5f74-4c9a-8e11-1d915cfb1bc8');
  }

  // =========================
  // LOGIN
  // =========================

  Future<void> loginTecnico({
    required String email,
    required String senha,
  }) async {
    loading.value = true;
    error.value = null;

    

    try {
      await _supabase.auth.signInWithPassword(email: email, password: senha);

      success.value = true;
    } catch (e) {
      error.value = "Erro ao fazer login: $e";
    } finally {
      loading.value = false;
    }
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  void dispose() {
    loading.dispose();
    error.dispose();
    success.dispose();
  }

}
