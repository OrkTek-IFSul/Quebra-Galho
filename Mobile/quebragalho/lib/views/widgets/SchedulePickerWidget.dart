import 'package:flutter/material.dart';

class SchedulePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;
  final DateTime initialDate;

  const SchedulePickerWidget({
    super.key,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.initialDate,
  });

  @override
  State<SchedulePickerWidget> createState() => _SchedulePickerWidgetState();
}

class _SchedulePickerWidgetState extends State<SchedulePickerWidget> {
  late DateTime _selectedDate;
  TimeOfDay? _selectedTime;

  final List<TimeOfDay> _availableTimes = List.generate(
    25,
    (index) => TimeOfDay(hour: 8 + (index ~/ 2), minute: (index % 2) * 30),
  );

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

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
            setState(() => _selectedDate = date);
            widget.onDateChanged(date);
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
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _availableTimes.length,
            itemBuilder: (context, index) {
              final time = _availableTimes[index];
              final isSelected = _selectedTime != null &&
                  _selectedTime!.hour == time.hour &&
                  _selectedTime!.minute == time.minute;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () {
                    setState(() => _selectedTime = time);
                    widget.onTimeChanged(time);
                  },
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
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Data:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Hora:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  _selectedTime != null ? _selectedTime!.format(context) : 'Não selecionada',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}