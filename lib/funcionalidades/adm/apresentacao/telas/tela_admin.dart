// lib/funcionalidades/dashboard/apresentacao/telas/tela_admin.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../dashboard/apresentacao/widgets/painel_resumo_widget.dart';
import '../../../../compartilhado/tema_cores.dart';
import '../../../../compartilhado/utils/responsive_layout.dart';

import 'package:basetec_os/funcionalidades/cadastro/apresentacao/telas/cadastro_os/tela_cadastro_os.dart';

import '../../dados/repositorios/admin_repository.dart';
import '../../../tecnico/dados/repositorios/tecnico_repository.dart';
import '../../../../compartilhado/dados/supabase_notifier.dart';
import '../widgets/admin_search_bar_widget.dart';

// ✅ novos widgets separados
import '../../../adm/apresentacao/widgets/appbar_acoes.dart';
import '../../../adm/apresentacao/widgets/calendario_br.dart';
import '../../../adm/apresentacao/widgets/lista_tecnicos.dart';
import '../../../adm/apresentacao/widgets/lista_os_dia.dart';

class TelaAdmin extends StatefulWidget {
  const TelaAdmin({super.key});

  @override
  State<TelaAdmin> createState() => _TelaAdminState();
}

class _TelaAdminState extends State<TelaAdmin> {
  final AdminRepository _adminRepo = AdminRepository();
  final TecnicoRepository _tecnicoRepo = TecnicoRepository();
  final SupabaseNotifier _notifier = SupabaseNotifier();

  List<Map<String, dynamic>> _usuarios = [];
  List<Map<String, dynamic>> _tecnicos = [];
  List<Map<String, dynamic>> _ordensServico = [];

  String? _empresaId;
  DateTime _dataSelecionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _carregarEmpresaId();
    _escutarMudancas();
  }

  //=========================================@override
  ///Métodos de carregamento e escuta
  //==========================================
  Future<void> _carregarEmpresaId() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final res = await Supabase.instance.client
        .from('perfis')
        .select('empresa_id')
        .eq('id', user.id)
        .maybeSingle();

    if (res != null && res['empresa_id'] != null) {
      setState(() {
        _empresaId = res['empresa_id'].toString();
      });
    }

    if (_empresaId != null) {
      await _carregarDados();
    }
  }

  Future<void> _carregarDados() async {
    try {
      final usuarios = await _adminRepo.listarUsuarios();
      final tecnicos = await _tecnicoRepo.listarTecnicos();

      final os = await Supabase.instance.client
          .from('ordens_servico')
          .select('''
                *,
                execucoes_os (
                  id,
                  checklist,
                  observacoes,
                  observacao_final,
                  status_final,
                  inicio_execucao,
                  fim_execucao
                )
              ''')
          .eq('empresa_id', _empresaId!)
          .order('numero_assistencia', ascending: false);

      // calcular estatísticas dos técnicos
      for (var tecnico in tecnicos) {
        final tecnicoId = tecnico['id'].toString();
        final osDoTecnico = os.where((item) {
          return item['tecnico_id']?.toString() == tecnicoId;
        }).toList();

        final concluidas = osDoTecnico.where((item) {
          final status = item['status']?.toString().toLowerCase();
          return status == 'concluido';
        }).length;

        tecnico['total_os_mes'] = osDoTecnico.length;
        tecnico['concluidas'] = concluidas;
      }

      setState(() {
        _usuarios = usuarios;
        _tecnicos = tecnicos;
        _ordensServico = List<Map<String, dynamic>>.from(os);
      });
    } catch (e, s) {
      debugPrint("ERRO: $e");
      debugPrint(s.toString());
    }
  }

  void _escutarMudancas() {
    _notifier.onProfilesChange().listen((dados) {
      if (dados['empresa_id'] == _empresaId) {
        _carregarDados();
      }
    });

    _notifier.onOrdensServicoChange().listen((dados) {
      if (dados['empresa_id'] == _empresaId) {
        _carregarDados();
      }
    });
  }

  //===========================================================@override
  //Build da tela (Scaffold + Layouts)
  //============================================================@override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,
      appBar: AppBar(
        backgroundColor: AppCores.cardEscuro,
        title: const AdminSearchBarWidget(),
        actions: buildAppBarActions(context), // ✅ agora vem do arquivo separado
      ),
      body: ResponsiveLayout(
        builder: (context, size, w, h, isMobile, isTablet, isDesktop) {
          if (isMobile) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(w * 4),
              child: Column(
                children: [
                  buildCalendarioBR(
                    selectedDay: _dataSelecionada,
                    onDaySelected: (date) {
                      setState(() => _dataSelecionada = date);
                    },
                  ),
                  SizedBox(height: h * 2),
                  buildListaTecnicos(_tecnicos),
                  SizedBox(height: h * 2),
                  PainelResumoWidget(
                    usuarios: _usuarios,
                    ordensServico: _ordensServico,
                  ),
                  SizedBox(height: h * 2),
                  buildListaOSDia(_ordensServico, _dataSelecionada),
                ],
              ),
            );
          }

          if (isTablet) {
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(w * 3),
                    child: Column(
                      children: [
                        buildCalendarioBR(
                          selectedDay: _dataSelecionada,
                          onDaySelected: (date) {
                            setState(() => _dataSelecionada = date);
                          },
                        ),
                        SizedBox(height: h * 2),
                        buildListaTecnicos(_tecnicos),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.all(w * 3),
                    child: Column(
                      children: [
                        PainelResumoWidget(
                          usuarios: _usuarios,
                          ordensServico: _ordensServico,
                        ),
                        SizedBox(height: h * 2),
                        buildListaOSDia(_ordensServico, _dataSelecionada),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          ;
          //======================================================================
          //=========Layout Desktop + FAB===================================context
          //=======================================================================
          // DESKTOP
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(w * 2.5),
                  child: Column(
                    children: [
                      buildCalendarioBR(
                        selectedDay: _dataSelecionada,
                        onDaySelected: (date) {
                          setState(() => _dataSelecionada = date);
                        },
                      ),
                      SizedBox(height: h * 2),
                      buildListaTecnicos(_tecnicos),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.all(w * 2.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PainelResumoWidget(
                        usuarios: _usuarios,
                        ordensServico: _ordensServico,
                      ),
                      SizedBox(height: h * 3),
                      const Text(
                        "Ordens de Serviço do Dia",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: h * 2),
                      Expanded(
                        child: buildListaOSDia(
                          _ordensServico,
                          _dataSelecionada,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TelaCadastroOS()),
          );
        },
        backgroundColor: AppCores.primaria,
        icon: const Icon(Icons.add),
        label: const Text("Nova O.S"),
      ),
    );
  }
}
