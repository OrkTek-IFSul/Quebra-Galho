import 'dart:convert';
import 'package:http/http.dart' as http;

class Prestador {
  final int id;
  final String nome;
  final String email;
  final String descricao;
  final String imgPerfil;
  final String documentoPath;


  Prestador({
    required this.id,
    required this.nome,
    required this.email,
    required this.descricao,
    required this.imgPerfil,
    required this.documentoPath,
 
  });

  factory Prestador.fromJson(Map<String, dynamic> json) {
    return Prestador(
      id: json['id'],
      nome: json['nome'],
      email: json['email'] ?? '',
      descricao: json['descricao'] ?? '',
      imgPerfil: json['imgPerfil'] ?? '',
      documentoPath: json['documentoPath'] ?? '',
    );
  }

}

class PrestadorService {
  static const String baseUrl = 'http://192.168.0.155:8080/api';

  static Future<List<Prestador>> getPrestadores() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/prestadores'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        return jsonData.map((json) => Prestador.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar prestadores: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
