import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_quebragalho/models/tag_model.dart';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';

class TagService {
  static const String _baseUrl = 'http://localhost:8080/api/tags';  // Base URL para as Tags

  // Método para atualizar o status da tag
  static Future<Tags> atualizarStatusTag({
    required int id,
    required String novoStatus,
  }) async {
    if (novoStatus != 'Ativo' && novoStatus != 'Inativo') {
      throw ArgumentError('Status deve ser "Ativo" ou "Inativo"');
    }

    final response = await http.put(
      Uri.parse(ApiEndpoints.atualizarStatusTag(id)),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': novoStatus}),
    );

    if (response.statusCode == 200) {
      return Tags.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao atualizar status da tag');
    }
  }

  // Método para obter todas as tags
  static Future<List<Tags>> getTags() async {
    final response = await http.get(Uri.parse(ApiEndpoints.getTags));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Tags.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar tags');
    }
  }

  // Método para criar uma nova tag
  static Future<Tags> criarTag({
    required String nome,
    String status = 'Ativo',
  }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.criarTag),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': nome,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return Tags.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao criar tag');
    }
  }

  // Método para deletar uma tag
  static Future<void> deletarTag(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar tag');
    }
  }
}
