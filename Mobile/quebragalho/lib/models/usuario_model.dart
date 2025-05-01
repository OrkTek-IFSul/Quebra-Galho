class Usuario {
  // Declaração dos atributos da classe Usuario, com alguns opcionais (nullable) e valores padrão.
  final int id;
  final String nome;
  final String email;
  final String? senha;
  final String? documento;
  final String? telefone;
  final int numStrike;
  final String? imgPerfil;
  final bool isAdmin;
  final bool isModerador;

  // Construtor da classe, inicializando os atributos. Alguns possuem valores padrão.
  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.senha,
    this.documento,
    this.telefone,
    this.numStrike = 0,
    this.imgPerfil,
    this.isAdmin = false,
    this.isModerador = false,
  });

  // Método factory para criar uma instância de Usuario a partir de um Map (JSON).
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      senha: json['senha'] as String?,
      documento: json['documento'] as String?,
      telefone: json['telefone'] as String?,
      numStrike: json['numStrike'] as int? ?? 0, // Valor padrão se null.
      imgPerfil: json['imgPerfil'] as String?,
      isAdmin: json['isAdmin'] as bool? ?? false, // Valor padrão se null.
      isModerador: json['isModerador'] as bool? ?? false, // Valor padrão se null.
    );
  }

  // Método para converter a instância de Usuario em um Map (JSON).
  // Permite incluir dados sensíveis (como senha) opcionalmente.
  Map<String, dynamic> toJson({bool includeSensitive = false}) {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      if (includeSensitive && senha != null) 'senha': senha, // Inclui senha se permitido.
      if (documento != null) 'documento': documento,
      if (telefone != null) 'telefone': telefone,
      'numStrike': numStrike,
      if (imgPerfil != null) 'imgPerfil': imgPerfil,
      'isAdmin': isAdmin,
      'isModerador': isModerador,
    };
  }

  // Método para criar uma nova instância de Usuario com alterações em atributos específicos.
  Usuario copyWith({
    String? nome,
    String? email,
    String? senha,
    String? documento,
    String? telefone,
    String? imgPerfil,
    int? numStrike,
    bool? isAdmin,
    bool? isModerador,
  }) {
    return Usuario(
      id: id, // O ID permanece o mesmo.
      nome: nome ?? this.nome, // Usa o novo valor ou mantém o atual.
      email: email ?? this.email,
      senha: senha ?? this.senha,
      documento: documento ?? this.documento,
      telefone: telefone ?? this.telefone,
      numStrike: numStrike ?? this.numStrike,
      imgPerfil: imgPerfil ?? this.imgPerfil,
      isAdmin: isAdmin ?? this.isAdmin,
      isModerador: isModerador ?? this.isModerador,
    );
  }
}