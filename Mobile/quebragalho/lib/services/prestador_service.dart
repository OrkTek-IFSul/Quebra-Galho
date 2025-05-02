import 'package:flutter_quebragalho/services/api_service.dart';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';
import '../models/prestador_model.dart';

class PrestadorService {
  /// Busca um prestador por ID
  static Future<Prestador> getPrestador(int id) async {
    final response = await ApiService.get(ApiEndpoints.getPrestador(id));
    return Prestador.fromJson(response);
  }

  /// Lista todos os prestadores
  static Future<List<Prestador>> getPrestadores() async {
    final response = await ApiService.get(ApiEndpoints.getPrestadores);
    return (response as List).map((json) => Prestador.fromJson(json)).toList();
  }

  /// Cria um novo prestador associado a um usuário
  static Future<Prestador> criarPrestador(int usuarioId, Prestador prestador) async {
    final response = await ApiService.post(
      ApiEndpoints.criarPrestador(usuarioId),
      body: prestador.toJson(),
    );
    return Prestador.fromJson(response);
  }

  /// Atualiza um prestador existente
  static Future<Prestador> atualizarPrestador(int id, Prestador prestador) async {
    final response = await ApiService.put(
      ApiEndpoints.atualizarPrestador(id),
      body: prestador.toJson(),
    );
    return Prestador.fromJson(response);
  }

  /// Remove um prestador
  static Future<void> deletarPrestador(int id) async {
    await ApiService.delete(ApiEndpoints.deletarPrestador(id));
  }
}