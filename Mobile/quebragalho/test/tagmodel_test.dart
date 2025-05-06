import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/tag_model.dart';

void main() {
  group('Tags Model', () {
    test('fromJson com dados completos', () {
      final json = {
        'id': 1,
        'nome': 'Elétrica',
        'status': 'Ativo',
        'prestadores': [{'id': 10}, {'id': 11}],
        'servicos': [101, 102],
      };

      final tag = Tags.fromJson(json);

      expect(tag.id, 1);
      expect(tag.nome, 'Elétrica');
      expect(tag.status, 'Ativo');
      expect(tag.prestadoresIds, [10, 11]);
      expect(tag.servicosIds, [101, 102]);
    });

    test('fromJson com listas vazias', () {
      final json = {
        'id': 2,
        'nome': 'Hidráulica',
        'status': 'Inativo',
        'prestadores': [],
        'servicos': [],
      };

      final tag = Tags.fromJson(json);

      expect(tag.prestadoresIds, isEmpty);
      expect(tag.servicosIds, isEmpty);
    });

    test('toJson', () {
      final tag = Tags(
        id: 1,
        nome: 'Teste',
        status: 'Ativo',
        prestadoresIds: [10],
      );

      final json = tag.toJson();

      expect(json['nome'], 'Teste');
      expect(json['status'], 'Ativo');
      expect(json['prestadores'], [10]);
      expect(json.containsKey('servicos'), false);
    });

    test('copyWith', () {
      final original = Tags(
        id: 1,
        nome: 'Original',
        status: 'Ativo',
      );

      final copia = original.copyWith(
        nome: 'Modificado',
        status: 'Inativo',
        servicosIds: [101],
      );

      expect(copia.id, 1);
      expect(copia.nome, 'Modificado');
      expect(copia.status, 'Inativo');
      expect(copia.servicosIds, [101]);
      expect(copia.prestadoresIds, isEmpty);
    });
  });
}