import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/tag_prestador_model.dart';
import 'package:flutter_quebragalho/services/tag_prestador_service.dart';
import 'package:http/http.dart' as http;

void main() {
  group('TagPrestadorService (API Real)', () {
    late TagPrestadorService service;
    const tagIdTeste = 1;
    const prestadorIdTeste = 1;
    late int relacaoIdCriada;

    setUp(() {
      service = TagPrestadorService();
    });

    test('1. Adicionar tag a prestador', () async {
      final data = {
        'tag': tagIdTeste,
        'prestador': prestadorIdTeste,
      };

      final resultado = await service.atualizarTagPrestador(
        data,
        'http://localhost:8080/api/tag-prestador/$tagIdTeste/$prestadorIdTeste',
      );
      
      expect(resultado.tagId, tagIdTeste);
      expect(resultado.prestadorId, prestadorIdTeste);
      expect(resultado.id, isNotNull);
      relacaoIdCriada = resultado.id!;
    });

    test('2. Listar tags de um prestador', () async {
      final tags = await TagPrestadorService.getTagPrestador(prestadorIdTeste);
      
      expect(tags, isA<List<int>>());
      expect(tags, contains(tagIdTeste));
    });

    test('3. Remover tag de prestador', () async {
      await expectLater(
        TagPrestadorService.deletarTagPrestador(
          tagId: tagIdTeste,
          prestadorId: prestadorIdTeste,
        ),
        completes,
      );
    });

    test('Deve lançar erro ao adicionar tag inválida', () async {
      final data = {
        'tag': 9999, // ID inválido
        'prestador': prestadorIdTeste,
      };

      expect(
        () => service.atualizarTagPrestador(
          data,
          'http://localhost:8080/api/tag-prestador/9999/$prestadorIdTeste',
        ),
        throwsException,
      );
    });

    test('Deve lançar erro ao remover relação inexistente', () async {
      expect(
        () => TagPrestadorService.deletarTagPrestador(
          tagId: 9999,
          prestadorId: 9999,
        ),
        throwsException,
      );
    });
  });
}