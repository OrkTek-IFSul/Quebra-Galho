import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/resposta_model.dart';
import 'package:intl/intl.dart';

void main() {
  group('Resposta Model', () {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

    test('fromJson com dados completos', () {
      final json = {
        'id': 1,
        'resposta': 'Resposta teste',
        'data': formattedDate,
        'avaliacao': [{'id': 10}, {'id': 11}],
      };

      final resposta = Resposta.fromJson(json);

      expect(resposta.id, 1);
      expect(resposta.resposta, 'Resposta teste');
      expect(resposta.avaliacaoIds, [10, 11]);
    });

    test('fromJson com lista de avaliações vazia', () {
      final json = {
        'id': 2,
        'resposta': 'Outra resposta',
        'data': formattedDate,
        'avaliacao': [],
      };

      final resposta = Resposta.fromJson(json);

      expect(resposta.avaliacaoIds, isEmpty);
    });

    test('toJson', () {
      final resposta = Resposta(
        id: 1,
        resposta: 'Teste toJson',
        data: now,
        avaliacaoIds: [10, 11],
      );

      final json = resposta.toJson();

      expect(json['id'], 1);
      expect(json['resposta'], 'Teste toJson');
      expect(json['avaliacao'], [10, 11]);
    });

    test('copyWith', () {
      final original = Resposta(
        id: 1,
        resposta: 'Original',
        data: now,
        avaliacaoIds: [10],
      );

      final copia = original.copyWith(
        resposta: 'Modificada',
        avaliacaoIds: [10, 11],
      );

      expect(copia.id, 1);
      expect(copia.resposta, 'Modificada');
      expect(copia.avaliacaoIds, [10, 11]);
    });
  });
}