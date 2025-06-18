import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quebragalho2/views/cliente/pages/agendamento_page.dart';

void main() {
  testWidgets('Renderiza AgendamentoPage con horarios', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AgendamentoPage(servico: 'Teste Serviço', servicoId: 1),
      ),
    );

    await tester.pumpAndSettle();

    // Verifica que se muestre el nombre del servicio
    expect(find.text('Teste Serviço'), findsOneWidget);

    // Busca algún horario de ejemplo
    expect(
      find.text('08:00'),
      findsWidgets,
    ); // Puede cambiar según implementación

    // Simula selección de horario
    await tester.tap(find.text('08:00').first);
    await tester.pump();

    // Botón confirmar debería estar presente
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
