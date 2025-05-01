class Tags {
  final int id;
  final String nome;
  final String status;
  final List<int> prestadoresIds;
  final List<int> servicosIds;

  Tags({
    required this.id,
    required this.nome,
    required this.status,
    this.prestadoresIds = const [],
    this.servicosIds = const [],
  });
   factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(
      id: json['id'] as int,
      nome: json['nome'] as String,
      status: json['status'] as String,
      prestadoresIds: (json['prestadores'] as List?)
          ?.map((p) => p is Map ? p['id'] as int : p as int)
          .toList() ?? [],
      servicosIds: (json['servicos'] as List?)
          ?.map((s) => s is Map ? s['id'] as int : s as int)
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'status': status,
      if (prestadoresIds.isNotEmpty) 'prestadores': prestadoresIds,
      if (servicosIds.isNotEmpty) 'servicos': servicosIds,
    };
  }

  Tags copyWith({
    String? nome,
    String? status,
    List<int>? prestadoresIds,
    List<int>? servicosIds,
  }) {
    return Tags(
      id: id,
      nome: nome ?? this.nome,
      status: status ?? this.status,
      prestadoresIds: prestadoresIds ?? this.prestadoresIds,
      servicosIds: servicosIds ?? this.servicosIds,
    );
  }
}