import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:quebragalho2/services/agendamento_page_services.dart';
import 'agendamento_page_service_test.mocks.dart'; // Archivo generado por build_runner

@GenerateMocks([http.Client])
void main() {
  group('AgendamentoPageService', () {
    late AgendamentoPageService service;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      service = AgendamentoPageService(
        client: mockClient,
      ); // Asegurate de pasar el client al service
    });

    test(
      'retorna lista de horários indisponíveis se a resposta for 200',
      () async {
        final servicoId = 1;
        final horariosJson = jsonEncode([
          "2025-06-20T10:00:00.000",
          "2025-06-20T11:00:00.000",
        ]);

        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response(horariosJson, 200));

        final result = await service.listarHorariosIndisponiveis(servicoId);

        expect(result, isA<List<DateTime>>());
        expect(result.length, 2);
      },
    );

    test('lança exceção se a resposta for diferente de 200', () async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('Erro', 500));

      expect(() => service.listarHorariosIndisponiveis(1), throwsException);
    });
  });
}
