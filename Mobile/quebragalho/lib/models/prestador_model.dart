// Modelo que representa um prestador de serviços, incluindo atributos como descrição, documentos e IDs relacionados.
import 'package:flutter_quebragalho/models/tag_model.dart';

class Prestador {
  final int? id;
  final String nome;
  final String email;
  final String descricao;
  final String? documentoPath;
  final String? imgPerfil;
  final bool isVerified;
  final List<int> usuarioIds;
  final List<int> servicosIds;
  final List<int> portfoliosIds;
  final List<int> chatsIds;
  final List<Tag> tags;

  // Construtor para inicializar os atributos obrigatórios e opcionais.
  Prestador({
    this.id,
    required this.nome,
    required this.email,
    required this.descricao,
    this.documentoPath,
    this.imgPerfil,
    this.isVerified = false,
    this.usuarioIds = const [],
    this.servicosIds = const [],
    this.portfoliosIds = const [],
    this.chatsIds = const [],
    this.tags = const [],
  });

  // Método de fábrica para criar uma instância de Prestador a partir de um JSON.
  factory Prestador.fromJson(Map<String, dynamic> json) {
    List<int> extrairIds(List? lista) {
      if (lista == null) return [];
      return lista.map<int>((item) {
        if (item is Map && item.containsKey('id')) return item['id'] as int;
        if (item is int) return item;
        throw FormatException('Formato inválido no item da lista');
      }).toList();
    }

    List<Tag> extrairTags(List? lista){
      if (lista == null) return [];
      return lista.map<Tag>((item) => Tag.fromJson(item)).toList();
    }

    return Prestador(
      id: json['id'] as int?,
      nome: json['nome'] as String? ?? 'Prestador sem nome',
      email: json['email'] as String? ?? 'Não possui email',
      descricao: json['descricao'] as String,
      documentoPath: json['documentoPath'] as String?,
      imgPerfil: json['imagemPerfilUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      usuarioIds: extrairIds(json['usuarios']),
      servicosIds: extrairIds(json['servico']),
      portfoliosIds: extrairIds(json['portfolios']),
      chatsIds: extrairIds(json['chats']),
      tags: extrairTags(json['tags']),
    );
  }

  // Método para converter uma instância de Prestador para JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'descricao': descricao,
      'servico': servicosIds,
      'portfolios': portfoliosIds,
      'chats': chatsIds,
      'tags': tags,
      'usuarios': usuarioIds,
      'isVerified': isVerified,
      if (documentoPath != null) 'documentoPath': documentoPath,
      if (imgPerfil != null) 'imagemPerfilUrl': imgPerfil,
    };
  }

  // Método para criar uma cópia de Prestador com modificações nos campos.
  Prestador copyWith({
    String? nome,
    String? email,
    String? descricao,
    String? documentoPath,
    String? imgPerfil,
    bool? isVerified,
    List<int>? servicosIds,
    List<int>? portfoliosIds,
    List<int>? chatsIds,
    List<int>? tagsIds,
    List<int>? usuarioIds,
  }) {
    return Prestador(
      id: id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      descricao: descricao ?? this.descricao,
      documentoPath: documentoPath ?? this.documentoPath,
      imgPerfil: imgPerfil ?? this.imgPerfil,
      isVerified: isVerified ?? this.isVerified,
      usuarioIds: usuarioIds ?? this.usuarioIds,
      servicosIds: servicosIds ?? this.servicosIds,
      portfoliosIds: portfoliosIds ?? this.portfoliosIds,
      chatsIds: chatsIds ?? this.chatsIds,
      tags: tags ?? this.tags,
    );
  }
}