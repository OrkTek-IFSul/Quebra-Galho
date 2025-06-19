import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/views/cliente/pages/cadastro_page.dart';

import 'cadastro_page_submit_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  testWidgets('Envía formulario de cadastro y muestra SnackBar si exitoso', (
    tester,
  ) async {
    final mockClient = MockClient();

    when(
      mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => http.Response('{}', 201));

    await tester.pumpWidget(MaterialApp(home: CadastroPage()));

    await tester.pumpAndSettle();

    // Rellenar campos obligatorios (ajustar índices según orden real)
    await tester.enterText(find.byType(TextFormField).at(0), 'Nombre Test');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'correo@prueba.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '(99) 99999-9999');
    await tester.enterText(find.byType(TextFormField).at(3), '123.456.789-00');
    await tester.enterText(find.byType(TextFormField).at(4), 'password123');
    await tester.enterText(find.byType(TextFormField).at(5), 'password123');

    // Presiona el botón de registrar
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pump();

    // Verifica que se muestra SnackBar o algo parecido (ajustar según tu lógica)
    expect(
      find.byType(SnackBar),
      findsOneWidget,
    ); // O: expect(find.text('Registro exitoso'), findsOneWidget);
  });
}
