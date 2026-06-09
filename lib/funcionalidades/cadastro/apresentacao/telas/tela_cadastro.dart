import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controle/cadastro_os_controller.dart';

import 'cadastro_os/layouts/cadastro_os_mobile.dart';
import 'cadastro_os/layouts/cadastro_os_desktop.dart';

import 'cadastro_os/widgets/cadastro_os_header.dart';
import 'cadastro_os/widgets/cadastro_os_actions.dart';

import '../../../../compartilhado/tema_cores.dart';

class TelaCadastroOS extends StatelessWidget {
  const TelaCadastroOS({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CadastroOsController(),
      child: const _TelaCadastroOSBody(),
    );
  }
}

class _TelaCadastroOSBody extends StatefulWidget {
  const _TelaCadastroOSBody();

  @override
  State<_TelaCadastroOSBody> createState() =>
      _TelaCadastroOSBodyState();
}

class _TelaCadastroOSBodyState
    extends State<_TelaCadastroOSBody> {

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  Future<void> _salvar(
    CadastroOsController controller,
  ) async {

    final ok = await controller.enviar(
      _formKey,
    );

    if (!mounted) return;

    if (ok) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'OS cadastrada com sucesso!',
          ),
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.errorMessage ??
                'Erro ao cadastrar OS',
          ),
          backgroundColor: AppCores.cancelado,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final controller =
        context.watch<CadastroOsController>();

    final mobile =
        MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppCores.cardEscuro,

        title: const Text(
          'Cadastro de Ordem de Serviço',
          style: TextStyle(
            color: AppCores.textoBranco,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(

            padding: EdgeInsets.symmetric(
              horizontal: mobile ? 16 : 28,
              vertical: 24,
            ),

            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1400,
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  children: [

                    const CadastroOSHeader(),

                    const SizedBox(height: 24),

                    mobile
                        ? CadastroOSMobile(
                            controller: controller,
                          )
                        : CadastroOSDesktop(
                            controller: controller,
                          ),

                    const SizedBox(height: 32),

                    CadastroOSActions(
                      loading: controller.isLoading,

                      onCancelar: () {
                        Navigator.pop(context);
                      },

                      onSalvar: () async {
                        await _salvar(controller);
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