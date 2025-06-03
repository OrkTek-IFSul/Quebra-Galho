///
/// Perfil Service - Quebra Galho App
/// By Jean Carlo | Orktek
/// github.com/jeankeitwo16
/// Descrição: Serviço de agendamento de horários para serviços, onde o usuário pode selecionar uma data e horário disponíveis para agendar um serviço específico.
/// Versão: 1.0.0
///
import 'dart:convert';
import 'package:http/http.dart' as http;

class AgendamentoPageService {
  static const String _baseUrl = 'http://10.0.2.2:8080/api/usuario/homepage/agendamento';

  Future<List<DateTime>> listarHorariosIndisponiveis(int servicoId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$servicoId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => DateTime.parse(e as String)).toList();
      } else {
        throw Exception('Falha ao carregar horários. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar horários indisponíveis: $e');
    }
  }

  Future<Map<String, dynamic>> cadastrarAgendamento({
  required int usuarioId,
  required int servicoId,
  required DateTime horario,
}) async {
  try {
    final response = await http.post(
      Uri.parse(_baseUrl),
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
      throw Exception('Falha ao confirmar agendamento');
    }
  } catch (e) {
    throw Exception('Erro ao cadastrar agendamento: $e');
  }
}

}