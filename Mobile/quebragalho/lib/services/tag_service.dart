import 'package:flutter_quebragalho/services/api_service.dart';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';
import '../models/tag_model.dart';

class TagService {
  static Future<Tags> atualizarStatusTag({
    required int id,
    required String novoStatus,
  }) async {
    if (novoStatus != 'Ativo' && novoStatus != 'Inativo') {
      throw ArgumentError('Status deve ser "Ativo" ou "Inativo"');
    }

    final response = await ApiService.put(
      ApiEndpoints.atualizarStatusTag(id),
      body: {'status': novoStatus},
    );
    return Tags.fromJson(response);
  }

  static Future<List<Tags>> getTags() async {
    final response = await ApiService.get(ApiEndpoints.getTags);
    return (response as List).map((json) => Tags.fromJson(json)).toList();
  }

  static Future<Tags> criarTag({
    required String nome,
    String status = 'Ativo',
  }) async {
    final response = await ApiService.post(
      ApiEndpoints.criarTag,
      body: {
        'nome': nome,
        'status': status,
      },
    );
    return Tags.fromJson(response);
  }
}