import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

Widget buildCalendarioBR({
  DateTime? selectedDay,
  required Function(DateTime selectedDay) onDaySelected,
}) {
  final DateTime hoje = DateTime.now();

  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppCores.cardEscuro,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppCores.bordaEscura, width: 1.2),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4)),
      ],
    ),
    child: Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: AppCores.primaria,
          onPrimary: Colors.white,
          surface: AppCores.cardEscuro,
          onSurface: AppCores.textoBranco,
        ),
        dividerColor: AppCores.bordaEscura,
      ),
      child: CalendarDatePicker(
        initialDate: selectedDay ?? hoje,
        firstDate: DateTime(2020),
        lastDate: DateTime(2035),
        onDateChanged: (date) => onDaySelected(date),
      ),
    ),
  );
}
