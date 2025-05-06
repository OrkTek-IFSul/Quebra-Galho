import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/tag_model.dart';
import 'package:flutter_quebragalho/services/tag_service.dart';

void main() {
  group('TagService', () {
    late Tag tagCriada;

    test('Deve criar uma nova tag', () async {
      final tag = Tag(nome: 'Tag Unitario 2', status: 'Ativo');
      tagCriada = await TagService.criarTag(tag);

      expect(tagCriada.id, isNotNull);
      expect(tagCriada.nome, equals('Tag Unitario 2'));
    });

    test('Deve buscar todas as tags', () async {
      final tags = await TagService.getTodasTags();

      expect(tags, isA<List<Tag>>());
      expect(tags.length, greaterThan(0));
    });

    test('Deve buscar uma tag pelo ID', () async {
      final tag = await TagService.getTag(tagCriada.id!);

      expect(tag.id, equals(tagCriada.id));
      expect(tag.nome, equals(tagCriada.nome));
    });;

    test('Deve atualizar uma tag', () async {
      final tagAtualizada = Tag(id: tagCriada.id, nome: 'Tag Atualizada', status: 'Ativo');
      final resultado = await TagService.atualizarTag(tagAtualizada.id!, tagAtualizada);

      expect(resultado.nome, equals('Tag Atualizada'));
    });
  });
}
