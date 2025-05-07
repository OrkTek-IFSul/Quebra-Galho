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
        const SizedBox(height: 50),
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
        const SizedBox(height: 8),
        
        // Time Slots com rolagem horizontal
        SizedBox(
          height: 50,
          child: TimeSlotPicker(
            availableTimes: _availableTimes,
            selectedTime: _selectedTime,
            onTimeSelected: (time) {
              setState(() {
                _selectedTime = time;
              });
            },
          ),
        ),
        
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Data:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text( '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Hora:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  _selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'Não selecionada',
                  style: TextStyle(fontSize: 18, color: Colors.purple, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class TimeSlotPicker extends StatelessWidget {
  final List<TimeOfDay> availableTimes;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const TimeSlotPicker({
    super.key,
    required this.availableTimes,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: availableTimes.length,
      itemBuilder: (context, index) {
        final time = availableTimes[index];
        final isSelected = selectedTime != null &&
            selectedTime!.hour == time.hour &&
            selectedTime!.minute == time.minute;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: () => onTimeSelected(time),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: isSelected ? Colors.purple : Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.purple : Colors.purple.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  time.format(context),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.purple,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}