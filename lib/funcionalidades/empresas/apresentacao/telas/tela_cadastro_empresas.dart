import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controle/cadastro_empresa_controller.dart';

import '../widgets/cadastro_empresa_header.dart';
import '../widgets/cadastro_empresa_dados_empresa.dart';
import '../widgets/cadastro_empresa_endereco.dart';
import '../widgets/cadastro_empresa_responsavel.dart';
import '../widgets/cadastro_empresa_plano.dart';
import '../widgets/cadastro_empresa_resumo.dart';
import '../widgets/cadastro_empresa_actions.dart';

import '../../../../compartilhado/tema_cores.dart';

class TelaCadastroEmpresa extends StatelessWidget {
  const TelaCadastroEmpresa({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CadastroEmpresaController(),
      child: const _TelaCadastroEmpresaBody(),
    );
  }
}

class _TelaCadastroEmpresaBody extends StatefulWidget {
  const _TelaCadastroEmpresaBody();

  @override
  State<_TelaCadastroEmpresaBody> createState() =>
      _TelaCadastroEmpresaBodyState();
}

class _TelaCadastroEmpresaBodyState
    extends State<_TelaCadastroEmpresaBody> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _criarConta(CadastroEmpresaController controller) async {
    final ok = await controller.criarConta(_formKey);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Empresa cadastrada com sucesso!'),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.errorMessage ?? 'Erro ao criar empresa',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final controller = context.watch<CadastroEmpresaController>();

    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppCores.navbar,
        title: const Text(
          'Cadastro de Empresa',
          style: TextStyle(
            color: AppCores.textoBranco,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: AppCores.gradienteFundo,
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
                vertical: 24,
              ),

              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1200,
                ),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// HEADER
                      const CadastroEmpresaHeader(),

                      const SizedBox(height: 20),

                      /// DADOS EMPRESA
                      const CadastroEmpresaDadosEmpresa(),

                      const SizedBox(height: 20),

                      /// ENDEREÇO
                      const CadastroEmpresaEndereco(),

                      const SizedBox(height: 20),

                      /// RESPONSÁVEL
                      const CadastroEmpresaResponsavel(),

                      const SizedBox(height: 20),

                      /// PLANO
                      const CadastroEmpresaPlano(),

                      const SizedBox(height: 20),

                      /// RESUMO
                      CadastroEmpresaResumo(
                        planoSelecionado:
                            controller.planoSelecionado,
                      ),

                      const SizedBox(height: 20),

                      /// ACTIONS
                      CadastroEmpresaActions(
                        loading: controller.isLoading,
                        onCancelar: () => Navigator.pop(context),
                        onSalvar: () => _criarConta(controller),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}