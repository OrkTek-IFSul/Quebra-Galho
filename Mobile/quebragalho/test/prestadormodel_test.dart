import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/prestador_model.dart';

void main() {
  group('Prestador Model', () {
    test('fromJson com listas completas', () {
      final json = {
        'id': 1,
        'descricao': 'Prestador de serviços elétricos',
        'documentoPath': '/docs/123.pdf',
        'usuarios': [{'id': 10}, {'id': 11}],
        'servico': [101, 102],
        'portfolios': [{'id': 1001}],
        'chats': [2001, 2002],
        'tags': [{'id': 3001}, {'id': 3002}],
      };

      final prestador = Prestador.fromJson(json);

      expect(prestador.id, 1);
      expect(prestador.descricao, 'Prestador de serviços elétricos');
      expect(prestador.documentoPath, '/docs/123.pdf');
      expect(prestador.usuarioIds, [10, 11]);
      expect(prestador.servicosIds, [101, 102]);
      expect(prestador.portfoliosIds, [1001]);
      expect(prestador.chatsIds, [2001, 2002]);
      expect(prestador.tagsIds, [3001, 3002]);
    });

    test('fromJson com listas vazias', () {
      final json = {
        'id': 2,
        'descricao': 'Prestador sem relacionamentos',
        'usuarios': [],
        'servico': [],
        'portfolios': [],
        'chats': [],
        'tags': [],
      };

      final prestador = Prestador.fromJson(json);

      expect(prestador.usuarioIds, isEmpty);
      expect(prestador.servicosIds, isEmpty);
      expect(prestador.portfoliosIds, isEmpty);
      expect(prestador.chatsIds, isEmpty);
      expect(prestador.tagsIds, isEmpty);
    });

    test('toJson', () {
      final prestador = Prestador(
        id: 1,
        descricao: 'Teste',
        servicosIds: [101],
        tagsIds: [301],
      );

      final json = prestador.toJson();

      expect(json['id'], 1);
      expect(json['descricao'], 'Teste');
      expect(json['servico'], [101]);
      expect(json['tags'], [301]);
      expect(json['portfolios'], isEmpty);
    });

    test('copyWith', () {
      final original = Prestador(
        id: 1,
        descricao: 'Original',
        servicosIds: [101],
        tagsIds: [301],
      );

      final copia = original.copyWith(
        descricao: 'Atualizado',
        servicosIds: [101, 102],
      );

      expect(copia.id, 1);
      expect(copia.descricao, 'Atualizado');
      expect(copia.servicosIds, [101, 102]);
      expect(copia.tagsIds, [301]);
    });
  });
}