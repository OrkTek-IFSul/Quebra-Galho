import 'package:flutter_quebragalho/services/api_service.dart';
import '../models/resposta_model.dart';

// Classe RespostaService fornece métodos para gerenciar respostas associadas a avaliações.
class RespostaService {
  /// Cria uma resposta para uma avaliação, validando o texto e enviando os dados via API.
  static Future<Resposta> criarResposta({
    required int avaliacaoId,
    required String resposta,
  }) async {
    if (resposta.isEmpty) {
      throw ArgumentError('O texto da resposta não pode ser vazio');
    }

    final response = await ApiService.post(
      '/respostas/$avaliacaoId', // Endpoint para criar resposta.
      body: {
        'resposta': resposta,
        'data': DateTime.now().toIso8601String(),
      },
    );

    return Resposta.fromJson(response);
  }

  /// Busca uma resposta associada a uma avaliação específica pelo ID.
  static Future<Resposta?> getRespostaPorAvaliacao(int avaliacaoId) async {
    try {
      final response = await ApiService.get(
        '/respostas/avaliacao/$avaliacaoId',
      );
      return Resposta.fromJson(response);
    } on NotFoundException {
      return null; // Retorna null se a resposta não for encontrada.
    }
  }

  /// Atualiza o texto de uma resposta existente.
  static Future<Resposta> atualizarResposta({
    required int id,
    required String novaResposta,
  }) async {
    final response = await ApiService.put(
      '/respostas/$id', // Endpoint para atualizar resposta.
      body: {
        'resposta': novaResposta,
        'data': DateTime.now().toIso8601String(),
      },
    );
    return Resposta.fromJson(response);
  }

  /// Remove uma resposta pelo ID.
  static Future<bool> deletarResposta(int id) async {
    return await ApiService.delete(
      '/respostas/$id', // Endpoint para deletar resposta.
    );
  }
}