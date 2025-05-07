// Modelo que representa uma tag, incluindo atributos como nome, status e IDs relacionados a prestadores e serviços.
class Tag {
  final int? id; 
  final String nome;
  final String status;
  final List<int> prestadoresIds;
  final List<int> servicosIds;

  // Construtor para inicializar os atributos obrigatórios e opcionais.
  Tag({
    this.id,
    required this.nome,
    required this.status,
    this.prestadoresIds = const [],
    this.servicosIds = const [],
  });

  // Método de fábrica para criar uma instância de Tags a partir de um JSON.
  factory Tag.fromJson(Map<String, dynamic> json) {
    List<int> extrairIds(List? lista) {
      if (lista == null) return [];
      return lista.map<int>((item) {
        if (item is Map && item.containsKey('id')) return item['id'] as int;
        if (item is int) return item;
        throw FormatException('Formato inválido no item da lista');
      }).toList();
    }

    return Tag(
      id: json['id'] as int?,  // O id será retornado pela API
      nome: json['nome'] as String,
      status: json['status'] as String,
      prestadoresIds: extrairIds(json['prestadores']),
      servicosIds: extrairIds(json['servicos']),
    );
  }

  // Método para converter uma instância de Tags para JSON.
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'status': status,
      if (prestadoresIds.isNotEmpty) 'prestadores': prestadoresIds,
      if (servicosIds.isNotEmpty) 'servicos': servicosIds,
    };
  }

  // Método para criar uma cópia de Tags com modificações nos campos.
  Tag copyWith({
    String? nome,
    String? status,
    List<int>? prestadoresIds,
    List<int>? servicosIds,
  }) {
    return Tag(
      id: id,  // Mantendo o id original
      nome: nome ?? this.nome,
      status: status ?? this.status,
      prestadoresIds: prestadoresIds ?? this.prestadoresIds,
      servicosIds: servicosIds ?? this.servicosIds,
    );
  }
}
