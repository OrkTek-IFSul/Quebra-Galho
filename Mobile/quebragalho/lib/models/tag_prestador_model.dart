class TagPrestador {
  final int tagId;
  final int prestadorId;

  TagPrestador({
    required this.tagId,
    required this.prestadorId,
  });

  factory TagPrestador.fromJson(Map<String, dynamic> json) {
    return TagPrestador(
      tagId: json['tagId'] as int,
      prestadorId: json['prestadorId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'prestadorId': prestadorId,
    };
  }
}