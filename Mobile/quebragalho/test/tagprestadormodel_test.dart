import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/tag_prestador_model.dart';

void main() {
  group('TagPrestador Model', () {
    test('fromJson com id', () {
      final json = {
        'id': 1,
        'tag': {'id': 10},
        'prestador': {'id': 100},
      };

      final tagPrestador = TagPrestador.fromJson(json);

      expect(tagPrestador.id, 1);
      expect(tagPrestador.tagId, 10);
      expect(tagPrestador.prestadorId, 100);
    });

    test('fromJson sem id', () {
      final json = {
        'tag': 10,
        'prestador': 100,
      };

      final tagPrestador = TagPrestador.fromJson(json);

      expect(tagPrestador.id, isNull);
      expect(tagPrestador.tagId, 10);
      expect(tagPrestador.prestadorId, 100);
    });

    test('toJson', () {
      final tagPrestador = TagPrestador(
        tagId: 10,
        prestadorId: 100,
      );

      final json = tagPrestador.toJson();

      expect(json['tag'], 10);
      expect(json['prestador'], 100);
      expect(json.containsKey('id'), false);
    });

    test('copyWith', () {
      final original = TagPrestador(
        id: 1,
        tagId: 10,
        prestadorId: 100,
      );

      final copia = original.copyWith(
        tagId: 20,
      );

      expect(copia.id, 1);
      expect(copia.tagId, 20);
      expect(copia.prestadorId, 100);
    });
  });
}