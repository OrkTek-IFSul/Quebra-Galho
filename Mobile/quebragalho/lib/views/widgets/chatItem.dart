import 'package:flutter/material.dart';

/// Widget que representa um item de chat com avatar, nome, mensagem e status de mensagem não lida.
/// Se a mensagem ultrapassar 30 caracteres ela será truncada.
Widget ChatItem({
  required String name,
  required String message,
  required String time,
  int unreadCount = 0,
}) {
  const int messageLimit = 30; // Limite de caracteres para exibir a mensagem

  // Se a mensagem possuir mais caracteres do que o limite, ela é truncada e finalizada com "..."
  String truncatedMessage =
      message.length > messageLimit
          ? '${message.substring(0, messageLimit)}...'
          : message;

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Avatar do usuário com indicador de mensagem não lida
            Stack(
              children: [
                // Avatar básico com fundo cinza
                CircleAvatar(radius: 24, backgroundColor: Colors.grey.shade300),
                // Se houver mensagens não lidas, exibe um pequeno indicador verde no canto inferior direito do avatar
                if (unreadCount > 0)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.green,
                    ),
                  ),
              ],
            ),
            SizedBox(
              width: 12,
            ), // Espaçamento entre o avatar e o conteúdo textual
            // Coluna que exibe o nome do usuário e a mensagem (truncada, se necessário)
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha o texto à esquerda
                children: [
                  // Exibe o nome do usuário em fonte maior e em negrito
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // Se houver mensagens não lidas, destaca com a cor púrpura; caso contrário, exibe em cinza
                      color: unreadCount > 0 ? Colors.purple : Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4), // Espaçamento entre o nome e a mensagem
                  // Exibe a mensagem truncada com um estilo de texto menor e cor cinza
                  Text(
                    truncatedMessage,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    overflow:
                        TextOverflow
                            .ellipsis, // Garante que o texto não ultrapasse o espaço disponível
                  ),
                ],
              ),
            ),

            // Coluna que exibe a hora da mensagem e, se houver, um contador para mensagens não lidas
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end, // Alinha o texto à direita
              children: [
                // Exibe a hora da mensagem
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
                // Se existir alguma mensagem não lida, exibe um ícone de contador em um círculo
                if (unreadCount > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount', // Número de mensagens não lidas
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      // Linha divisória para separar os itens do chat
      SizedBox(height: 8),
      Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
    ],
  );
}
