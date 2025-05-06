import 'package:flutter_quebragalho/models/tag_model.dart';
import 'package:flutter_quebragalho/services/api_service.dart';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';

class TagService {
  // Busca uma tag pelo ID
  static Future<Tag> getTag(int id) async {
    final response = await ApiService.get(ApiEndpoints.getTag(id));
    return Tag.fromJson(response);
  }

  // Busca todas as tags
  static Future<List<Tag>> getTodasTags() async {
    final response = await ApiService.get(ApiEndpoints.getTags);
    return (response as List).map((json) => Tag.fromJson(json)).toList();
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
