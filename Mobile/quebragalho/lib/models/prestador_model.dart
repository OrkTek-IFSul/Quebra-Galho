class Prestador {
  final int? id;
  final String descricao;
  final String? documentoPath;
  final List<int> usuarioIds;
  final List<int> servicosIds;
  final List<int> portfoliosIds;
  final List<int> chatsIds;
  final List<int> tagsIds;

  Prestador({
    this.id,
    required this.descricao,
    this.documentoPath,
    this.usuarioIds = const [],
    this.servicosIds = const [],
    this.portfoliosIds = const [],
    this.chatsIds = const [],
    this.tagsIds = const [],
  });

  factory Prestador.fromJson(Map<String, dynamic> json) {
    List<int> extrairIds(List? lista) {
      if (lista == null) return [];
      return lista.map<int>((item) {
        if (item is Map && item.containsKey('id')) return item['id'] as int;
        if (item is int) return item;
        throw FormatException('Formato inválido no item da lista');
      }).toList();
    }
    return Prestador(
      id: json['id'] as int?,
      descricao: json['descricao'] as String,
      documentoPath: json['documentoPath'] as String?,
      usuarioIds: extrairIds(json['usuarios']),
      servicosIds: extrairIds(json['servico']),
      portfoliosIds: extrairIds(json['portfolios']),
      chatsIds: extrairIds(json['chats']),
      tagsIds: extrairIds(json['tags']),
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'servico': servicosIds,
      'portfolios': portfoliosIds,
      'chats': chatsIds,
      'tags': tagsIds,
      'usuarios': usuarioIds,
      if (documentoPath != null) 'documentoPath': documentoPath,
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