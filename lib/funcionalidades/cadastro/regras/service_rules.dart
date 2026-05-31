// lib/funcionalidades/cadastro/regras/service_rules.dart

import 'package:flutter/material.dart';

class ServiceRules {
  static const String tipoEmergencial = 'Emergencial';

  static void applyOnTipoChange({
    required String? tipo,
    DateTime Function()? nowProvider,
    required void Function(DateTime data, TimeOfDay horaInicio, TimeOfDay horaFim) onApply,
  }) {
    final now = nowProvider?.call() ?? DateTime.now();

    if (tipo == tipoEmergencial) {
      final inicio = now;
      final fim = now.add(const Duration(minutes: 70));

      final horaInicio = TimeOfDay(hour: inicio.hour, minute: inicio.minute);
      final horaFim = TimeOfDay(hour: fim.hour, minute: fim.minute);

      onApply(inicio, horaInicio, horaFim);
    }
  }

  static DateTime calcularFim(DateTime inicio, {int minutos = 70}) {
    return inicio.add(Duration(minutes: minutos));
  }
}
