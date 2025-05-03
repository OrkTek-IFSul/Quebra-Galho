import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/ChatPage.dart';

class SolicitacaoItem extends StatelessWidget {
  final String nome;
  final String data;
  final String hora;
  final String status;
  final Color statusColor;

  const SolicitacaoItem({
    Key? key,
    required this.nome,
    required this.data,
    required this.hora,
    required this.status,
    required this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: status == 'Cancelado' ? 0.3 : 1.0, // Aplica opacidade de 30% para "Cancelado"
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade300,
            ),
            SizedBox(width: 16),
            // Informações do usuário
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Data: $data | Hora: $hora',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            // Botão de status com tamanho fixo
            SizedBox(
              width: 120, // Define uma largura fixa para todos os botões
              child: GestureDetector(
                onTap: () {
                  if (status == 'Conversar') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(), // Substitua por sua tela de chat
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: status == 'Pendente'
                        ? Colors.pink.shade100 // Rosa claro para "Pendente"
                        : statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center, // Centraliza o texto no botão
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: status == 'Conversar' ? FontWeight.w900 : FontWeight.w400,
                      color: status == 'Pendente'
                          ? Colors.purple.shade900 // Roxo forte para "Pendente"
                          : (status == 'Conversar' ? Colors.white : const Color.fromARGB(255, 28, 0, 46)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}