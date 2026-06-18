import 'package:flutter/material.dart';

import '../../../../compartilhado/tema_cores.dart';
import '../../dados/repositorios/tecnico_repository.dart';
import 'dart:async';
import '../../../../compartilhado/dados/supabase_notifier.dart';

/// ======================================================
/// CARD SUPERIOR DO PAINEL DO TÉCNICO
/// ======================================================
///
/// Responsável por:
/// - Buscar dados do técnico logado
/// - Buscar estatísticas do mês
/// - Exibir resumo visual
///
/// Dados carregados:
/// - Empresa
/// - Nome do técnico
/// - OS concluídas
/// - Aguardando peça
/// - Retorno garantia
/// - Ausentes
/// - Total do mês
/// ======================================================

class TecnicoHeaderCard extends StatefulWidget {
  const TecnicoHeaderCard({super.key});

  @override
  State<TecnicoHeaderCard> createState() => _TecnicoHeaderCardState();
}

class _TecnicoHeaderCardState extends State<TecnicoHeaderCard> {
  /// Repository responsável
  /// pelas consultas no Supabase
  final TecnicoRepository _repository = TecnicoRepository();
  final SupabaseNotifier notifier = SupabaseNotifier();

  StreamSubscription? _subscription;

  /// Controle de loading
  bool _loading = true;

  /// Dados carregados do dashboard
  Map<String, dynamic> dados = {};

  @override
  void initState() {
    super.initState();

    carregarDados();

    _subscription = notifier.onOrdensServicoChange().listen((_) {
      carregarDados();
    });
  }

  /// ======================================================
  /// CARREGA DADOS DO DASHBOARD
  /// ======================================================
  Future<void> carregarDados() async {
    try {
      final response = await _repository.carregarDashboardTecnico();

      if (!mounted) return;

      setState(() {
        dados = response;

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// ============================================
    /// LOADING
    /// ============================================
    if (_loading) {
      return Container(
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: AppCores.cardEscuro,

          borderRadius: BorderRadius.circular(16),
        ),

        child: const Center(child: CircularProgressIndicator()),
      );
    }

    /// ============================================
    /// DADOS
    /// ============================================
    final empresa = dados['empresa']?.toString() ?? 'Empresa';

    final nomeTecnico = dados['nomeTecnico']?.toString() ?? 'Técnico';

    final concluidos = dados['concluidos'] ?? 0;

    final aguardandoPeca = dados['aguardandoPeca'] ?? 0;

    final pendentes = dados['pendentes'] ?? 0;

    final ausentes = dados['ausentes'] ?? 0;

    final totalMes = dados['totalMes'] ?? 0;

    /// ============================================
    /// CARD PRINCIPAL
    /// ============================================
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppCores.cardEscuro,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppCores.bordaEscura),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// EMPRESA
          Text(
            empresa,

            style: const TextStyle(
              color: AppCores.primaria,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// NOME TÉCNICO
          Text(
            'Olá, $nomeTecnico 👋',

            style: const TextStyle(
              color: AppCores.textoBranco,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          Divider(color: Colors.white.withOpacity(0.1), height: 1),

          const SizedBox(height: 20),

          /// ESTATÍSTICAS
          Wrap(
            spacing: 14,
            runSpacing: 14,

            children: [
              _buildStat('Pendentes', pendentes, AppCores.pendente),

              _buildStat(
                'Aguardando Peça',
                aguardandoPeca,
                AppCores.emAndamento,
              ),

              _buildStat('Cliente Ausente', ausentes, AppCores.ausente),

              _buildStat('Concluídas', concluidos, AppCores.concluido),

              _buildStat('Total de OS', totalMes, AppCores.textoBranco),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// ======================================================
  /// CARD PEQUENO DE ESTATÍSTICA
  /// ======================================================
  Widget _buildStat(String label, int value, Color color) {
    return Container(
      width: 120,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: color.withOpacity(0.12),

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: color.withOpacity(0.25)),
      ),

      child: Column(
        children: [
          /// VALOR
          Text(
            value.toString(),

            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// LABEL
          Text(
            label,

            textAlign: TextAlign.center,

            style: const TextStyle(
              color: AppCores.textoBranco,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
