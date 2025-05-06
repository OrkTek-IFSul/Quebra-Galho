class ChatMessage {
  final String text;
  final bool isSent; // Indica se a mensagem foi enviada ou recebida
  final String timestamp;

  ChatMessage({
    required this.text,
    required this.isSent,
    required this.timestamp,
  });

  // Construtor para criar uma mensagem a partir de um JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isSent: json['isSent'],
      timestamp: json['timestamp'],
    );
  }

  // Converte a mensagem para JSON
  Map<String, dynamic> toJson() {
    return {'text': text, 'isSent': isSent, 'timestamp': timestamp};
  }
}
