import 'package:flutter_bloc/flutter_bloc.dart';
import '../dados/repositorios/auth_repository.dart';

abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {}
class LoginError extends LoginState { final String mensagem; LoginError(this.mensagem); }

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;
  LoginCubit(this._repository) : super(LoginInitial());

  Future<void> logar(String email, String password) async {
    emit(LoginLoading());
    try {
      await _repository.login(email, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError("Erro ao acessar: Verifique suas credenciais"));
    }
  }
}
