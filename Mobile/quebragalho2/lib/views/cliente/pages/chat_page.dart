import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String chatId; // Ex: "IDUsuario1_IDUsuario20"

  ChatScreen({Key? key, required this.chatId}) : super(key: key);

  // Dentro da sua tela de chat, você terá um TextEditingController
final TextEditingController _messageController = TextEditingController();

void _sendMessage(String chatId, String currentUserId) {
  if (_messageController.text.trim().isEmpty) return;

  FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .add({
    'text': _messageController.text.trim(),
    'senderId': currentUserId, // ID do usuário logado
    'timestamp': FieldValue.serverTimestamp(), // O Firebase coloca a hora do servidor
  });

  _messageController.clear();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: StreamBuilder<QuerySnapshot>(
        // O Stream que "ouve" a coleção de mensagens do chat específico
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true) // Ordena as mais novas primeiro
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Envie a primeira mensagem!"));
          }

          final messages = snapshot.data!.docs;

          return ListView.builder(
            reverse: true, // Para o chat começar de baixo para cima
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var messageData = messages[index].data() as Map<String, dynamic>;
              // Aqui você constrói o widget de cada balão de mensagem
              return ListTile(
                title: Text(messageData['text']),
                subtitle: Text("Enviado por: ${messageData['senderId']}"),
              );
            },
          );
        },
      ),
      // Adicione aqui o campo de texto e o botão de enviar
    );
  }
}

