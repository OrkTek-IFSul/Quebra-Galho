
import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/services/agendamento_service.dart';
import 'package:flutter_quebragalho/views/widgets/SchedulePickerWidget.dart';

class SchedulePage extends StatefulWidget {
  final int servicoId;
  final int prestadorId;
  final int usuarioId;

  const SchedulePage({
    super.key,
    required this.servicoId,
    required this.prestadorId,
    required this.usuarioId,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late DateTime _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _submitAgendamento() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um horário!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dataHora = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final response = await AgendamentoService().criarAgendamento(
        dataHora: dataHora,
        status: true,
        servicoId: widget.servicoId,
        usuarioId: widget.usuarioId,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agendamento realizado com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
  }

  void _handleTimeChanged(TimeOfDay time) {
    setState(() => _selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Agendar Serviço',
          style: TextStyle(
            color: Colors.purple,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SchedulePickerWidget(
                onDateChanged: _handleDateChanged,
                onTimeChanged: _handleTimeChanged,
                initialDate: _selectedDate,
              ),
            ),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitAgendamento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Solicitar",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
