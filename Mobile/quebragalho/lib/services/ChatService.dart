import 'dart:convert';
import 'package:flutter_quebragalho/models/ChatMessage.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _baseUrl = 'http://localhost:8080/api';

  static Future<void> sendMessage(ChatMessage message) async {
    final url = Uri.parse(
      '$_baseUrl/messages/send',
    ); // Supondo que a API tenha este endpoint
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': message.text,
        'timestamp': message.timestamp,
        // Adicione outros campos necessários, como o ID do usuário
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao enviar mensagem: ${response.statusCode}');
    }
  }
}
