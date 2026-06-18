import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../compartilhado/tema_cores.dart';

import '../../controle/tecnico_controller.dart';

import 'tecnico_header_card.dart';
import 'tecnico_agenda_card.dart';
import 'tecnico_os_card.dart';

/// ======================================================
/// TELA PRINCIPAL DO TÉCNICO
/// ======================================================
///
/// Responsável por:
/// - Inicializar controller
/// - Exibir dashboard do técnico
/// - Mostrar agenda
/// - Mostrar OS do dia
/// - Atualizar dados via pull-to-refresh
///
/// Estrutura:
/// - Header do técnico
/// - Agenda
/// - Lista de OS
/// ======================================================

class TelaTecnico extends StatelessWidget {
  const TelaTecnico({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = TecnicoController();

        controller.inicializar();
        controller.iniciarRealtime();

        return controller;
      },

      child: const _TelaTecnicoBody(),
    );
  }
}

class _TelaTecnicoBody extends StatelessWidget {
  const _TelaTecnicoBody();

  @override
  Widget build(BuildContext context) {
    /// ============================================
    /// CONTROLLER
    /// ============================================
    final controller = context.watch<TecnicoController>();

    /// ============================================
    /// LOADING
    /// ============================================
    if (controller.loading) {
      return const Scaffold(
        backgroundColor: AppCores.fundoEscuro,

        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// ============================================
    /// DADOS DO TÉCNICO
    /// ============================================
    final tecnico = controller.dadosTecnico;

    final nome = tecnico?['nome'] ?? '---';

    /// Nome da empresa
    final empresa = tecnico?['empresa_nome'] ?? 'BaseTec OS';

    /// ============================================
    /// TELA PRINCIPAL
    /// ============================================
    return Scaffold(
      backgroundColor: AppCores.fundoEscuro,

      /// ========================================
      /// APP BAR
      /// ========================================
      appBar: AppBar(
        elevation: 0,

        centerTitle: true,

        backgroundColor: AppCores.cardEscuro,

        title: const Text(
          'Painel do Técnico',

          style: TextStyle(
            color: AppCores.textoBranco,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// ========================================
      /// BODY
      /// ========================================
      body: RefreshIndicator(
        /// Atualização manual
        onRefresh: controller.inicializar,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              /// ==================================
              /// HEADER SUPERIOR
              /// ==================================
              ///
              /// Agora o próprio card já busca
              /// os dados automaticamente
              ///
              const TecnicoHeaderCard(),

              const SizedBox(height: 20),

              /// ==================================
              /// CALENDÁRIO / AGENDA
              /// ==================================
              TecnicoAgendaCard(
                selectedDate: controller.selectedDate,

                dataCadastro: controller.dataCadastro ?? DateTime.now(),

                onDateSelected: controller.alterarData,
              ),

              const SizedBox(height: 20),

              /// ==================================
              /// LISTA DE OS
              /// ==================================
              TecnicoOSCard(
                selectedDate: controller.selectedDate,

                osList: controller.osList,
              ),

              /// ==================================
              /// MENSAGEM SEM OS
              /// ==================================
              if (controller.osList.isEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 30),

                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: AppCores.cardEscuro,

                    borderRadius: BorderRadius.circular(18),

                    border: Border.all(color: AppCores.bordaEscura),
                  ),

                  child: const Column(
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        color: Colors.white54,
                        size: 48,
                      ),

                      SizedBox(height: 14),

                      Text(
                        'Nenhuma OS encontrada',

                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
