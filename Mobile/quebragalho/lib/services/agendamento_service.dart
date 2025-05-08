import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_quebragalho/models/agendamento_model.dart';


class AgendamentoService {
  static const String _baseUrl = 'http://localhost:8080/api/agendamentos';

  // Método para criar agendamento
  Future<http.Response> criarAgendamento({
    required DateTime dataHora,
    required bool status,
    required int servicoId,
    required int usuarioId,
    String? observacoes,
  }) async {
    try {
      final url = Uri.parse(_baseUrl)
          .replace(queryParameters: {
            'servicoId': servicoId.toString(),
            'usuarioId': usuarioId.toString(),
          });

      final body = {
        'dataHora': dataHora.toIso8601String(),
        'status': status,
        if (observacoes != null) 'observacoes': observacoes,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Erro ao criar agendamento: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Outros métodos do AgendamentoService
  static Future<List<Agendamento>> getAgendamentosUsuario(int usuarioId) async {
    final url = Uri.parse('$_baseUrl/usuario/$usuarioId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Agendamento.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar agendamentos');
    }
  }

  static Future<List<Agendamento>> getAgendamentosPrestador(int prestadorId) async {
    final url = Uri.parse('$_baseUrl/prestador/$prestadorId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Agendamento.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar agendamentos');
    }
  }

  static Future<void> deletarAgendamento(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar agendamento');
    }
  }
}
