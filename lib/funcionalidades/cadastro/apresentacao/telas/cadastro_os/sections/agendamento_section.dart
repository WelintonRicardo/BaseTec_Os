// lib/funcionalidades/cadastro/apresentacao/telas/cadastro_os/sections/agendamento_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../controle/cadastro_os_controller.dart';
import '../../../../../../compartilhado/tema_cores.dart';
import '../widgets/os_card_section.dart';

class AgendamentoSection extends StatelessWidget {
  final CadastroOsController controller;

  const AgendamentoSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return OsCardSection(
      titulo: 'Agendamento',
      children: [
        Row(
          children: [
            Expanded(
              child: _buildButton(
                context,
                icon: Icons.calendar_month,
                text: controller.dataAgendamento == null
                    ? 'Selecionar Data'
                    : DateFormat(
                        'dd/MM/yyyy',
                      ).format(controller.dataAgendamento!),
                onTap: () async {
                  final data = await showDatePicker(
                    context: context,
                    initialDate:
                        controller.dataAgendamento ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (data != null) {
                    controller.dataAgendamento = data;
                    controller.notifyListeners();
                  }
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildButton(
                context,
                icon: Icons.access_time,
                text: controller.horaInicio == null
                    ? 'Hora Início'
                    : controller.horaInicio!.format(context),
                onTap: () async {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 9, minute: 0),
                  );

                  if (hora != null) {
                    controller.horaInicio = hora;
                    controller.notifyListeners();
                  }
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        _buildButton(
          context,
          icon: Icons.timer_off,
          text: controller.horaFim == null
              ? 'Hora Final'
              : controller.horaFim!.format(context),
          onTap: () async {
            final hora = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 10, minute: 0),
            );

            if (hora != null) {
              controller.horaFim = hora;
              controller.notifyListeners();
            }
          },
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: AppCores.cardEscuro.withOpacity(0.7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppCores.bordaEscura,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppCores.primaria,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: AppCores.textoBranco,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
  }

  
}