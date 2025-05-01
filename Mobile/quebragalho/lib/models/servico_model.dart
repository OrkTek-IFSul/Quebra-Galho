class Servicos {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final List<int> agendamentosIds;
  final List<int> tagsIds;

  Servicos({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    this.agendamentosIds = const [],
    this.tagsIds = const [],
  });
  factory Servicos.fromJson(Map<String, dynamic> json) {
    return Servicos(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      preco: (json['preco'] as num).toDouble(),
      agendamentosIds: (json['agendamentos'] as List?)
          ?.map((a) => a is Map ? a['id'] as int : a as int)
          .toList() ?? [],
      tagsIds: (json['tags'] as List?)
          ?.map((t) => t is Map ? t['id'] as int : t as int)
          .toList() ?? [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      if (agendamentosIds.isNotEmpty) 'agendamentos': agendamentosIds,
      if (tagsIds.isNotEmpty) 'tags': tagsIds,
    };
  }

  Servicos copyWith({
    String? nome,
    String? descricao,
    double? preco,
    List<int>? agendamentosIds,
    List<int>? tagsIds,
  }) {
    return Servicos(
      id: id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      agendamentosIds: agendamentosIds ?? this.agendamentosIds,
      tagsIds: tagsIds ?? this.tagsIds,
    );
  }
}