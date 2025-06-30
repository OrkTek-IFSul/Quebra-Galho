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

  Future<void> _refreshChats() async {
    final chats = await fetchChats(widget.usuarioId);
    setState(() {
      _chatsFuture = Future.value(chats);
    });
  }

  String decodeUtf8Safe(String? text) {
    if (text == null) return '';
    try {
      // Tenta decodificar de UTF8 para garantir caracteres especiais corretos
      final bytes = text.codeUnits;
      return utf8.decode(bytes);
    } catch (_) {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Minhas Conversas",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma conversa disponível."));
          }

          final chats =
              (snapshot.data! as List)
                  .where(
                    (chat) =>
                        (chat['participants'] as List).isNotEmpty &&
                        (chat['participants'] as List).first ==
                            widget.usuarioId.toString(),
                  )
                  .toList();

          if (chats.isEmpty) {
            return const Center(child: Text("Nenhuma conversa disponível."));
          }

          return RefreshIndicator(
            onRefresh: _refreshChats,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                final String imageUrl =
                    (chat['prestadorFotoUrl'] != null &&
                            chat['prestadorFotoUrl'].toString().isNotEmpty)
                        ? 'https://${ApiConfig.baseUrl}/${chat['prestadorFotoUrl']}'
                        : '';

                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
                        child: imageUrl.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  imageUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.chat_outlined, size: 25, color: Colors.black54),
                      ),
                      title: Text(
                        chat['prestadorNome'] ?? 'Sem nome',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        decodeUtf8Safe(chat['lastMessage']),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, thickness: 1),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
