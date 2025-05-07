// Modelo que representa um item do portfólio, incluindo atributos como id, caminho da imagem e prestador.
class PortfolioModel {
  final int? id;
  final String imgPortfolioPath;
  final String prestador;

  PortfolioModel({
    // Construtor para inicializar os atributos obrigatórios.
    required this.id,
    required this.imgPortfolioPath,
    required this.prestador,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    // Método de fábrica para criar uma instância de PortfolioModel a partir de um JSON.
    return PortfolioModel(
      id: json['id'],
      imgPortfolioPath: json['imgPortfolioPath'],
      prestador: json['prestador'],
    );
  }
}
