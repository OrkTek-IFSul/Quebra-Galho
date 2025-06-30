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

  Future<void> _refreshChats() async {
    if (usuarioId != null) {
      final chats = await fetchChats(usuarioId!);
      setState(() {
        _chatsFuture = Future.value(chats);
      });
    }
  }

  String decodeUtf8Safe(String? text) {
    if (text == null) return '';
    try {
      final bytes = text.codeUnits;
      return utf8.decode(bytes);
    } catch (_) {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (usuarioId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
                        (chat['participants'] as List).length > 1 &&
                        (chat['participants'] as List)[1].toString() ==
                            usuarioId.toString(),
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
                    (chat['clienteFotoUrl'] != null &&
                            chat['clienteFotoUrl'].toString().isNotEmpty)
                        ? 'https://${ApiConfig.baseUrl}/${chat['clienteFotoUrl']}'
                        : '';

                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: imageUrl.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  imageUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.chat_bubble, color: Colors.black54),
                      ),
                      title: Text(
                        chat['clienteNome'] ?? 'Sem nome',
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
