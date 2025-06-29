import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'dart:convert';
import 'package:quebragalho2/views/cliente/pages/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<int?> obterIdPrestador() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('prestador_id');
}

Future<int?> obterIdUsuario() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('usuario_id');
}

class ChatListPrestador extends StatefulWidget {
  const ChatListPrestador({super.key});

  @override
  _ChatListPrestadorState createState() => _ChatListPrestadorState();
}

class _ChatListPrestadorState extends State<ChatListPrestador> {
  late Future<List<dynamic>> _chatsFuture;
  int? usuarioId;

  @override
  void initState() {
    super.initState();
    _loadUsuarioIdAndChats();
  }

  Future<void> _loadUsuarioIdAndChats() async {
    final id = await obterIdUsuario();
    setState(() {
      usuarioId = id;
      if (usuarioId != null) {
        _chatsFuture = fetchChats(usuarioId!);
      }
    });
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
    if (usuarioId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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

          final chats = (snapshot.data! as List)
              .where((chat) =>
                  (chat['participants'] as List).length > 1 &&
                  (chat['participants'] as List)[1].toString() == usuarioId.toString())
              .toList();

          if (chats.isEmpty) {
            return const Center(child: Text("Nenhuma conversa disponível."));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                title: Text(chat['clienteNome'] ?? 'Sem nome'),
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
