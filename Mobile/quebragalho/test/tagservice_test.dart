import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/tag_model.dart';
import 'package:flutter_quebragalho/services/tag_service.dart';
import 'package:http/http.dart' as http;

void main() {
  group('TagService (API Real)', () {
    late int tagIdCriada;

    setUpAll(() async {
      // Configuração inicial se necessário
    });

    test('1. Criar tag', () async {
      final tag = await TagService.criarTag(
        nome: 'Tag Teste',
        status: 'Ativo',
      );
      
      expect(tag.id, isNotNull);
      expect(tag.nome, 'Tag Teste');
      expect(tag.status, 'Ativo');
      tagIdCriada = tag.id!;
    });

    test('2. Listar todas as tags', () async {
      final tags = await TagService.getTags();
      
      expect(tags, isA<List<Tags>>());
      expect(tags.length, greaterThan(0));
    });

    test('3. Atualizar status da tag', () async {
      final tagAtualizada = await TagService.atualizarStatusTag(
        id: tagIdCriada,
        novoStatus: 'Inativo',
      );

      expect(tagAtualizada.status, 'Inativo');
    });

    test('4. Deletar tag', () async {
      await expectLater(
        TagService.deletarTag(tagIdCriada),
        completes,
      );
    });

    test('Deve lançar erro ao criar tag sem nome', () async {
      expect(
        () => TagService.criarTag(nome: '', status: 'Ativo'),
        throwsException,
      );
    });

    test('Deve lançar erro ao atualizar com status inválido', () async {
      expect(
        () => TagService.atualizarStatusTag(
          id: tagIdCriada,
          novoStatus: 'Inválido',
        ),
        throwsArgumentError,
      );
    });
  });
}