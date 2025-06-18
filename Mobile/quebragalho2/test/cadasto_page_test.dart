import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quebragalho2/views/cliente/pages/cadastro_page.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  testWidgets('CadastroPage renderiza correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

    // Verifica que hay un TabBar con dos pestañas
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.text('Cliente'), findsOneWidget);
    expect(find.text('Prestador'), findsOneWidget);

    // Verifica que hay campos de texto típicos del formulario
    expect(find.byType(TextFormField), findsWidgets);
  });

  testWidgets('CadastroPage cambia de pestaña correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

    final tabFinder = find.byType(TabBar);
    expect(tabFinder, findsOneWidget);

    // Hace scroll a la segunda pestaña
    await tester.tap(find.text('Prestador'));
    await tester.pumpAndSettle();

    // Aquí podrías verificar que algún campo solo visible en la pestaña Prestador está presente
  });

  testWidgets('CadastroPage permite ingresar texto', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

    // Encuentra los campos por tipo
    final emailField = find
        .byType(TextFormField)
        .at(0); // Podés usar find.byKey si les ponés Key

    await tester.enterText(emailField, 'test@example.com');
    expect(find.text('test@example.com'), findsOneWidget);
  });
}
