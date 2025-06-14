///
/// Perfil View - Quebra Galho App
/// By Jean Carlo | Orktek
/// github.com/jeankeitwo16
/// Descrição: Página de agendamento de serviços, onde o usuário pode selecionar uma data e horário disponíveis para agendar um serviço específico.
/// Versão: 1.0.0
///
library;
import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/tela_confirmacao_solicitacao.dart'; // Verifique este arquivo também
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
// Importa a config da API
import '../../../services/agendamento_page_services.dart'; // Verifique este arquivo também
import 'login_page.dart';

class AgendamentoPage extends StatefulWidget {
  final String servico;
  final int servicoId;

  const AgendamentoPage({
    required this.servico,
    required this.servicoId,
    super.key,
  });

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  late DateTime _selectedDay;
  String? _selectedTime;
  final List<String> _horariosDisponiveis = [
    '08:00', '09:00', '10:00', '11:00',
    '13:00', '14:00', '15:00', '16:00'
  ];
  final AgendamentoPageService _service = AgendamentoPageService();
  List<DateTime> _horariosIndisponiveis = [];
  bool _loading = true; // começa true enquanto carrega usuário e horários

  int? _usuarioId;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final id = await obterIdUsuario();
    if (id == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: usuário não está logado')),
      );
      setState(() => _loading = false);
      return;
    }

    setState(() {
      _usuarioId = id;
    });

    await _carregarHorariosIndisponiveis();
  }

  Future<void> _carregarHorariosIndisponiveis() async {
    setState(() => _loading = true);
    try {
      final result = await _service.listarHorariosIndisponiveis(widget.servicoId);
      setState(() => _horariosIndisponiveis = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar horários: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  bool _isHorarioIndisponivel(String hora) {
    final dataHora = _criarDateTime(_selectedDay, hora);
    return _horariosIndisponiveis.any((indisponivel) =>
      isSameDay(indisponivel, dataHora) &&
      indisponivel.hour == dataHora.hour &&
      indisponivel.minute == dataHora.minute);
  }

  DateTime _criarDateTime(DateTime data, String hora) {
    final partes = hora.split(':');
    return DateTime(
      data.year,
      data.month,
      data.day,
      int.parse(partes[0]),
      int.parse(partes[1]),
    );
  }

  Future<void> _solicitarAgendamento() async {
    if (_selectedTime == null || _usuarioId == null) return;

    setState(() => _loading = true);
    try {
      final dataHora = _criarDateTime(_selectedDay, _selectedTime!);

      if (_isHorarioIndisponivel(_selectedTime!)) {
        throw Exception('Este horário já está reservado');
      }

      final agendamento = await _service.cadastrarAgendamento(
        usuarioId: _usuarioId!,
        servicoId: widget.servicoId,
        horario: dataHora,
      );

      final nomePrestador = agendamento['prestador'];
      final nomeServico = agendamento['servico'];
      final preco = (agendamento['preco_servico'] as num).toDouble();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmacaoPage(
              nomePrestador: nomePrestador,
              nomeServico: nomeServico,
              data: dataHora,
              hora: DateFormat('HH:mm').format(dataHora),
              valor: preco,
            ),
          ),
        );
      }

      setState(() {
        _horariosIndisponiveis.add(dataHora);
        _selectedTime = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TableCalendar(
                    focusedDay: _selectedDay,
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 60)),
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _selectedTime = null;
                      });
                      _carregarHorariosIndisponiveis();
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.green.shade300,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Horários disponíveis:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildHorariosGrid(),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedTime == null ? null : _solicitarAgendamento,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _selectedTime == null
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        _selectedTime == null
                            ? 'SELECIONE UM HORÁRIO'
                            : 'CONFIRMAR AGENDAMENTO PARA $_selectedTime',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHorariosGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5,
      ),
      itemCount: _horariosDisponiveis.length,
      itemBuilder: (context, index) {
        final hora = _horariosDisponiveis[index];
        final indisponivel = _isHorarioIndisponivel(hora);
        final selecionado = _selectedTime == hora;

        return GestureDetector(
          onTap: indisponivel ? null : () => setState(() => _selectedTime = hora),
          child: Container(
            decoration: BoxDecoration(
              color: indisponivel
                  ? Colors.grey[300]
                  : selecionado
                      ? Theme.of(context).primaryColor
                      : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: indisponivel
                    ? Colors.grey
                    : selecionado
                        ? Theme.of(context).primaryColor
                        : Colors.blue.shade100,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hora,
                    style: TextStyle(
                      color: indisponivel
                          ? Colors.grey[600]
                          : selecionado
                              ? Colors.white
                              : Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (indisponivel)
                    const Text(
                      'INDISPONÍVEL',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
