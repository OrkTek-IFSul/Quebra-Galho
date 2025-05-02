import 'package:flutter_quebragalho/services/agendamento_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/agendamento_model.dart';  // Certifique-se de importar seu modelo Agendamento

void main() {
  // Teste para verificar o método toJson da classe Agendamento
  test('Testes do Modelo Agendamento toJson gera saída correta', () {
    // Criando um objeto Agendamento com todos os parâmetros necessários
    final original = Agendamento(
      id: 1,
      dataHora: DateTime.parse("2025-05-10T14:30:00"),
      status: true,
      servicoIds: [105, 106],  // Lista de IDs de serviços
      usuarioIds: [201, 202],  // Lista de IDs de usuários
      avaliacaoIds: [],        // Lista de avaliações (pode ser vazia ou com valores)
    );

    // Chamando o método toJson para transformar o objeto em JSON
    final json = original.toJson();

    // Verificando se os valores estão corretos
    expect(json['servico'], [105, 106]);  // A lista de serviços deve estar correta
    expect(json['usuario'], [201, 202]);  // A lista de usuários deve estar correta
    expect(json['avaliacao'], []);        // A lista de avaliações deve ser vazia (ou o valor correto se tiver)
  });

  // Teste para o método criarAgendamento da classe AgendamentoService
  test('Testes do AgendamentoService criarAgendamento com dados válidos', () async {
    // A URL e os dados a serem enviados
    final url = 'http://localhost:8080/api/agendamentos?servicoId=3&usuarioId=1';
    final requestBody = {
      'dataHora': '2025-05-10T14:30:00',
      'status': true,
    };

    // Simulando a criação do agendamento, e esperando a resposta da API
    try {
      final response = await AgendamentoService().criarAgendamento(requestBody, url);

      // Verificando se a resposta é bem-sucedida
      expect(response.statusCode, 200);  // Status OK
    } catch (e) {
      print('Erro ao criar agendamento: $e');
    }
  });
}
