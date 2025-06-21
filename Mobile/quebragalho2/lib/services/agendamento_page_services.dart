import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quebragalho2/api_config.dart';

class AgendamentoPageService {
  static const String _baseUrlAgendamento = 'https://${ApiConfig.baseUrl}/api/usuario/homepage/agendamento';
  static const String _baseUrlServico = 'https://${ApiConfig.baseUrl}/api/usuario/homepage/servicos';
  static const String _baseUrlPrestadorPerfil = 'https://${ApiConfig.baseUrl}/api/prestador/perfil';

  Future<int> buscarDuracaoServico(int servicoId) async {
    final response = await http.get(Uri.parse('$_baseUrlServico/$servicoId'));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody['duracao'] as int;
    } else {
      throw Exception('Erro ao buscar duração do serviço. Status: ${response.statusCode}');
    }
  }

  Future<List<DateTime>> listarHorariosDisponiveis(int servicoId, DateTime data) async {
    final dataFormatada = DateFormat('yyyy-MM-dd').format(data);
    final response = await http.get(
      Uri.parse('$_baseUrlAgendamento/$servicoId/horarios-disponiveis?data=$dataFormatada'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => DateTime.parse(e as String)).toList();
    } else {
      throw Exception('Falha ao carregar horários disponíveis. Status: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> cadastrarAgendamento({
    required int usuarioId,
    required int servicoId,
    required DateTime horario,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrlAgendamento),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_usuario': usuarioId,
        'id_servico': servicoId,
        'horario': horario.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Falha ao confirmar agendamento. Status: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> buscarDadosPrestador(int prestadorId) async {
    final response = await http.get(Uri.parse('$_baseUrlPrestadorPerfil/$prestadorId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Erro ao buscar dados do prestador. Status: ${response.statusCode}');
    }
  }
}
