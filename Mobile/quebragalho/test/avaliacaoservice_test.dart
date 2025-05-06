import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/avaliacao_model.dart';
import 'package:flutter_quebragalho/services/avaliacao_service.dart';
import 'package:http/http.dart' as http;

void main() {
  group('AvaliacaoService (API Real)', () {
    late AvaliacaoService service;
    late int avaliacaoIdCriada;

    setUp(() {
      service = AvaliacaoService();
    });

    test('1. Criar avaliação', () async {
      final data = {
        'nota': 5,
        'comentario': 'Teste integração',
        'data': DateTime.now().toIso8601String(),
        'agendamento': 1, // ID de agendamento existente
      };

      final response = await service.criarAvaliacao(data, 'http://localhost:8080/api/avaliacoes/1');
      
      expect(response.statusCode, 200);
      
      final responseData = jsonDecode(response.body);
      avaliacaoIdCriada = responseData['id'];
      expect(avaliacaoIdCriada, isNotNull);
    });

    test('2. Buscar avaliações por serviço', () async {
      final servicoId = 1; // ID de serviço existente
      final avaliacoes = await AvaliacaoService.getAvaliacoesPorServico(servicoId);
      
      expect(avaliacoes, isA<List<Avaliacao>>());
      expect(avaliacoes.length, greaterThan(0));
    });

    test('3. Responder avaliação', () async {
      final data = {
        'mensagem': 'Resposta teste',
        'data': DateTime.now().toIso8601String(),
      };

      final response = await service.responderAvaliacao(data, avaliacaoIdCriada);
      expect(response.statusCode, 200);
    });

    test('4. Deletar avaliação', () async {
      await expectLater(
        AvaliacaoService.deletarAvaliacao(avaliacaoIdCriada),
        completes,
      );
    });

    test('Deve lançar erro para nota inválida', () async {
      final data = {
        'nota': 6, // Nota inválida
        'comentario': 'Teste',
        'data': DateTime.now().toIso8601String(),
        'agendamento': 1,
      };

      expect(
        () => service.criarAvaliacao(data, 'http://localhost:8080/api/avaliacoes/1'),
        throwsArgumentError,
      );
    });
  });
}