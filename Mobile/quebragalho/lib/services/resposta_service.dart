import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_quebragalho/models/resposta_model.dart';

class RespostaService {
  static const String _baseUrl = 'http://localhost:8080/api/respostas';

  /// Método genérico para criar uma resposta
  static Future<http.Response> criarResposta(Map<String, dynamic> data, String url) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return response; // Retorna a resposta bem-sucedida
      } else {
        throw Exception('Erro ao criar resposta: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Busca uma resposta associada a uma avaliação específica pelo ID
  static Future<Resposta?> getRespostaPorAvaliacao(int avaliacaoId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/avaliacao/$avaliacaoId'));

      if (response.statusCode == 200) {
        return Resposta.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return null;  // Se a resposta não for encontrada
      } else {
        throw Exception('Erro ao buscar resposta: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Atualiza o texto de uma resposta existente
  static Future<Resposta> atualizarResposta({
    required int id,
    required String novaResposta,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'resposta': novaResposta,
          'data': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        return Resposta.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao atualizar resposta: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Remove uma resposta pelo ID
  static Future<void> deletarResposta(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Erro ao deletar resposta: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Lista todas as respostas associadas a uma avaliação
  static Future<List<Resposta>> getRespostasPorAvaliacao(int avaliacaoId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/avaliacao/$avaliacaoId'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Resposta.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao carregar respostas: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
