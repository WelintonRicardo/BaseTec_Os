import 'package:flutter/material.dart';

import '../../dados/servicos/tecnico_controller.dart';

import '../widgets/cadastro_tecnico/header_tecnico_widget.dart';
import '../widgets/cadastro_tecnico/card_secao_widget.dart';
import '../widgets/cadastro_tecnico/campo_tecnico_widget.dart';
import '../widgets/cadastro_tecnico/botao_cadastro_tecnico.dart';
import '../widgets/cadastro_tecnico/mensagem_erro_widget.dart';
import '../widgets/cadastro_tecnico/mensagem_sucesso_widget.dart';

import '../../../../compartilhado/tema_cores.dart';

class TelaCadastroTecnico extends StatefulWidget {
  final TecnicoController controller;

  const TelaCadastroTecnico({
    super.key,
    required this.controller,
  });

  @override
  State<TelaCadastroTecnico> createState() =>
      _TelaCadastroTecnicoState();
}

class _TelaCadastroTecnicoState
    extends State<TelaCadastroTecnico> {
  final _formKey = GlobalKey<FormState>();

  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();
  final cidadeCtrl = TextEditingController();
  final ruaCtrl = TextEditingController();
  final numeroCtrl = TextEditingController();
  final complementoCtrl = TextEditingController();

  @override
  void dispose() {
    nomeCtrl.dispose();
    emailCtrl.dispose();
    senhaCtrl.dispose();
    cpfCtrl.dispose();
    telefoneCtrl.dispose();
    cidadeCtrl.dispose();
    ruaCtrl.dispose();
    numeroCtrl.dispose();
    complementoCtrl.dispose();

    widget.controller.dispose();

    super.dispose();
  }

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      widget.controller.cadastrarTecnico(
        nome: nomeCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        senha: senhaCtrl.text.trim(),
        cpfRg: cpfCtrl.text.trim(),
        telefone: telefoneCtrl.text.trim(),
        cidade: cidadeCtrl.text.trim(),
        rua: ruaCtrl.text.trim(),
        numero: numeroCtrl.text.trim(),
        complemento: complementoCtrl.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppCores.cardEscuro,
        title: const Text(
          'Cadastro de Técnico',
          style: TextStyle(
            color: AppCores.textoBranco,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppCores.fundoEscuro,
              AppCores.cardEscuro.withOpacity(0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: largura < 700 ? 18 : 32,
              vertical: 24,
            ),

            child: Container(
              constraints: const BoxConstraints(maxWidth: 780),

              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                color: AppCores.cardEscuro.withOpacity(0.96),

                borderRadius: BorderRadius.circular(28),

                border: Border.all(
                  color: AppCores.bordaEscura,
                ),
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const HeaderTecnicoWidget(),

                    const SizedBox(height: 32),

                    CardSecaoWidget(
                      titulo: "Dados Pessoais",
                      children: [
                        CampoTecnicoWidget(
                          label: "Nome Completo",
                          icon: Icons.person_outline,
                          controller: nomeCtrl,
                          validator: widget
                              .controller
                              .validateRequired,
                        ),

                        const SizedBox(height: 18),

                        CampoTecnicoWidget(
                          label: "CPF / RG",
                          icon: Icons.badge_outlined,
                          controller: cpfCtrl,
                          validator: widget
                              .controller
                              .validateRequired,
                        ),

                        const SizedBox(height: 18),

                        CampoTecnicoWidget(
                          label: "Telefone",
                          icon: Icons.phone_outlined,
                          controller: telefoneCtrl,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    CardSecaoWidget(
                      titulo: "Dados de Acesso",
                      children: [
                        CampoTecnicoWidget(
                          label: "Email",
                          icon: Icons.email_outlined,
                          controller: emailCtrl,
                          validator:
                              widget.controller.validateEmail,
                        ),

                        const SizedBox(height: 18),

                        CampoTecnicoWidget(
                          label: "Senha",
                          icon: Icons.lock_outline,
                          controller: senhaCtrl,
                          obscure: true,
                          validator: widget
                              .controller
                              .validatePassword,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    CardSecaoWidget(
                      titulo: "Endereço",
                      children: [
                        CampoTecnicoWidget(
                          label: "Cidade",
                          icon:
                              Icons.location_city_outlined,
                          controller: cidadeCtrl,
                        ),

                        const SizedBox(height: 18),

                        CampoTecnicoWidget(
                          label: "Rua",
                          icon: Icons.map_outlined,
                          controller: ruaCtrl,
                        ),

                        const SizedBox(height: 18),

                        CampoTecnicoWidget(
                          label: "Número",
                          icon: Icons.home_outlined,
                          controller: numeroCtrl,
                        ),

                        const SizedBox(height: 18),

                        CampoTecnicoWidget(
                          label: "Complemento",
                          icon:
                              Icons.add_home_outlined,
                          controller: complementoCtrl,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    ValueListenableBuilder<bool>(
                      valueListenable:
                          widget.controller.loading,
                      builder: (context, loading, _) {
                        return BotaoCadastroTecnico(
                          loading: loading,
                          onPressed: _cadastrar,
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    ValueListenableBuilder<String?>(
                      valueListenable:
                          widget.controller.error,
                      builder: (context, error, _) {
                        if (error == null) {
                          return const SizedBox.shrink();
                        }

                        return MensagemErroWidget(
                          mensagem: error,
                        );
                      },
                    ),

                    ValueListenableBuilder<bool>(
                      valueListenable:
                          widget.controller.success,
                      builder: (context, success, _) {
                        if (!success) {
                          return const SizedBox.shrink();
                        }

                        return const MensagemSucessoWidget();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}