import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:quebragalho2/views/cliente/pages/tela_confirmacao_solicitacao.dart';
import 'package:quebragalho2/services/agendamento_page_services.dart';
import 'login_page.dart';

class AgendamentoPage extends StatefulWidget {
  final String servico;
  final int servicoId;
  final int prestadorId;

  const AgendamentoPage({
    required this.servico,
    required this.servicoId,
    required this.prestadorId,
    super.key,
  });

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  late DateTime _selectedDay;
  String? _selectedTime;

  int? _duracaoServico;
  DateTime? _horarioInicioPrestador;
  DateTime? _horarioFimPrestador;

  final AgendamentoPageService _service = AgendamentoPageService();

  List<DateTime> _horariosDisponiveisAPI = [];
  List<String> _horariosDisponiveis = [];
  List<DateTime> _horariosIndisponiveis = [];

  bool _loading = true;
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

    await _refreshForSelectedDay();

    setState(() => _loading = false);
  }

  Future<void> _refreshForSelectedDay() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _horariosDisponiveisAPI.clear();
      _horariosDisponiveis.clear();
      _horariosIndisponiveis.clear();
      _selectedTime = null;
    });

    await _carregarDadosPrestadorEHorario();
    await _carregarHorariosDisponiveis();
    _gerarHorariosDisponiveis();
  }

  Future<void> _carregarDadosPrestadorEHorario() async {
    try {
      final dadosPrestador = await _service.buscarDadosPrestador(widget.prestadorId);
      DateTime horarioInicioAPI = DateTime.parse(dadosPrestador['horarioInicio']);
      DateTime horarioFimAPI = DateTime.parse(dadosPrestador['horarioFim']);

      final servicos = dadosPrestador['servicos'] as List<dynamic>;
      final servicoSelecionado = servicos.firstWhere((s) => s['id'] == widget.servicoId);
      int duracao = servicoSelecionado['duracao'] as int;

      _horarioInicioPrestador = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        horarioInicioAPI.hour,
        horarioInicioAPI.minute,
      );
      _horarioFimPrestador = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        horarioFimAPI.hour,
        horarioFimAPI.minute,
      );

      setState(() {
        _duracaoServico = duracao;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados do prestador: $e')),
        );
      }
    }
  }

  Future<void> _carregarHorariosDisponiveis() async {
    try {
      final horarios = await _service.listarHorariosDisponiveis(widget.servicoId, _selectedDay);
      setState(() {
        _horariosDisponiveisAPI = horarios;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar horários disponíveis: $e')),
        );
      }
    }
  }

  void _gerarHorariosDisponiveis() {
    if (_duracaoServico == null || _horarioInicioPrestador == null || _horarioFimPrestador == null) return;

    List<String> horariosGerados = [];
    DateTime horarioAtual = _horarioInicioPrestador!;

    while (horarioAtual.add(Duration(minutes: _duracaoServico!)).isBefore(_horarioFimPrestador!) ||
        horarioAtual.add(Duration(minutes: _duracaoServico!)).isAtSameMomentAs(_horarioFimPrestador!)) {
      bool estaDisponivelNaApi = _horariosDisponiveisAPI.any((horaApi) =>
        horaApi.year == horarioAtual.year &&
        horaApi.month == horarioAtual.month &&
        horaApi.day == horarioAtual.day &&
        horaApi.hour == horarioAtual.hour &&
        horaApi.minute == horarioAtual.minute);

      if (estaDisponivelNaApi) {
        horariosGerados.add(DateFormat('HH:mm').format(horarioAtual));
      }
      horarioAtual = horarioAtual.add(Duration(minutes: _duracaoServico!));
    }

    setState(() {
      _horariosDisponiveis = horariosGerados;
    });
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
            content: Text('Erro: \${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar', style: TextStyle(fontSize: 16)),
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
                    onDaySelected: (selectedDay, focusedDay) async {
                      setState(() => _selectedDay = selectedDay);
                      await _refreshForSelectedDay();
                      setState(() => _loading = false);
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
                            : 'CONFIRMAR AGENDAMENTO PARA \$_selectedTime',
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
