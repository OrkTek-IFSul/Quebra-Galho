import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/avaliacao_model.dart';
import 'package:flutter_quebragalho/models/resposta_model.dart';

void main() {
  group('Avaliacao Model', () {
    test('fromJson com resposta', () {
      final json = {
        'id': 1,
        'nota': 5,
        'comentario': 'Ótimo serviço!',
        'data': '2023-01-01T00:00:00.000Z',
        'agendamento': {'id': 10},
        'resposta': {
          'id': 1,
          'mensagem': 'Obrigado pelo feedback!',
          'data': '2023-01-02T00:00:00.000Z'
        }
      };

      final avaliacao = Avaliacao.fromJson(json);

      expect(avaliacao.id, 1);
      expect(avaliacao.nota, 5);
      expect(avaliacao.comentario, 'Ótimo serviço!');
      expect(avaliacao.agendamentoId, 10);
      expect(avaliacao.resposta, isA<Resposta>());
    });

    test('fromJson sem resposta', () {
      final json = {
        'id': 1,
        'nota': 4,
        'comentario': 'Bom serviço',
        'data': '2023-01-01T00:00:00.000Z',
        'agendamento': 10
      };

      final avaliacao = Avaliacao.fromJson(json);

      expect(avaliacao.resposta, isNull);
    });

    test('toJson', () {
      final avaliacao = Avaliacao(
        id: 1,
        nota: 5,
        comentario: 'Teste',
        data: DateTime(2023),
        agendamentoId: 10,
      );

      final json = avaliacao.toJson();

      expect(json['nota'], 5);
      expect(json['comentario'], 'Teste');
      expect(json['agendamento'], 10);
    });

    test('copyWith', () {
      final original = Avaliacao(
        id: 1,
        nota: 3,
        comentario: 'Original',
        data: DateTime(2023),
        agendamentoId: 10,
      );

      final copia = original.copyWith(
        nota: 5,
        comentario: 'Atualizado',
      );

      expect(copia.id, 1);
      expect(copia.nota, 5);
      expect(copia.comentario, 'Atualizado');
      expect(copia.agendamentoId, 10);
    });

    test('_validarNota com erro', () {
      expect(() => Avaliacao._validarNota(0), throwsArgumentError);
      expect(() => Avaliacao._validarNota(6), throwsArgumentError);
      expect(() => Avaliacao._validarNota('abc'), throwsFormatException);
    });
  });
}