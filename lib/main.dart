import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'funcionalidades/ordens_servico/controle/controle_os_cubit.dart';
import 'funcionalidades/ordens_servico/apresentacao/tela_lista_os.dart';
import 'compartilhado/tema_basetec.dart';


void main() {
  runApp(const BaseTecApp());
}

class BaseTecApp extends StatelessWidget {
  const BaseTecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ControleOSCubit()..escutarOrdens('TECNICO_ID_TESTE', 'EMPRESA_ID_TESTE'),
        ),
      ],
      child: MaterialApp(
        title: 'BaseTec OS',
        theme: TemaBaseTec.temaClaro,
        home: const TelaListaOS(),
      ),
    );
  }
}
