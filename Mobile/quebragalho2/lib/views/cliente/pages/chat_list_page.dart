import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'dart:convert';
import 'package:quebragalho2/views/cliente/pages/chat_page.dart';

class ChatListScreen extends StatefulWidget {
  final int usuarioId;
  const ChatListScreen({super.key, required this.usuarioId});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<List<dynamic>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _chatsFuture = fetchChats(widget.usuarioId);
  }

  Future<List<dynamic>> fetchChats(int usuarioId) async {
    final url = 'https://${ApiConfig.baseUrl}/api/chats/$usuarioId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Erro ao buscar chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Conversas")),
      body: FutureBuilder<List<dynamic>>(
        future: _chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma conversa disponível."));
          }

          final chats = snapshot.data!;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                title: Text(chat['nomeServico'] ?? 'Sem nome'),
                subtitle: Text(chat['lastMessage'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatId: chat['agendamentoId'].toString(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
