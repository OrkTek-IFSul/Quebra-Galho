import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/avaliacao_model.dart';

class AvaliacaoService {
  static const String _baseUrl = 'http://localhost:8080/api/avaliacoes';

  // Cria uma nova avaliação a partir de dados e URL fornecidos
  Future<http.Response> criarAvaliacao(Map<String, dynamic> data, String url) async {
    if (data['nota'] == null || data['nota'] < 1 || data['nota'] > 5) {
      throw ArgumentError('A nota deve estar entre 1 e 5');
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Erro ao criar avaliação: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Obtém lista de avaliações associadas a um serviço
  static Future<List<Avaliacao>> getAvaliacoesPorServico(int servicoId) async {
    final url = Uri.parse('$_baseUrl/servico/$servicoId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Avaliacao.fromJson(e)).toList();
    } else {
      throw Exception('Falha ao carregar avaliações');
    }
  }

  // Deleta uma avaliação por ID
  static Future<void> deletarAvaliacao(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar avaliação');
    }
  }

  // Envia uma resposta para uma avaliação
  Future<http.Response> responderAvaliacao(Map<String, dynamic> data, int avaliacaoId) async {
    final url = '$_baseUrl/$avaliacaoId/resposta';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Erro ao responder avaliação: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
