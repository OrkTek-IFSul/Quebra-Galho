// Modelo que representa um serviço, incluindo atributos como nome, descrição, preço e associações com agendamentos e tags.
class Servicos {
  final int? id;
  final String nome;
  final String descricao;
  final double preco;
  final List<int> agendamentosIds;
  final List<int> tagsIds;

  // Construtor da classe Servicos, inicializando os atributos obrigatórios.
  Servicos({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    this.agendamentosIds = const [],
    this.tagsIds = const [],
  });

  // Método de fábrica para criar uma instância de Servicos a partir de um JSON.
  factory Servicos.fromJson(Map<String, dynamic> json) {
    List<int> extrairIds(List? lista) {
      if (lista == null) return [];
      return lista.map<int>((item) {
        if (item is Map && item.containsKey('id')) return item['id'] as int;
        if (item is int) return item;
        throw FormatException('Formato inválido no item da lista');
      }).toList();
    }

    return Servicos(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      preco: (json['preco'] as num).toDouble(),
      agendamentosIds: extrairIds(json['agendamentos']),
      tagsIds: extrairIds(json['tags']),
    );
  }

  // Método para converter uma instância de Servicos para JSON.
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

  // Método para criar uma cópia de Servicos com modificações nos campos.
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
