import 'package:intl/intl.dart';

// Classe Resposta representa uma resposta associada a uma avaliação, contendo atributos como id, texto da resposta, data e id da avaliação.
class Resposta {
  final int id;
  final String resposta;
  final DateTime data;
  final int avaliacaoId;

  // Construtor da classe Resposta, inicializando os atributos obrigatórios.
  Resposta({
    required this.id,
    required this.resposta,
    required this.data,
    required this.avaliacaoId,
  });

  // Método de fábrica para criar uma instância de Resposta a partir de um JSON.
  factory Resposta.fromJson(Map<String, dynamic> json) {
    return Resposta(
      id: _parseInt(json["id"]), // Converte o ID para inteiro.
      resposta: json["resposta"] as String, // Obtém o texto da resposta.
      data: _parseDate(json["data"]), // Converte a data para DateTime.
      avaliacaoId: _parseAvaliacaoId(json["avaliacao"]), // Obtém o ID da avaliação.
    );
  }

  // Método para converter a instância de Resposta em um mapa JSON.
  Map<String, dynamic> toJson() => {
    "resposta": resposta, // Texto da resposta.
    "data": DateFormat('yyyy-MM-dd').format(data), // Formata a data no padrão ISO.
  };

  // Métodos auxiliares para conversão e validação de dados (ID, data e avaliação).
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0; // Retorna 0 se inválido.
    throw FormatException('Valor inválido para ID: $value');
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value); // Converte string para DateTime.
    throw FormatException('Formato de data inválido: $value');
  }

  static int _parseAvaliacaoId(dynamic value) {
    if (value is Map) return _parseInt(value['id']); // Extrai ID de um mapa.
    return _parseInt(value); // Converte diretamente para inteiro.
  }
}