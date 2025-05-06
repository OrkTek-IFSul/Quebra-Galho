import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/resposta_model.dart';
import 'package:flutter_quebragalho/services/resposta_service.dart';
import 'package:http/http.dart' as http;

void main() {
  group('RespostaService (API Real)', () {
    late int respostaIdCriada;
    const avaliacaoIdTeste = 1; // ID de uma avaliação existente

    setUpAll(() async {
      // Configuração inicial se necessário
    });

    test('1. Criar resposta', () async {
      final data = {
        'resposta': 'Resposta de teste',
        'data': DateTime.now().toIso8601String(),
      };

      final response = await RespostaService.criarResposta(
        data,
        'http://localhost:8080/api/respostas/$avaliacaoIdTeste',
      );
      
      expect(response.statusCode, 200);
      
      final responseData = jsonDecode(response.body);
      respostaIdCriada = responseData['id'];
      expect(respostaIdCriada, isNotNull);
    });

    test('2. Buscar resposta por avaliação', () async {
      final resposta = await RespostaService.getRespostaPorAvaliacao(avaliacaoIdTeste);
      
      expect(resposta, isNotNull);
      expect(resposta?.resposta, isNotEmpty);
    });

    test('3. Atualizar resposta', () async {
      const novaResposta = 'Resposta atualizada';
      final respostaAtualizada = await RespostaService.atualizarResposta(
        id: respostaIdCriada,
        novaResposta: novaResposta,
      );

      expect(respostaAtualizada.resposta, novaResposta);
    });

    test('4. Listar respostas por avaliação', () async {
      final respostas = await RespostaService.getRespostasPorAvaliacao(avaliacaoIdTeste);
      
      expect(respostas, isA<List<Resposta>>());
      expect(respostas.length, greaterThan(0));
    });

    test('5. Deletar resposta', () async {
      await expectLater(
        RespostaService.deletarResposta(respostaIdCriada),
        completes,
      );
    });

    test('Deve retornar null para avaliação sem resposta', () async {
      final resposta = await RespostaService.getRespostaPorAvaliacao(9999); // ID inexistente
      expect(resposta, isNull);
    });
  });
}