class TagPrestador {
  final int? id; // id opcional, caso a API retorne
  final int tagId;
  final int prestadorId;

  TagPrestador({
    this.id,
    required this.tagId,
    required this.prestadorId,
  });

  factory TagPrestador.fromJson(Map<String, dynamic> json) {
    int extrairId(dynamic valor) {
      if (valor is Map && valor.containsKey('id')) return valor['id'] as int;
      if (valor is int) return valor;
      throw FormatException('Formato inválido para id');
    }

    return TagPrestador(
      id: json['id'] as int?, // se a API retornar
      tagId: extrairId(json['tag']),
      prestadorId: extrairId(json['prestador']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tag': tagId,
      'prestador': prestadorId,
    };
  }

  TagPrestador copyWith({
    int? tagId,
    int? prestadorId,
  }) {
    return TagPrestador(
      id: id,
      tagId: tagId ?? this.tagId,
      prestadorId: prestadorId ?? this.prestadorId,
    );
  }
}
