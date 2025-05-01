import 'package:flutter_quebragalho/services/api_service.dart';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';

import '../models/servico_model.dart';

class ServicoService {
  /// Atualiza um serviço existente
  static Future<Servicos> atualizarServico(int id, Servicos servico) async {
    final response = await ApiService.put(
      ApiEndpoints.atualizarServico(id),
      body: servico.toJson(),
    );
    return Servicos.fromJson(response);
  }

  /// Remove um serviço
  static Future<bool> deletarServico(int id) async {
    return await ApiService.delete(ApiEndpoints.deletarServico(id));
  }

  /// Cria um novo serviço para um prestador
  static Future<Servicos> criarServico(int prestadorId, Servicos servico) async {
    if (servico.preco <= 0) {
      throw ArgumentError('O preço deve ser maior que zero');
    }

    final response = await ApiService.post(
      ApiEndpoints.criarServico(prestadorId),
      body: servico.toJson(),
    );
    return Servicos.fromJson(response);
  }

  /// Lista todos os serviços
  static Future<List<Servicos>> getTodosServicos() async {
    final response = await ApiService.get(ApiEndpoints.getServicos);
    return (response as List).map((json) => Servicos.fromJson(json)).toList();
  }

  /// Lista serviços por prestador
  static Future<List<Servicos>> getServicosPorPrestador(int prestadorId) async {
    final response = await ApiService.get(
      ApiEndpoints.getServicosPorPrestador(prestadorId),
    );
    return (response as List).map((json) => Servicos.fromJson(json)).toList();
  }
}