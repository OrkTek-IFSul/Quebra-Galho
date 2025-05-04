import 'package:flutter/material.dart';

class SchedulePickerWidget extends StatefulWidget {
  const SchedulePickerWidget({super.key});

  @override
  State<SchedulePickerWidget> createState() => _SchedulePickerWidgetState();
}

class _SchedulePickerWidgetState extends State<SchedulePickerWidget> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  // Lista de horários disponíveis (de 08:00 às 20:00, de 30 em 30 min)
  final List<TimeOfDay> _availableTimes = List.generate(
    25,
    (index) => TimeOfDay(hour: 8 + (index ~/ 2), minute: (index % 2) * 30),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        const Text(
          'Selecione uma data:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        CalendarDatePicker(
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Selecione uma hora:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        DropdownButton<TimeOfDay>(
          value: _selectedTime,
          hint: const Text('Escolha o horário'),
          onChanged: (TimeOfDay? newTime) {
            setState(() {
              _selectedTime = newTime;
            });
          },
          items:
              _availableTimes.map((time) {
                return DropdownMenuItem<TimeOfDay>(
                  value: time,
                  child: Text(time.format(context)),
                );
              }).toList(),
        ),
        const SizedBox(height: 24),
        Text(
          'Data: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          _selectedTime != null
              ? 'Hora: ${_selectedTime!.format(context)}'
              : 'Hora não selecionada',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
