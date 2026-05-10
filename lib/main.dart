import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'funcionalidades/ordens_servico/controle/controle_os_cubit.dart';
import 'funcionalidades/ordens_servico/apresentacao/tela_lista_os.dart';
import 'compartilhado/tema_basetec.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // AJUSTE NA URL: Removido o "/rest/v1/" do final
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ControleOSCubit()
            ..escutarOrdens(
              'TECNICO_TESTE_01', 
              'f52fe913-5a03-4c27-9509-2bbff81aa63a',
            ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BaseTec OS',
        theme: TemaBaseTec.temaClaro,
        home: const TelaListaOS(),
      ),
    );
  }
}
