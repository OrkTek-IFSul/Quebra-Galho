import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quebragalho2/views/cliente/pages/cadastro_page.dart';

void main() {
  testWidgets('CadastroPage muestra tabs y valida formulario', (
    WidgetTester tester,
  ) async {
    // Renderiza la página
    await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

    await tester.pumpAndSettle();

    // Verifica que los tabs existen
    expect(find.text('Cliente'), findsOneWidget);
    expect(find.text('Prestador'), findsOneWidget);

    // Cambia al tab "Prestador"
    await tester.tap(find.text('Prestador'));
    await tester.pumpAndSettle();

    // Verifica que campos comunes existen
    expect(find.byType(TextFormField), findsWidgets);
    expect(find.text('Email'), findsOneWidget); // asumiendo que hay un label

    // Intenta enviar con formulario vacío
    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsWidgets);

    await tester.tap(buttonFinder.first);
    await tester.pump();

    // Verifica que haya errores de validación visibles
    expect(
      find.textContaining('campo obrigatório'),
      findsWidgets,
    ); // depende del texto exacto

    // Rellena algunos campos (ejemplo)
    await tester.enterText(find.byType(TextFormField).at(0), 'Usuario Teste');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'usuario@teste.com',
    );

    // Vuelve a presionar el botón
    await tester.tap(buttonFinder.first);
    await tester.pump();
  });
}
