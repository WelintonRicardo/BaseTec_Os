import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'arquitetura/app_bootstrap.dart';

import 'funcionalidades/autenticacao/dados/repositorios/auth_repository.dart';
import 'funcionalidades/autenticacao/controle/login_cubit.dart';

import 'funcionalidades/ordens_servico/controle/controle_os_cubit.dart';

import 'funcionalidades/autenticacao/apresentacao/telas/tela_login.dart';
import 'funcionalidades/adm/apresentacao/telas/tela_admin.dart';
import 'funcionalidades/tecnico/apresentacao/telas/tela_tecnico.dart';

import 'compartilhado/tema/app_theme.dart';
import 'compartilhado/tema/theme_controller.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.initialize();
  runApp(const BaseTecApp());
}

class BaseTecApp extends StatelessWidget {
  const BaseTecApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();

    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {

          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider<AuthRepository>.value(
                value: authRepository,
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider<LoginCubit>(
                  create: (_) => LoginCubit(authRepository),
                ),
                BlocProvider<ControleOSCubit>(
                  create: (_) => ControleOSCubit(),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'BaseTec OS',
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeController.isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('pt', 'BR'),
                ],
                home: const AuthGate(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<Widget> _verificarTela() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
     
      return const TelaLogin();
    }

    try {
    
      final tecnico = await supabase
          .from('tecnicos')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

   

      if (tecnico != null) {
        final acesso = (tecnico['acesso'] ?? '')
            .toString()
            .toUpperCase()
            .trim();

       

        if (acesso == 'TECNICO') {
       
          return const TelaTecnico();
        }
      }


      return const TelaAdmin();
    } catch (e) {
      
      return const TelaLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        return FutureBuilder<Widget>(
          future: _verificarTela(),
          builder: (context, telaSnapshot) {
            if (telaSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (telaSnapshot.hasData) {
              return telaSnapshot.data!;
            }

            return const TelaLogin();
          },
        );
      },
    );
  }
}