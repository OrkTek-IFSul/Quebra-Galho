import 'package:flutter/material.dart';
import 'package:quebragalho2/views/prestador/pages/navegacao_prestador.dart';

Future<void> showMigrarParaPrestadorDialog(BuildContext context, int id_prestador) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Center(
        child: Text(
          'Alterar para Prestador',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      content: const Text(
        'Você deseja migrar para \nmodo prestador?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.transparent),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'NÃO',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            elevation: 0,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'SIM',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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