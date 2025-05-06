import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/servico_model.dart';

void main() {
  group('Servicos Model', () {
    test('fromJson com dados completos', () {
      final json = {
        'id': 1,
        'nome': 'Reparo Elétrico',
        'descricao': 'Reparo de instalações elétricas',
        'preco': 150.0,
        'agendamentos': [{'id': 10}, {'id': 11}],
        'tags': [101, 102],
      };

      final servico = Servicos.fromJson(json);

      expect(servico.id, 1);
      expect(servico.nome, 'Reparo Elétrico');
      expect(servico.descricao, 'Reparo de instalações elétricas');
      expect(servico.preco, 150.0);
      expect(servico.agendamentosIds, [10, 11]);
      expect(servico.tagsIds, [101, 102]);
    });

    test('fromJson com listas vazias', () {
      final json = {
        'id': 2,
        'nome': 'Limpeza',
        'descricao': 'Serviço de limpeza residencial',
        'preco': 100.0,
        'agendamentos': [],
        'tags': [],
      };

      final servico = Servicos.fromJson(json);

      expect(servico.agendamentosIds, isEmpty);
      expect(servico.tagsIds, isEmpty);
    });

    test('toJson', () {
      final servico = Servicos(
        id: 1,
        nome: 'Teste',
        descricao: 'Descrição teste',
        preco: 99.99,
        tagsIds: [101],
      );

      final json = servico.toJson();

      expect(json['id'], 1);
      expect(json['nome'], 'Teste');
      expect(json['preco'], 99.99);
      expect(json['tags'], [101]);
      expect(json.containsKey('agendamentos'), false);
    });

    test('copyWith', () {
      final original = Servicos(
        id: 1,
        nome: 'Original',
        descricao: 'Desc original',
        preco: 100.0,
      );

      final copia = original.copyWith(
        nome: 'Modificado',
        preco: 120.0,
        tagsIds: [101],
      );

      expect(copia.id, 1);
      expect(copia.nome, 'Modificado');
      expect(copia.preco, 120.0);
      expect(copia.tagsIds, [101]);
      expect(copia.agendamentosIds, isEmpty);
    });
  });
}