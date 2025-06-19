import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:quebragalho2/services/perfil_page_services.dart';
import 'perfil_page_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('PerfilPageService', () {
    late PerfilPageService service;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      service = PerfilPageService();
    });

    test('buscarPerfilUsuario retorna dados do perfil se status 200', () async {
      final usuarioId = 1;
      final jsonResponse = jsonEncode({
        'nome': 'Teste',
        'email': 'teste@exemplo.com',
      });

      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(jsonResponse, 200));

      final result = await service.buscarPerfilUsuario(usuarioId);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['nome'], 'Teste');
    });

    test('removerImagemPerfil retorna true se status 204', () async {
      final usuarioId = 1;

      when(
        mockClient.delete(any),
      ).thenAnswer((_) async => http.Response('', 204));

      final result = await service.removerImagemPerfil(usuarioId);
      expect(result, true);
    });

    test(
      'atualizarPerfilUsuario retorna dados atualizados se status 200',
      () async {
        final usuarioId = 1;
        final dados = {'nome': 'Novo Nome'};
        final responseJson = jsonEncode({'success': true});

        when(
          mockClient.put(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response(responseJson, 200));

        final result = await service.atualizarPerfilUsuario(usuarioId, dados);
        expect(result, isA<Map<String, dynamic>>());
        expect(result?['success'], true);
      },
    );
  });
}
