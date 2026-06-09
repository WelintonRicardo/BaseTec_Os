// lib/funcionalidades/cadastro/controle/cadastro_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../compartilhado/regras/regras_acesso.dart';

abstract class CadastroState {}

class CadastroInitial extends CadastroState {}

class CadastroLoading extends CadastroState {}

class CadastroSuccess extends CadastroState {}

class CadastroError extends CadastroState {
  final String mensagem;

  CadastroError(this.mensagem);
}

class CadastroCubit extends Cubit<CadastroState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  CadastroCubit() : super(CadastroInitial());

  Future<void> cadastrarGestor({
    required String email,
    required String senha,
    required String nomeEmpresa,
    required String documento,
    required String responsavel,
    required String telefone,
  }) async {
    emit(CadastroLoading());

    try {
      // =========================================
      // 1. CRIAR USUÁRIO AUTH
      // =========================================
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: senha,
      );

      final user = res.user;

      if (user == null) {
        emit(
          CadastroError(
            "Não foi possível criar o usuário.",
          ),
        );
        return;
      }

      // =========================================
      // 2. CRIAR EMPRESA
      // =========================================
      final empresaInsert =
          await _supabase
              .from('empresas')
              .insert({
                'nome': nomeEmpresa,
                'documento': documento,
                'responsavel': responsavel,
                'telefone': telefone,
                'email': email,
              })
              .select()
              .single();

      final String empresaId = empresaInsert['id'].toString();

      // DEBUG
   

      // =========================================
      // 3. CRIAR PERFIL GESTOR
      // =========================================
      await _supabase.from('perfis').insert({
        'id': user.id,
        'nome': responsavel,
        'email': email,
        'telefone': telefone,
        'acesso': 'GESTOR',
        'empresa_id': empresaId,
      });



      emit(CadastroSuccess());
    } on AuthException catch (e) {
      emit(
        CadastroError(
          "Erro de autenticação: ${e.message}",
        ),
      );
    } catch (e) {
      print("ERRO NO CADASTRO: $e");

      emit(
        CadastroError(
          "Erro no banco: ${e.toString()}",
        ),
      );
    }
  }
}