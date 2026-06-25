import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Controle e Telas
import '../../controle/login_cubit.dart';
import '../widgets/input_login_widget.dart';
import '../../../empresas/apresentacao/telas/tela_cadastro_empresas.dart';

// Compartilhado
import '../../../../compartilhado/tema_cores.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();

    super.dispose();
  }

  Widget _buildSafeImage(String path, {double? maxWidth}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha email e senha')));

      return;
    }

    context.read<LoginCubit>().logar(email, senha);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 1100;

    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            print('DEBUG LOGIN: LoginLoading');
          } else if (state is LoginSuccess) {
            print('DEBUG LOGIN: LoginSuccess');

            print('DEBUG LOGIN: NÃO VAMOS NAVEGAR MANUALMENTE');
            print('DEBUG LOGIN: AuthGate vai redirecionar');
          } else if (state is LoginError) {
            print('DEBUG LOGIN: LoginError');
            print('DEBUG LOGIN: Mensagem -> ${state.mensagem}');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.mensagem),
                backgroundColor: AppCores.cancelado,
              ),
            );
          }
        },

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: isMobile ? _buildMobileLayout(size) : _buildWebLayout(size),
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSafeImage(
                'assets/images/logo_basetec_full.png',
                maxWidth: 350,
              ),

              const SizedBox(height: 40),

              _buildFeatureItem(
                Icons.assignment_outlined,
                "Gestão de OS",
                "Organize e acompanhe ordens de serviço.",
              ),

              _buildFeatureItem(
                Icons.check_circle_outline,
                "Checklists Online",
                "Padronização e relatórios automáticos.",
              ),

              _buildFeatureItem(
                Icons.account_balance_wallet_outlined,
                "Financeiro",
                "Indicadores e receitas em tempo real.",
              ),

              const SizedBox(height: 30),

              _buildSafeImage('assets/images/van_basetec.png', maxWidth: 450),
            ],
          ),
        ),

        const SizedBox(width: 60),

        Expanded(flex: 4, child: Center(child: _buildLoginCard(false, size))),
      ],
    );
  }

  Widget _buildMobileLayout(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSafeImage(
          'assets/images/logo_basetec_simples.png',
          maxWidth: size.width * 0.4,
        ),

        const SizedBox(height: 30),

        _buildLoginCard(true, size),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppCores.primaria, size: 28),

          const SizedBox(width: 15),

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                Text(
                  desc,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(bool isMobile, Size size) {
    return Container(
      width: isMobile ? double.infinity : 420,

      padding: const EdgeInsets.all(40),

      decoration: BoxDecoration(
        color: AppCores.cardEscuro.withOpacity(0.8),

        borderRadius: BorderRadius.circular(25),

        border: Border.all(color: AppCores.bordaEscura),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bem-vindo de volta! 👋",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          InputLoginWidget(
            label: "E-mail",
            icon: Icons.person_outline,
            controller: _emailController,
          ),

          const SizedBox(height: 20),

          InputLoginWidget(
            label: "Senha",
            icon: Icons.lock_outline,
            isPassword: true,
            controller: _senhaController,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Esqueceu a senha?",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),

          const SizedBox(height: 20),

          _buildLoginButton(),

          const SizedBox(height: 25),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Não tem uma conta?",
                  style: TextStyle(color: Colors.white60),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaCadastroEmpresa(),
                      ),
                    );
                  },

                  child: const Text(
                    "Criar Conta",
                    style: TextStyle(
                      color: AppCores.primaria,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: 55,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),

            gradient: const LinearGradient(
              colors: [Color(0xFF007BFF), Color(0xFF0056b3)],
            ),
          ),

          child: ElevatedButton(
            onPressed: state is LoginLoading ? null : _fazerLogin,

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            child: state is LoginLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Entrar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
