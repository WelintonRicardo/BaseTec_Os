import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controle/cadastro_cubit.dart';
import '../../../autenticacao/apresentacao/widgets/input_login_widget.dart';
import '../../../../compartilhado/tema_cores.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  // Inicialização explícita de todos os controllers
  final TextEditingController _nomeEmpresaController = TextEditingController();
  final TextEditingController _documentoController = TextEditingController(); 
  final TextEditingController _responsavelController = TextEditingController(); 
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    _nomeEmpresaController.dispose();
    _documentoController.dispose();
    _responsavelController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _processarCadastro(BuildContext context) {
    // Pegamos os valores primeiro para garantir que nenhum seja nulo na leitura
    final String nomeEmpresa = _nomeEmpresaController.text.trim();
    final String documento = _documentoController.text.trim();
    final String responsavel = _responsavelController.text.trim();
    final String telefone = _telefoneController.text.trim();
    final String email = _emailController.text.trim();
    final String senha = _senhaController.text.trim();
    final String confirma = _confirmarSenhaController.text.trim();

    if (senha != confirma) {
      _exibirErro(context, "As senhas não coincidem!");
      return;
    }

    if (nomeEmpresa.isEmpty || documento.isEmpty || responsavel.isEmpty || email.isEmpty || senha.isEmpty) {
      _exibirErro(context, "Preencha todos os campos obrigatórios.");
      return;
    }

    // Chama o Cubit com os valores já extraídos e validados
    context.read<CadastroCubit>().cadastrarGestor(
      email: email,
      senha: senha,
      nomeEmpresa: nomeEmpresa,
      documento: documento,
      responsavel: responsavel,
      telefone: telefone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppCores.textoBranco),
      ),
      body: BlocProvider(
        create: (context) => CadastroCubit(),
        child: BlocConsumer<CadastroCubit, CadastroState>(
          listener: (context, state) {
            if (state is CadastroSuccess) {
              _exibirSucesso(context);
            } else if (state is CadastroError) {
              _exibirErro(context, state.mensagem);
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  decoration: BoxDecoration(
                    color: AppCores.cardEscuro,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppCores.bordaEscura),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogo(),
                      _buildCabecalho(),
                      const SizedBox(height: 30),
                      InputLoginWidget(label: "Nome da Empresa", icon: Icons.business, controller: _nomeEmpresaController),
                      const SizedBox(height: 15),
                      InputLoginWidget(label: "CNPJ ou CPF", icon: Icons.badge, controller: _documentoController),
                      const SizedBox(height: 15),
                      InputLoginWidget(label: "Nome do Responsável", icon: Icons.person, controller: _responsavelController),
                      const SizedBox(height: 15),
                      InputLoginWidget(label: "Telefone", icon: Icons.phone, controller: _telefoneController),
                      const SizedBox(height: 15),
                      InputLoginWidget(label: "E-mail Administrativo", icon: Icons.email, controller: _emailController),
                      const SizedBox(height: 15),
                      InputLoginWidget(label: "Senha de Acesso", icon: Icons.lock, isPassword: true, controller: _senhaController),
                      const SizedBox(height: 15),
                      InputLoginWidget(label: "Confirmar Senha", icon: Icons.lock_reset, isPassword: true, controller: _confirmarSenhaController),
                      const SizedBox(height: 35),
                      _buildBotaoCriar(state, context),
                      const SizedBox(height: 15),
                      _buildBotaoVoltar(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Image.asset(
        'assets/images/logo_basetec_simples.png',
        height: 100,
        errorBuilder: (context, e, s) => const Icon(Icons.business, color: AppCores.primaria, size: 80),
      ),
    );
  }

  Widget _buildCabecalho() {
    return const Column(
      children: [
        Text("Seja um Gestor 🚀", style: TextStyle(color: AppCores.textoBranco, fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text("Crie sua conta empresarial agora.", style: TextStyle(color: AppCores.textoCinza, fontSize: 13), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildBotaoCriar(CadastroState state, BuildContext context) {
    final isLoading = state is CadastroLoading;
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(colors: [Color(0xFF007BFF), Color(0xFF0056b3)]),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _processarCadastro(context),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        child: isLoading 
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Text("Finalizar Cadastro", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildBotaoVoltar() => TextButton(onPressed: () => Navigator.pop(context), child: const Text("Voltar para o Login", style: TextStyle(color: AppCores.textoCinza)));

  void _exibirSucesso(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cadastrado com sucesso!"), backgroundColor: AppCores.concluido));
    Navigator.pop(context);
  }

  void _exibirErro(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppCores.cancelado));
  }
}
