import 'package:flutter/material.dart';
import '../../../../compartilhado/tema_cores.dart';

Widget buildCalendarioBR({
  DateTime? selectedDay,
  required Function(DateTime selectedDay) onDaySelected,
}) {
  final DateTime hoje = DateTime.now();

  return Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppCores.cardEscuro,
          AppCores.cardEscuro.withOpacity(0.85),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: AppCores.primaria.withOpacity(0.15),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.30),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              color: AppCores.primaria,
              size: 24,
            ),
            SizedBox(width: 10),
            Text(
              'Agenda',
              style: TextStyle(
                color: AppCores.textoBranco,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Theme(
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
      ],
    ),
  );
}