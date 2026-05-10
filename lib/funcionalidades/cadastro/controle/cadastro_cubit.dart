import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../compartilhado/regras_acesso.dart';

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
      // 1. Criar o usuário no Supabase Auth
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: senha,
      );

      final user = res.user;

      // Se o usuário foi criado (mesmo que precise confirmar e-mail)
      if (user != null) {
        // 2. Tenta salvar os dados na tabela perfis
        try {
          await _supabase.from('perfis').insert({
            'id': user.id,
            'nome': responsavel,
            'nome_empresa': nomeEmpresa,
            'documento': documento,
            'telefone': telefone,
            'acesso': NivelAcesso.gestor.name.toUpperCase(),
            'empresa_id': user.id,
          });
          
          emit(CadastroSuccess());
        } catch (dbError) {
          // Se der erro aqui, é problema de RLS ou Coluna no Banco
          emit(CadastroError("Usuário criado, mas erro ao salvar perfil: $dbError"));
        }
      } else {
        emit(CadastroError("Não foi possível criar o usuário. Tente outro e-mail."));
      }
    } on AuthException catch (e) {
      emit(CadastroError("Erro de Autenticação: ${e.message}"));
      } catch (e) {
      // ESTE PRINT VAI TE MOSTRAR O ERRO REAL NO CONSOLE DO VS CODE
      print("ERRO NO BANCO DE DADOS: $e"); 
      
      // O erro do banco agora aparece no SnackBar para você ler
      emit(CadastroError("Erro no Banco: ${e.toString()}"));
    }
  }
}
