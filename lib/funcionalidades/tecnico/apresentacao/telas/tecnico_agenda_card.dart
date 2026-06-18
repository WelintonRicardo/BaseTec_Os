import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../compartilhado/tema_cores.dart';

/// ======================================================
/// CARD DE AGENDA DO TÉCNICO
/// ======================================================
///
/// Responsável por:
/// - Mostrar calendário horizontal
/// - Navegação entre dias
/// - Buscar quantidade de OS por dia
/// - Permitir seleção de data
///
/// Integração:
/// - Supabase
/// - ordens_servico
/// - tecnico_id
/// ======================================================

class TecnicoAgendaCard extends StatefulWidget {
  final DateTime selectedDate;

  final Function(DateTime) onDateSelected;

  /// Data em que técnico foi cadastrado
  final DateTime dataCadastro;

  const TecnicoAgendaCard({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.dataCadastro,
  });

  @override
  State<TecnicoAgendaCard> createState() => _TecnicoAgendaCardState();
}

class _TecnicoAgendaCardState extends State<TecnicoAgendaCard> {
  /// Cliente Supabase
  final SupabaseClient supabase = Supabase.instance.client;

  /// Data inicial mostrada
  late DateTime _startDate;

  /// Quantidade de OS por dia
  final Map<String, int> _quantidadeOS = {};
  static const int diasHistorico = 365;

  /// Loading
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _startDate = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );

    carregarQuantidadeOS();
  }

  /// ======================================================
  /// BUSCA QUANTIDADE DE OS DOS PRÓXIMOS 5 DIAS
  /// ======================================================
  Future<void> carregarQuantidadeOS() async {
    try {
      setState(() {
        _loading = true;
      });

      final user = supabase.auth.currentUser;

      if (user == null) return;

      /// Busca técnico logado
      final tecnico = await supabase
          .from('tecnicos')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (tecnico == null) return;

      final tecnicoId = tecnico['id'];

      final Map<String, int> temp = {};

      /// Percorre os 5 dias
      for (int i = 0; i < 5; i++) {
        final dia = _startDate.add(Duration(days: i));

        final inicioDia = DateTime(dia.year, dia.month, dia.day);

        final fimDia = inicioDia.add(const Duration(days: 1));

        /// Busca OS do dia
        final response = await supabase
            .from('ordens_servico')
            .select('id')
            .eq('tecnico_id', tecnicoId)
            .gte('janela_inicio_agendada', inicioDia.toIso8601String())
            .lt('janela_inicio_agendada', fimDia.toIso8601String());

        final chave = '${dia.day}-${dia.month}-${dia.year}';

        temp[chave] = response.length;
      }

      if (!mounted) return;

      setState(() {
        _quantidadeOS.clear();

        _quantidadeOS.addAll(temp);

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  /// ======================================================
  /// AVANÇAR 5 DIAS
  /// ======================================================
  void _nextDays() {
    setState(() {
      _startDate = _startDate.add(const Duration(days: 5));
    });

    carregarQuantidadeOS();
  }

  /// ======================================================
  /// VOLTAR 5 DIAS
  /// ======================================================
  void _previousDays() {
    setState(() {
      _startDate = _startDate.subtract(const Duration(days: 5));
    });

    carregarQuantidadeOS();
  }

  /// ======================================================
  /// SELECIONAR DATA
  /// ======================================================
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,

      initialDate: widget.selectedDate,

      firstDate: DateTime.now().subtract(const Duration(days: diasHistorico)),

      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
      });

      widget.onDateSelected(picked);

      carregarQuantidadeOS();
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(5, (i) => _startDate.add(Duration(days: i)));
    String _nomeDiaSemana(DateTime data) {
      const dias = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];

      return dias[data.weekday - 1];
    }

    String _nomeMes(DateTime data) {
      const meses = [
        'JAN',
        'FEV',
        'MAR',
        'ABR',
        'MAI',
        'JUN',
        'JUL',
        'AGO',
        'SET',
        'OUT',
        'NOV',
        'DEZ',
      ];

      return meses[data.month - 1];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),

      decoration: BoxDecoration(
        color: AppCores.cardEscuro,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: AppCores.bordaEscura),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// ==========================================
          /// HEADER
          /// ==========================================
          Row(
            children: [
              const Text(
                "Agenda",

                style: TextStyle(
                  color: AppCores.textoBranco,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppCores.textoBranco,
                  size: 18,
                ),

                onPressed: _previousDays,
              ),

              IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  color: AppCores.primaria,
                  size: 20,
                ),

                onPressed: _selectDate,
              ),

              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppCores.textoBranco,
                  size: 18,
                ),

                onPressed: _nextDays,
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// ==========================================
          /// LOADING
          /// ==========================================
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else
            SizedBox(
              height: 120,

              child: ListView.separated(
                scrollDirection: Axis.horizontal,

                itemCount: days.length,

                separatorBuilder: (_, __) => const SizedBox(width: 10),

                itemBuilder: (context, index) {
                  final day = days[index];

                  final isSelected =
                      day.day == widget.selectedDate.day &&
                      day.month == widget.selectedDate.month &&
                      day.year == widget.selectedDate.year;

                  final chave = '${day.day}-${day.month}-${day.year}';

                  final quantidade = _quantidadeOS[chave] ?? 0;

                  return GestureDetector(
                    onTap: () {
                      widget.onDateSelected(day);

                      setState(() {});
                    },

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),

                      width: 80,

                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: isSelected ? AppCores.primaria : Colors.white10,

                        borderRadius: BorderRadius.circular(14),

                        border: Border.all(
                          color: isSelected
                              ? AppCores.primaria
                              : Colors.white12,
                        ),
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _nomeDiaSemana(day),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            '${day.day}',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppCores.textoBranco,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            _nomeMes(day),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white70
                                  : AppCores.textoCinza,
                              fontSize: 10,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: quantidade > 0
                                  ? Colors.green.withOpacity(.15)
                                  : Colors.white10,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$quantidade',
                              style: TextStyle(
                                color: quantidade > 0
                                    ? Colors.greenAccent
                                    : Colors.white54,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
