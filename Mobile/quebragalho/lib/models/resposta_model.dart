import 'package:intl/intl.dart';

// Classe Resposta representa uma resposta associada a uma avaliação, contendo atributos como id, texto da resposta, data e id da avaliação.
class Resposta {
  final int? id;
  final String resposta;
  final DateTime data;
  final List<int> avaliacaoIds;

  // Construtor da classe Resposta, inicializando os atributos obrigatórios.
  Resposta({
    required this.id,
    required this.resposta,
    required this.data,
    this.avaliacaoIds = const [],
  });

  // Método de fábrica para criar uma instância de Resposta a partir de um JSON.
  factory Resposta.fromJson(Map<String, dynamic> json) {
    List<int> extrairIds(List? lista) {
      if (lista == null) return [];
      return lista.map<int>((item) {
        if (item is Map && item.containsKey('id')) return item['id'] as int;
        if (item is int) return item;
        throw FormatException('Formato inválido no item da lista');
      }).toList();
    }
    return Resposta(
      id: json['id'] as int?,
      resposta: json['resposta'] as String,
      data: json['data'] as DateTime,
      avaliacaoIds: extrairIds(json['avaliacao']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resposta': resposta,
      'data': data,
      'avaliacao': avaliacaoIds
    };
  }

  Resposta copyWith({
    String? resposta,
    DateTime? data,
    List<int>? avaliacaoIds
  }) {
    return Resposta(
      id: id,
      resposta: resposta ?? this.resposta,
      data: data ?? this.data,
      avaliacaoIds: avaliacaoIds ?? this.avaliacaoIds,
    );
  }
}