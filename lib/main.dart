import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Importante para o Calendário em PT-BR
import 'package:flutter_localizations/flutter_localizations.dart'; 

// Importações de Autenticação e Cadastro
import 'funcionalidades/autenticacao/dados/repositorios/auth_repository.dart';
import 'funcionalidades/autenticacao/controle/login_cubit.dart';
import 'funcionalidades/autenticacao/apresentacao/telas/tela_login.dart';

// Importações de Dashboard e OS
import 'funcionalidades/dashboard/apresentacao/telas/tela_admin.dart';
import 'funcionalidades/ordens_servico/controle/controle_os_cubit.dart';
import 'funcionalidades/ordens_servico/apresentacao/telas/tela_lista_os.dart';

import 'compartilhado/tema_basetec.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do Supabase
  await Supabase.initialize(
    url: 'https://keskfeosicebeewcowwg.supabase.co', 
    anonKey: 'sb_publishable_F2yTofVcEluyHOrq9zYRwA_eAqrMKKq', 
  );

  runApp(const BaseTecApp()); 
}

class BaseTecApp extends StatelessWidget {
  const BaseTecApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final supabase = Supabase.instance.client;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit(authRepository)),
          BlocProvider(create: (context) => ControleOSCubit()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BaseTec OS',
          theme: TemaBaseTec.temaClaro, // Use temaEscuro se preferir o visual dark
          
          // CONFIGURAÇÃO DE LOCALIZAÇÃO (Calendário em Português)
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
          ],

          // Lógica de Roteamento Inicial
          home: supabase.auth.currentSession == null 
              ? const TelaLogin() 
              : const TelaAdmin(), // Se logado, vai para o Dashboard Admin
        ),
      ),
    );
  }
}
  