import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/models/prestador_model.dart';
import 'package:flutter_quebragalho/services/prestador_service.dart';
import 'package:http/http.dart' as http;

void main() {
  group('PrestadorService (API Real)', () {
    late int prestadorIdCriado;

    setUpAll(() async {
      // Configuração inicial se necessário
    });

    test('1. Criar prestador', () async {
      final data = {
        'descricao': 'Prestador de Teste',
        'usuarios': [1], // ID de usuário existente
      };

      final prestador = await PrestadorService.criarPrestador(
        data,
        'http://localhost:8080/api/prestadores/1', // Assumindo que o endpoint é /prestadores/{usuarioId}
      );
      
      expect(prestador.id, isNotNull);
      expect(prestador.descricao, 'Prestador de Teste');
      prestadorIdCriado = prestador.id!;
    });

    test('2. Buscar prestador por ID', () async {
      final prestador = await PrestadorService.getPrestador(prestadorIdCriado);
      
      expect(prestador.id, prestadorIdCriado);
      expect(prestador.descricao, isNotEmpty);
    });

    test('3. Listar todos os prestadores', () async {
      final prestadores = await PrestadorService.getPrestadores();
      
      expect(prestadores, isA<List<Prestador>>());
      expect(prestadores.length, greaterThan(0));
    });

    test('4. Atualizar prestador', () async {
      final data = {
        'descricao': 'Prestador Atualizado',
        'usuarios': [1],
      };

      final prestadorAtualizado = await PrestadorService.atualizarPrestador(
        prestadorIdCriado,
        data,
        'http://localhost:8080/api/prestadores/$prestadorIdCriado',
      );

      expect(prestadorAtualizado.descricao, 'Prestador Atualizado');
    });

    test('5. Deletar prestador', () async {
      await expectLater(
        PrestadorService.deletarPrestador(prestadorIdCriado),
        completes,
      );
    });

    test('Deve lançar erro ao criar prestador sem descrição', () async {
      final data = {
        'usuarios': [1],
      };

      expect(
        () => PrestadorService.criarPrestador(
          data, 
          'http://localhost:8080/api/prestadores/1'
        ),
        throwsException,
      );
    });
  });
}