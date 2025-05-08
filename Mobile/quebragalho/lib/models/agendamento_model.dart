class Agendamento {
  final int? id;
  final DateTime dataHora;
  final bool status;
  final int servicoId;
  final int usuarioId;
  final String? observacoes;

  Agendamento({
    this.id,
    required this.dataHora,
    required this.status,
    required this.servicoId,
    required this.usuarioId,
    this.observacoes,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'] as int?,
      dataHora: DateTime.parse(json['dataHora'] as String),
      status: json['status'] as bool,
      servicoId: json['servico']['id'] as int,
      usuarioId: json['usuario']['id'] as int,
      observacoes: json['observacoes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataHora': dataHora.toIso8601String(),
      'status': status,
      if (observacoes != null) 'observacoes': observacoes,
    };
  }
}