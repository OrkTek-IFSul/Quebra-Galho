import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/notificationConfirmService.dart'; // Importe a nova tela

class ServicoConfirmarModal extends StatelessWidget {
  final VoidCallback onConfirm;

  const ServicoConfirmarModal({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirmar Serviço',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: Text(
        'Você tem certeza que deseja agendar esse serviço?',
        style: TextStyle(color: Colors.black87),
      ),
      actions: [
        SizedBox(
          width: double.infinity, // Expande o botão para ocupar toda a largura
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o modal
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationConfirmService(),
                ),
              ); // Navega para a tela NotificationConfirmService
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Diminui os cantos arredondados
              ),
            ),
            child: Text(
              'Confirmar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}