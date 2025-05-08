import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_quebragalho/models/prestador_model.dart';

class PrestadorService {
  static const String _baseUrl = 'http://localhost:8080/api/prestadores';

  // Método para criar prestador
  static Future<Prestador> criarPrestador(
    Map<String, dynamic> data,
    String url,
  ) async {
    try {
      // Realizando uma requisição POST com os dados do prestador
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data), // Convertendo o Map para JSON
      );

      // Verificando a resposta
      if (response.statusCode == 200) {
        return Prestador.fromJson(
          jsonDecode(response.body),
        ); // Retorna o prestador criado
      } else {
        throw Exception('Erro ao criar prestador: ${response.statusCode}');
      }
    } catch (e) {
      rethrow; // Propaga o erro
    }
  }

  // Busca um prestador por ID
  static Future<Prestador> getPrestador(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Prestador.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar prestador');
    }
  }

  // Lista todos os prestadores
  static Future<List<Prestador>> getPrestadores() async {
    final url = Uri.parse(_baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Prestador.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar prestadores');
    }
  }

  // Atualiza um prestador existente
  static Future<Prestador> atualizarPrestador(
    int id,
    Map<String, dynamic> data,
    String url,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data), // Convertendo o Map para JSON
      );

      if (response.statusCode == 200) {
        return Prestador.fromJson(
          jsonDecode(response.body),
        ); // Retorna o prestador atualizado
      } else {
        throw Exception('Erro ao atualizar prestador: ${response.statusCode}');
      }
    } catch (e) {
      rethrow; // Propaga o erro
    }
  }

  // Remove um prestador
  static Future<void> deletarPrestador(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar prestador');
    }
  }

  static Future<String> uploadImagemDocumento(int id, File file) async {
    // Cria a requisição multipart
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://sua-api.com/api/prestadores/$id/documento',
      ), // Substitua pelo URL base da sua API
    );
    // Adiciona o arquivo à requisição
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // Nome do campo esperado pelo endpoint
        file.path,
      ),
    );
    // Envia a requisição
    final response = await request.send();
    // Verifica o status da resposta
    if (response.statusCode == 200) {
      // Lê o corpo da resposta (nome do arquivo)
      final responseBody = await response.stream.bytesToString();
      return responseBody; // Retorna o nome do arquivo
    } else {
      throw Exception('Erro ao enviar documento: ${response.statusCode}');
    }
  }
}
