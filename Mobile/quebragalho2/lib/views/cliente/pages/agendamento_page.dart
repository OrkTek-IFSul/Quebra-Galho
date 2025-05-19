import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/tela_confirmacao_solicitacao.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendamentoPage extends StatefulWidget {
  final String servico;

  const AgendamentoPage({super.key, required this.servico});

  @override
  _AgendamentoPageState createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  DateTime _selectedDay = DateTime.now();
  String? _selectedTime;

  final List<String> _horariosDisponiveis = [
    '08:00', '09:30', '11:00', '13:00', '14:30', '16:00'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agendar ${widget.servico}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Calendário
            TableCalendar(
              focusedDay: _selectedDay,
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 60)),
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              ),
            ),
            SizedBox(height: 20),

            /// Horários
            Text('Horários disponíveis:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _horariosDisponiveis.map((hora) {
                final selecionado = _selectedTime == hora;
                return ChoiceChip(
                  label: Text(hora),
                  selected: selecionado,
                  onSelected: (_) {
                    setState(() {
                      _selectedTime = hora;
                    });
                  },
                );
              }).toList(),
            ),
            Spacer(),

            /// Botão Solicitar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedTime == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConfirmacaoPage(
                              nomePrestador: 'João da Barbearia', // pode trocar por dinâmico depois
                              nomeServico: widget.servico,
                              data: _selectedDay,
                              hora: _selectedTime!,
                              valor: 79.90, // valor fixo exemplo
                            ),
                          ),
                        );
                      },
                child: Text('Solicitar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
