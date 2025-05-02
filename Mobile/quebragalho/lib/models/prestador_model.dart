class Prestador {
  final int id;
  final String descricao;
  final String? documentoPath;
  final List<int> usuarioIds;
  final List<int> servicosIds;
  final List<int> portfoliosIds;
  final List<int> chatsIds;
  final List<int> tagsIds;

  Prestador({
    required this.id,
    required this.descricao,
    this.documentoPath,
    this.usuarioIds = const [],
    this.servicosIds = const [],
    this.portfoliosIds = const [],
    this.chatsIds = const [],
    this.tagsIds = const [],
  });

  factory Prestador.fromJson(Map<String, dynamic> json) {
    return Prestador(
      id: json['id'] as int,
      descricao: json['descricao'] as String,
      documentoPath: json['documentoPath'] as String?,
      usuarioIds: (json['usuario'] as List)
          .map((a) => a is Map ? a['id'] as int : a as int)
          .toList() ?? [],
      servicosIds: (json['servicos'] as List)
          .map((a) => a is Map ? a['id'] as int : a as int)
          .toList() ?? [],
      portfoliosIds: (json['portfolios'] as List)
          .map((a) => a is Map ? a['id'] as int : a as int)
          .toList() ?? [],
      chatsIds: (json['chats'] as List)
          .map((a) => a is Map ? a['id'] as int : a as int)
          .toList() ?? [],
      tagsIds: (json['tags'] as List)
          .map((a) => a is Map ? a['id'] as int : a as int)
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      if (documentoPath != null) 'documentoPath': documentoPath,
      if (usuarioIds.isNotEmpty) 'usuario': usuarioIds,
      if (servicosIds.isNotEmpty) 'servicos': servicosIds,
      if (portfoliosIds.isNotEmpty) 'portfolios': portfoliosIds,
      if (chatsIds.isNotEmpty) 'chats': chatsIds,
      if (tagsIds.isNotEmpty) 'tags': tagsIds,
    };
  }

  Prestador copyWith({
    String? descricao,
    String? documentoPath,
    List<int>? servicosIds,
    List<int>? portfoliosIds,
    List<int>? chatsIds,
    List<int>? tagsIds,
    List<int>? usuarioIds,
  }) {
    return Prestador(
      id: id,
      descricao: descricao ?? this.descricao,
      documentoPath: documentoPath ?? this.documentoPath,
      usuarioIds: usuarioIds ?? this.usuarioIds,
      servicosIds: servicosIds ?? this.servicosIds,
      portfoliosIds: portfoliosIds ?? this.portfoliosIds,
      chatsIds: chatsIds ?? this.chatsIds,
      tagsIds: tagsIds ?? this.tagsIds,
    );
  }
}