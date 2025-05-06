import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/prestador_model.dart';
import 'package:flutter_quebragalho/services/prestador_service.dart';

void main() {
  group('PrestadorService', () {
    late Prestador prestadorCriado;

    test('Deve criar um novo prestador', () async {
      final prestador = Prestador(
        descricao: 'Prestador especializado em serviços elétricos',
        documentoPath: '/img/prestador123.jpeg',
        servicosIds: [1, 202],
        usuarioIds: [1, 202],
        portfoliosIds: [1, 202],
        chatsIds: [1, 202],
        tagsIds: [1, 202],
      );

      prestadorCriado = await PrestadorService.criarPrestador(prestador.toJson(), 'http://localhost:8080/api/prestadores');

      expect(prestadorCriado.id, isNotNull);
      expect(prestadorCriado.descricao, equals('Prestador especializado em serviços elétricos'));
    });

    test('Deve buscar todos os prestadores', () async {
      final prestadores = await PrestadorService.getPrestadores();

      expect(prestadores, isA<List<Prestador>>());
      expect(prestadores.length, greaterThan(0));
    });

    test('Deve buscar um prestador pelo ID', () async {
      final prestador = await PrestadorService.getPrestador(prestadorCriado.id!);

      expect(prestador.id, equals(prestadorCriado.id));
      expect(prestador.descricao, equals(prestadorCriado.descricao));
    });

    test('Deve atualizar um prestador', () async {
      final prestadorAtualizado = Prestador(
        id: prestadorCriado.id,
        descricao: 'Prestador atualizado em serviços de TI',
        documentoPath: '/img/prestador_updated.jpeg',
        servicosIds: [1, 303],
        usuarioIds: [1, 303],
        portfoliosIds: [2, 303],
        chatsIds: [2, 303],
        tagsIds: [2, 303],
      );

      final resultado = await PrestadorService.atualizarPrestador(prestadorCriado.id!, prestadorAtualizado.toJson(), 'http://localhost:8080/api/prestadores/${prestadorCriado.id}');

      expect(resultado.descricao, equals('Prestador atualizado em serviços de TI'));
      expect(resultado.servicosIds, equals([1, 303]));
      expect(resultado.usuarioIds, equals([1, 303]));
    });

    test('Deve deletar um prestador', () async {
      try {
        await PrestadorService.deletarPrestador(prestadorCriado.id!);
        final prestadorDeletado = await PrestadorService.getPrestador(prestadorCriado.id!);
        fail('O prestador deveria ter sido deletado');
      } catch (e) {
        expect(e.toString(), contains('Erro ao carregar prestador'));
      }
    });
  });
}
