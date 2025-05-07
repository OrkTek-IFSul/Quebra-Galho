import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/services/portfolio_service.dart';

void main() {
  // Teste para o método 'criarPortfolioItem'
  test('Testes do PortfolioService criarPortfolioItem com dados válidos', () async {
    final url = 'http://localhost:8080/api/portfolio/2';  // URL para o prestador de ID 1
    final requestBody = {
      'file': 'C:/Users/jeanc/Downloads/indoali.png',  // Caminho da imagem a ser enviada
    };

    try {
      final response = await PortfolioService().criarPortfolioItem(requestBody, url);

      // Verifique se a resposta tem o status 201 (Criado com sucesso)
      expect(response.statusCode, 201);  // Ou use o código de status correto que seu servidor retorna

    } catch (e) {
      print('Erro ao criar item do portfólio: $e');
    }
  });
}
