import 'package:flutter_quebragalho/services/api_service.dart';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';
import '../models/tag_prestador_model.dart';

class TagPrestadorService {
  /// Adiciona uma tag a um prestador
  static Future<TagPrestador> atualizarTagPrestador({
    required int tagId,
    required int prestadorId,
  }) async {
    final response = await ApiService.post(
      ApiEndpoints.atualizarTagPrestador(tagId, prestadorId),
    );
    return TagPrestador.fromJson(response);
  }

  /// Remove uma tag de um prestador
  static Future<bool> deletarTagPrestador({
    required int tagId,
    required int prestadorId,
  }) async {
    await ApiService.delete(
      ApiEndpoints.deletarTagPrestador(tagId, prestadorId),
    );
    return true;
  }

  /// Lista tags de um prestador
  static Future<List<int>> getTagPrestador(int prestadorId) async {
    final response = await ApiService.get(
      ApiEndpoints.getTagPrestador(prestadorId),
    );
    return (response as List).map((id) => id as int).toList();
  }
}