import 'package:flutter/material.dart';
import 'package:quebragalho2/views/prestador/pages/navegacao_prestador.dart';

Future<void> showMigrarParaPrestadorDialog(BuildContext context, int id_prestador) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Alterar para Prestador'),
      content: const Text('Você deseja alterar para modo prestador?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('NÃO'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('SIM'),
        ),
      ],
    ),
  );

  if (result == true) {
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => NavegacaoPrestador(id_prestador: id_prestador),
        ),
        (route) => false,
      );
    }
  }
}