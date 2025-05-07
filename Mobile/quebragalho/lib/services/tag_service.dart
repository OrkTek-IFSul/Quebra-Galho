import 'dart:convert';

import 'package:flutter_quebragalho/models/tag_model.dart';
import 'package:flutter_quebragalho/services/api_service.dart';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;



class TagService {

static const String _baseUrl = 'http://localhost:8080/api/tags';
  // Busca uma tag pelo ID
  static Future<Tag> getTag(int id) async {
    final response = await ApiService.get(ApiEndpoints.getTag(id));
    return Tag.fromJson(response);
  }

  // Busca todas as tags
  static Future<List<Tag>> getTodasTags() async {
    final url = Uri.parse(_baseUrl);
    final response = await http.get(url);
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((item) => Tag.fromJson(item)).toList();
  }

  // Cria uma nova tag
  static Future<Tag> criarTag(Tag tag) async {
    final response = await ApiService.post(
      ApiEndpoints.criarTag,
      body: tag.toJson(),
    );
    return Tag.fromJson(response);
  }

  // Atualiza uma tag existente pelo ID
  static Future<Tag> atualizarTag(int id, Tag tag) async {
    final response = await ApiService.put(
      ApiEndpoints.atualizarStatusTag(id),
      body: tag.toJson(),
    );
    return Tag.fromJson(response);
  }
}
