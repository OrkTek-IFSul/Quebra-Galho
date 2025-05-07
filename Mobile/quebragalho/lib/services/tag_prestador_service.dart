import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tag_prestador_model.dart';

class TagPrestadorService {
  static const String _baseUrl = 'http://localhost:8080/api/tag-prestador';

  /// Adiciona uma tag a um prestador
  Future<TagPrestador> atualizarTagPrestador(Map<String, dynamic> data, String url) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return TagPrestador.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao adicionar tag: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Remove uma tag de um prestador
  static Future<void> deletarTagPrestador({
    required int tagId,
    required int prestadorId,
  }) async {
    final url = Uri.parse('$_baseUrl/$tagId/prestador/$prestadorId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao remover tag do prestador');
    }
  }

  /// Lista tags de um prestador
  static Future<List<int>> getTagPrestador(int prestadorId) async {
    final url = Uri.parse('$_baseUrl/prestador/$prestadorId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((id) => id as int).toList();
    } else {
      throw Exception('Erro ao buscar tags do prestador');
    }
  }
}
