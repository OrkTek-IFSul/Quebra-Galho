import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quebragalho2/views/cliente/pages/agendamento_page.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets('AgendamentoPage renderiza corretamente', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AgendamentoPage(servico: 'Serviço Teste', servicoId: 1),
      ),
    );

    expect(
      find.text('Serviço Teste'),
      findsNothing,
    ); // se não for exibido direto
    expect(find.byType(ListView), findsWidgets); // onde aparecem os horários
  });

  testWidgets('Seleciona um horário disponível', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AgendamentoPage(servico: 'Serviço Teste', servicoId: 1),
      ),
    );

    await tester.pumpAndSettle(); // espera animaciones y async

    final horario = find.text('09:00');
    expect(horario, findsOneWidget);

    await tester.tap(horario);
    await tester.pump();
  });
}
