import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_quebragalho/models/agendamento_model.dart';


class AgendamentoService {
  static const String _baseUrl = 'http://localhost:8080/api/agendamentos';

  // Método para criar agendamento
  Future<http.Response> criarAgendamento(Map<String, dynamic> data, String url) async {
    try {
      // Realizando uma requisição POST com os dados do agendamento
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),  // Convertendo o Map para JSON
      );

      // Verificando a resposta
      if (response.statusCode == 200) {
        return response; // Retorna a resposta bem-sucedida
      } else {
        throw Exception('Erro ao criar agendamento: ${response.statusCode}');
      }
    } catch (e) {
      rethrow; // Propaga o erro
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
