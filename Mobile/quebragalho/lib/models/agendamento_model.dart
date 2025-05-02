class Agendamento {
  final int? id; 
  final DateTime dataHora;
  final bool status;
  final List<int> servicoIds;
  final List<int> usuarioIds;
  final List<int> avaliacaoIds;

  Agendamento({
    this.id,
    required this.dataHora,
    required this.status,
    this.servicoIds = const [],
    this.usuarioIds = const [],
    this.avaliacaoIds = const [],
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    List<int> extrairIds(List? lista) {
      if (lista == null) return [];
      return lista.map<int>((item) {
        if (item is Map && item.containsKey('id')) return item['id'] as int;
        if (item is int) return item;
        throw FormatException('Formato inválido no item da lista');
      }).toList();
    }

    return Agendamento(
      id: json['id'] as int?,  // O id será retornado pela API
      dataHora: DateTime.parse(json['dataHora'] as String),
      status: json['status'] as bool,
      servicoIds: extrairIds(json['servico']),
      usuarioIds: extrairIds(json['usuario']),
      avaliacaoIds: extrairIds(json['avaliacao']),
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'dataHora': dataHora.toIso8601String(),
    'status': status,
    'servico': servicoIds,
    'usuario': usuarioIds,
    'avaliacao': avaliacaoIds,
  };
}


  Agendamento copyWith({
    DateTime? dataHora,
    bool? status,
    List<int>? servicoIds,
    List<int>? usuarioIds,
    List<int>? avaliacaoIds,
  }) {
    return Agendamento(
      id: id,  // Mantendo o id original
      dataHora: dataHora ?? this.dataHora,
      status: status ?? this.status,
      servicoIds: servicoIds ?? this.servicoIds,
      usuarioIds: usuarioIds ?? this.usuarioIds,
      avaliacaoIds: avaliacaoIds ?? this.avaliacaoIds,
    );
  }
}
