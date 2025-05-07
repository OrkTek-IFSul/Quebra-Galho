import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_quebragalho/models/servico_model.dart';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';

class ServicoService {
  /// Método para criar um serviço
  static Future<http.Response> criarServico(Map<String, dynamic> data, String url) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),  // Convertendo o Map para JSON
      );

      if (response.statusCode == 200) {
        return response; // Retorna a resposta bem-sucedida
      } else {
        throw Exception('Erro ao criar serviço: ${response.statusCode}');
      }
    } catch (e) {
      rethrow; // Propaga o erro
    }
  }

  // Outros métodos do Serviço (não alterados)
  static Future<List<Servicos>> getTodosServicos() async {
    final response = await http.get(Uri.parse(ApiEndpoints.getServicos));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Servicos.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar serviços');
    }
  }

  static Future<Servicos> atualizarServico(int id, Servicos servico) async {
    try {
      final response = await http.put(
        Uri.parse(ApiEndpoints.atualizarServico(id)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(servico.toJson()),
      );

      if (response.statusCode == 200) {
        return Servicos.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao atualizar serviço: ${response.statusCode}');
      }
    } catch (e) {
      rethrow; // Propaga o erro
    }
  }

  static Future<bool> deletarServico(int id) async {
    try {
      final response = await http.delete(Uri.parse(ApiEndpoints.deletarServico(id)));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Erro ao deletar serviço');
      }
    } catch (e) {
      rethrow; // Propaga o erro
    }
  }
}
