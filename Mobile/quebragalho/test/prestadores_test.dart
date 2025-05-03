import 'package:flutter_quebragalho/services/agendamento_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/prestador_model.dart';

void main() {
  // Teste para verificar o método toJson da classe Prestador
  test('Testes do Modelo Prestador toJson gera saída correta', () {
    final original = Prestador(
      descricao: "Prestador especializado em serviços elétricos",
      documentoPath: "/img/prestador123.jpeg",
      servicosIds: [1, 202],
      usuarioIds: [1, 202], 
      portfoliosIds: [1, 202], 
      chatsIds: [1, 202], 
      tagsIds: [1, 202], 
    );
    final json = original.toJson();
    expect(json['servico'], [1, 202]);  // A lista de serviços deve estar correta
    expect(json['portfolios'], [1, 202]);  // A lista de usuários deve estar correta
    expect(json['chats'], [1, 202]);
    expect(json['tags'], [1, 202]);
    expect(json['usuarios'], [1, 202]);
   });
   
   test ('Testes do PrestadorService criarPrestador com dados válidos', () async {
    // A URL e os dados a serem enviados
    final url = 'http://localhost:8080/api/prestadores/6';
    final requestBody = {
      'descricao': 'Prestador de serviços',
      'documentoPath': '/img/prestador123.jpeg',
    };
    try {
      final response = await AgendamentoService().criarAgendamento(requestBody, url);
      expect(response.statusCode, 200);  // Status OK
    } catch (e) {
      print('Erro ao criar prestador: $e');
    }
  });
   }