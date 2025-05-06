import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/servico_model.dart';
import 'package:flutter_quebragalho/services/servico_service.dart';
import 'package:http/http.dart' as http;

void main() {
  group('ServicoService (API Real)', () {
    late int servicoIdCriado;
    const prestadorIdTeste = 1; // ID de prestador existente

    setUpAll(() async {
      // Configuração inicial se necessário
    });

    test('1. Criar serviço', () async {
      final data = {
        'nome': 'Serviço de Teste',
        'descricao': 'Descrição do serviço teste',
        'preco': 99.99,
      };

      final response = await ServicoService.criarServico(
        data,
        'http://localhost:8080/api/servicos/$prestadorIdTeste',
      );
      
      expect(response.statusCode, 200);
      
      final responseData = jsonDecode(response.body);
      servicoIdCriado = responseData['id'];
      expect(servicoIdCriado, isNotNull);
    });

    test('2. Listar todos os serviços', () async {
      final servicos = await ServicoService.getTodosServicos();
      
      expect(servicos, isA<List<Servicos>>());
      expect(servicos.length, greaterThan(0));
    });

    test('3. Atualizar serviço', () async {
      final servicoAtualizado = Servicos(
        id: servicoIdCriado,
        nome: 'Serviço Atualizado',
        descricao: 'Nova descrição',
        preco: 120.0,
      );

      final resultado = await ServicoService.atualizarServico(
        servicoIdCriado, 
        servicoAtualizado
      );

      expect(resultado.nome, 'Serviço Atualizado');
      expect(resultado.preco, 120.0);
    });

    test('4. Deletar serviço', () async {
      final resultado = await ServicoService.deletarServico(servicoIdCriado);
      expect(resultado, isTrue);
    });

    test('Deve lançar erro ao criar serviço sem nome', () async {
      final data = {
        'descricao': 'Descrição sem nome',
        'preco': 50.0,
      };

      expect(
        () => ServicoService.criarServico(
          data, 
          'http://localhost:8080/api/servicos/$prestadorIdTeste'
        ),
        throwsException,
      );
    });
  });
}