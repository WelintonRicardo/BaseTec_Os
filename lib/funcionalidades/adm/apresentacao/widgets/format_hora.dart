String formatHora(String? dataIso) {
  if (dataIso == null || dataIso.isEmpty) return '---';
  try {
    final dt = DateTime.parse(dataIso);
    final hora = dt.hour.toString().padLeft(2, '0');
    final minuto = dt.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  } catch (e) {
    return '---';
  }
}
