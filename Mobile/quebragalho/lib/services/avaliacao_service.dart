import 'package:flutter_quebragalho/services/api_service.dart';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';
import '../models/avaliacao_model.dart';

// Classe AvaliacaoService fornece métodos para gerenciar avaliações, como criar, listar, deletar e responder.
class AvaliacaoService {
  // Cria uma nova avaliação para um agendamento, validando a nota e enviando os dados via API.
  static Future<Avaliacao> criarAvaliacao({
    required int agendamentoId,
    required int nota,
    required String comentario,
  }) async {
    if (nota < 1 || nota > 5) {
      throw ArgumentError('A nota deve estar entre 1 e 5');
    }

    final response = await ApiService.post(
      ApiEndpoints.criarAvaliacao(agendamentoId),
      body: {
        'nota': nota,
        'comentario': comentario,
        'data': DateTime.now().toIso8601String(),
      },
    );
    return Avaliacao.fromJson(response);
  }

  // Obtém uma lista de avaliações associadas a um serviço específico.
  static Future<List<Avaliacao>> getAvaliacoesPorServico(int servicoId) async {
    final response = await ApiService.get(
      ApiEndpoints.getAvaliacoesServico(servicoId),
    );
    return (response as List).map((e) => Avaliacao.fromJson(e)).toList();
  }

  // Deleta uma avaliação específica pelo ID.
  static Future<bool> deletarAvaliacao(int id) async {
    return await ApiService.delete(
      ApiEndpoints.deletarAvaliacao(id),
    );
  }

  // Responde a uma avaliação específica, enviando a resposta via API.
  static Future<Avaliacao> responderAvaliacao({
    required int avaliacaoId,
    required String resposta,
  }) async {
    final response = await ApiService.post(
      '/avaliacoes/$avaliacaoId/resposta',
      body: {
        'resposta': resposta,
        'data': DateTime.now().toIso8601String(),
      },
    );
    return Avaliacao.fromJson(response);
  }
}