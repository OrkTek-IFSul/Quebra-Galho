import 'package:flutter_quebragalho/models/professional.dart';

class ProfissionalService {
  Future<List<Professional>> getProfessionals() async {
    await Future.delayed(Duration(seconds: 2)); // Simulando requisição de dados
    return [
      Professional(
        name: 'Jean Luca',
        imageUrl: 'https://example.com/image.jpg',
        tag: 'Carinha do front',
        price: 100.0,
        isVerified: true,
      ),
      Professional(
        name: 'Jean Carlo',
        imageUrl: 'https://example.com/image2.jpg',
        tag: 'Electricista',
        price: 120.0,
        isVerified: false,
      ),
      // Mais profissionais...
    ];
  }
}
