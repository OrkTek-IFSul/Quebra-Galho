import 'package:flutter/material.dart';

class ServicoCancelarModal extends StatelessWidget {
  final VoidCallback onConfirm;

  const ServicoCancelarModal({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Cancelar Serviço',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: Text(
        'Você tem certeza que deseja cancelar esse serviço?',
        style: TextStyle(color: Colors.black87),
      ),
      actions: [
        SizedBox(
          width: double.infinity, // Expande o botão para ocupar toda a largura
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8,
                ), // Diminui os cantos arredondados
              ),
            ),
            child: Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
