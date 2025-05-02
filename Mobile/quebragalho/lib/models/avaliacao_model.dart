import 'package:flutter_quebragalho/models/resposta_model.dart';

class Avaliacao {
  final int? id;
  final int nota;
  final String comentario;
  final DateTime data;
  final int agendamentoId;
  final Resposta? resposta;

  Avaliacao({
    this.id,
    required this.nota,
    required this.comentario,
    required this.data,
    required this.agendamentoId,
    this.resposta,
  });

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    int extrairId(dynamic valor) {
      if (valor is Map && valor.containsKey('id')) return valor['id'] as int;
      if (valor is int) return valor;
      throw FormatException('Formato inválido para id');
    }

    return Avaliacao(
      id: json['id'] as int?,
      nota: _validarNota(json['nota']),
      comentario: json['comentario'] as String,
      data: DateTime.parse(json['data'] as String),
      agendamentoId: extrairId(json['agendamento']),
      resposta: json['resposta'] != null
          ? Resposta.fromJson(json['resposta'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nota': nota,
      'comentario': comentario,
      'data': data.toIso8601String(),
      'agendamento': agendamentoId,
      if (resposta != null) 'resposta': resposta!.toJson(),
    };
  }

  Avaliacao copyWith({
    int? nota,
    String? comentario,
    DateTime? data,
    int? agendamentoId,
    Resposta? resposta,
  }) {
    return Avaliacao(
      id: id,
      nota: nota ?? this.nota,
      comentario: comentario ?? this.comentario,
      data: data ?? this.data,
      agendamentoId: agendamentoId ?? this.agendamentoId,
      resposta: resposta ?? this.resposta,
    );
  }

  static int _validarNota(dynamic valor) {
    int nota;
    if (valor is int) {
      nota = valor;
    } else if (valor is String) {
      nota = int.tryParse(valor) ?? -1;
    } else {
      throw FormatException('Nota em formato inválido');
    }

    if (nota < 1 || nota > 5) {
      throw ArgumentError('Nota deve estar entre 1 e 5');
    }

    return nota;
  }
}
