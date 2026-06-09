// lib/arquitetura/app_bootstrap.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../servicos/auth_service.dart';
import '../servicos/error_handler.dart';
import '../apresentacao/splash/splash_widget.dart';
import '../compartilhado/tema_basetec.dart';
import '../funcionalidades/autenticacao/apresentacao/telas/tela_login.dart';
import '../funcionalidades/adm/apresentacao/telas/tela_admin.dart';
import '../funcionalidades/tecnico/apresentacao/telas/tela_tecnico.dart';
import '../funcionalidades/ordens_servico/apresentacao/telas/tela_lista_os.dart';

class AppBootstrap {
  // ⚠️ Ajuste aqui: use a URL e a chave do projeto Supabase já existente
  // (o mesmo que você criou para autenticação e OS).
  static const _supabaseUrl = 'https://keskfeosicebeewcowwg.supabase.co';
  static const _supabaseAnonKey = 'sb_publishable_F2yTofVcEluyHOrq9zYRwA_eAqrMKKq';

  /// Inicializações que podem falhar: encapsuladas e tratadas pelo ErrorHandler.
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: _supabaseAnonKey,
      );
      // outros inits (analytics, crashlytics) aqui se necessário
    } catch (e, st) {
      ErrorHandler.logError('Erro ao inicializar SDKs', e, st);
      rethrow;
    }
  }

  /// Constrói o MaterialApp. Mantemos a decisão de rota inicial em um FutureBuilder
  /// dentro do app para permitir retry e exibir splash/erro.
  static Widget buildApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BaseTec OS',
      theme: TemaBaseTec.temaClaro,
      home: const _InitialRouter(),
    );
  }
}

/// Widget que decide a tela inicial com tratamento de timeout/erros.
class _InitialRouter extends StatefulWidget {
  const _InitialRouter({super.key});
  @override
  State<_InitialRouter> createState() => _InitialRouterState();
}

class _InitialRouterState extends State<_InitialRouter> {
  late Future<String?> _roleFuture;

  @override
  void initState() {
    super.initState();
    _roleFuture = _fetchRoleWithTimeout();
  }

  Future<String?> _fetchRoleWithTimeout() {
    return AuthService.getUserRole().timeout(
      const Duration(seconds: 6),
      onTimeout: () {
        ErrorHandler.log('Timeout ao buscar role do usuário');
        return Future.value(null);
      },
    );
  }

  void _retry() {
    setState(() => _roleFuture = _fetchRoleWithTimeout());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _roleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashWidget();
        }

        if (snapshot.hasError) {
          return SplashWidget.error(
            mensagem: 'Erro ao inicializar o app',
            detalhe: snapshot.error.toString(),
            onRetry: _retry,
          );
        }

        final role = snapshot.data;
        final user = Supabase.instance.client.auth.currentUser;

        if (user == null) return const TelaLogin();
        if (role == 'admin' || role == 'gestor') return const TelaAdmin();
        if (role == 'tecnico') return const TelaTecnico();
        return const TelaListaOS();
      },
    );
  }
}
