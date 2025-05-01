import 'package:flutter_quebragalho/models/resposta_model.dart';

// Define a classe Avaliacao que representa uma avaliação com atributos como id, nota, comentário, data, agendamentoId e uma possível resposta.
class Avaliacao {
  final int id;
  final int nota;
  final String comentario;
  final DateTime data;
  final int agendamentoId;
  final Resposta? resposta;

  // Construtor da classe Avaliacao com parâmetros obrigatórios e opcionais.
  Avaliacao({
    required this.id,
    required this.nota,
    required this.comentario,
    required this.data,
    required this.agendamentoId,
    this.resposta,
  });

  // Método de fábrica para criar uma instância de Avaliacao a partir de um JSON.
  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: _parseInt(json["id"]),
      nota: _parseNota(json["nota"]),
      comentario: json["comentario"] as String,
      data: _parseDate(json["data"]),
      agendamentoId: _parseAgendamentoId(json["agendamento"]),
      resposta: json["resposta"] != null 
          ? Resposta.fromJson(json["resposta"])
          : null,
    );
  }

  // Converte a instância de Avaliacao para um mapa JSON.
  Map<String, dynamic> toJson() => {
    "nota": nota,
    "comentario": comentario,
    "data": data.toIso8601String(),
    if (resposta != null) "resposta": resposta!.toJson(),
  };

  // Método auxiliar para converter valores dinâmicos em inteiros.
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw FormatException('Valor inválido para ID: $value');
  }

  // Método auxiliar para validar e converter a nota, garantindo que esteja entre 1 e 5.
  static int _parseNota(dynamic value) {
    final nota = _parseInt(value);
    if (nota < 1 || nota > 5) {
      throw ArgumentError('Nota deve estar entre 1 e 5');
    }
    return nota;
  }

  // Método auxiliar para converter valores dinâmicos em DateTime.
  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    throw FormatException('Formato de data inválido: $value');
  }

  // Método auxiliar para extrair o ID do agendamento, seja ele um mapa ou um valor direto.
  static int _parseAgendamentoId(dynamic value) {
    if (value is Map) return _parseInt(value['id']);
    return _parseInt(value);
  }

  // Método para criar uma cópia da instância atual com uma nova resposta.
  Avaliacao copyWithResposta(Resposta? resposta) {
    return Avaliacao(
      id: id,
      nota: nota,
      comentario: comentario,
      data: data,
      agendamentoId: agendamentoId,
      resposta: resposta,
    );
  }
}

