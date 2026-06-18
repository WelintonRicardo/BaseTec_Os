// lib/funcionalidades/dashboard/apresentacao/telas/tela_admin.dart
import 'dart:async';
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

import 'package:flutter/services.dart';
import '../../../../compartilhado/pdf/servicos/servico_compartilhamento_os.dart';

class TelaAdmin extends StatefulWidget {
  const TelaAdmin({super.key});

  @override
  State<TelaAdmin> createState() => _TelaAdminState();
}

class _TelaAdminState extends State<TelaAdmin> {
  final AdminRepository _adminRepo = AdminRepository();
  final TecnicoRepository _tecnicoRepo = TecnicoRepository();
  final SupabaseNotifier _notifier = SupabaseNotifier();

  final TextEditingController _buscaController = TextEditingController();

  List<Map<String, dynamic>> _ordensServicoOriginal = [];

  StreamSubscription? _osSubscription;
  StreamSubscription? _perfilSubscription;
  StreamSubscription? _execucaoSubscription;

  bool _disposed = false;

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

        int concluidas = 0;
        int pendentes = 0;
        int aguardandoPeca = 0;
        int clienteAusente = 0;

        for (final ordem in osDoTecnico) {
          final status = (ordem['status'] ?? '')
              .toString()
              .trim()
              .toLowerCase();

          switch (status) {
            case 'concluido':
            case 'concluida':
              concluidas++;
              break;

            case 'pendente':
              pendentes++;
              break;

            case 'aguardando_peca':
              aguardandoPeca++;
              break;

            case 'cliente ausente':
              clienteAusente++;
              break;
          }
        }

        tecnico['concluidas'] = concluidas;
        tecnico['pendentes'] = pendentes;
        tecnico['aguardando_peca'] = aguardandoPeca;
        tecnico['cliente_ausente'] = clienteAusente;

        tecnico['total_os_mes'] =
            concluidas + pendentes + aguardandoPeca + clienteAusente;
      }

      if (!mounted || _disposed) {
        return;
      }

      setState(() {
        _usuarios = usuarios;
        _tecnicos = tecnicos;

        _ordensServicoOriginal = List<Map<String, dynamic>>.from(os);

        _ordensServico = List<Map<String, dynamic>>.from(os);
      });
    } catch (e, s) {
      debugPrint("ERRO: $e");
      debugPrint(s.toString());
    }
  }

  void _escutarMudancas() {
    _perfilSubscription = _notifier.onProfilesChange().listen(
      _processarEventoRealtime,
    );

    _osSubscription = _notifier.onOrdensServicoChange().listen(
      _processarEventoRealtime,
    );

    _execucaoSubscription = _notifier.onExecucoesOSChange().listen(
      _processarEventoRealtime,
    );
  }

  Future<void> _processarEventoRealtime(Map<String, dynamic> dados) async {
    if (_empresaId == null) {
      return;
    }

    final novo = dados['new'] as Map<String, dynamic>? ?? {};

    final antigo = dados['old'] as Map<String, dynamic>? ?? {};

    final empresaEvento = novo['empresa_id'] ?? antigo['empresa_id'];

    if (empresaEvento == null) {
      return;
    }

    if (empresaEvento.toString() != _empresaId) {
      return;
    }

    debugPrint('Realtime recebido: ${dados['event']}');

    await _carregarDados();
  }

  // COMPARTILHAR PDF
  void compartilharOS(int osId) async {
    try {
      final servico = ServicoCompartilhamentoOS();

      final link = await ServicoCompartilhamentoOS().obterOuCriarLink(osId);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Compartilhar OS"),
            content: SelectableText(link),
            actions: [
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: link));
                },
                child: const Text("Copiar link"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fechar"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao gerar link de compartilhamento")),
      );
    }
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
        title: AdminSearchBarWidget(
          controller: _buscaController,
          onChanged: _filtrarOrdensServico,
        ),
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
          return SingleChildScrollView(
            padding: EdgeInsets.all(w * 2.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI
                PainelResumoWidget(
                  usuarios: _usuarios,
                  ordensServico: _ordensServico,
                ),

                SizedBox(height: h * 3),

                // CALENDÁRIO + TÉCNICOS
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: buildCalendarioBR(
                        selectedDay: _dataSelecionada,
                        onDaySelected: (date) {
                          setState(() => _dataSelecionada = date);
                        },
                      ),
                    ),

                    SizedBox(width: w * 2),

                    Expanded(flex: 6, child: buildListaTecnicos(_tecnicos)),
                  ],
                ),

                SizedBox(height: h * 3),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppCores.cardEscuro,
                        AppCores.cardEscuro.withOpacity(0.85),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppCores.primaria.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.assignment_rounded,
                            color: AppCores.primaria,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Ordens de Serviço do Dia",
                            style: TextStyle(
                              color: AppCores.textoBranco,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 2),

                      buildListaOSDia(_ordensServico, _dataSelecionada),
                    ],
                  ),
                ),
              ],
            ),
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

  @override
  void dispose() {
    _disposed = true;

    _osSubscription?.cancel();
    _perfilSubscription?.cancel();
    _execucaoSubscription?.cancel();

    super.dispose();
  }


  

  void _filtrarOrdensServico(String texto) {
  final busca = texto.trim().toLowerCase();

  if (busca.isEmpty) {
    setState(() {
      _ordensServico =
          List<Map<String, dynamic>>.from(
        _ordensServicoOriginal,
      );
    });
    return;
  }

  setState(() {
    _ordensServico =
        _ordensServicoOriginal.where((os) {
      final nomeSegurado =
          (os['nome_segurado'] ?? '')
              .toString()
              .toLowerCase();

      final numeroOs =
          (os['numero_os'] ?? '')
              .toString()
              .toLowerCase();

      final telefone =
          (os['telefone'] ?? '')
              .toString()
              .replaceAll(RegExp(r'[^0-9]'), '');

      final buscaTelefone =
          busca.replaceAll(RegExp(r'[^0-9]'), '');

      final encontrouNome =
          nomeSegurado.contains(busca);

      final encontrouOs =
          numeroOs.contains(busca);

      final encontrouTelefone =
          buscaTelefone.isNotEmpty &&
          telefone.contains(buscaTelefone);

      return encontrouNome ||
          encontrouOs ||
          encontrouTelefone;
    }).toList();
  });
}
}
