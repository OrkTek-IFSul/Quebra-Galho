import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

// Classe responsável por gerenciar as operações relacionadas ao portfólio, como criar, listar e remover itens.
class PortfolioService {
  // URL base para o serviço de portfólio
  final String baseUrl = 'http://localhost:8080/api/portfolio';

  // Criar um novo item no portfólio com multipart/form-data
  Future<http.Response> criarPortfolioItem(Map<String, dynamic> requestBody, String url) async {
    var uri = Uri.parse(url);

    // Criação de um request multipart
    var request = http.MultipartRequest('POST', uri);

    // Verificar se o campo 'file' está presente e é válido
    if (requestBody['file'] != null) {
      // Para enviar um arquivo real (não apenas o caminho), use MultipartFile
      var file = await http.MultipartFile.fromPath(
        'file', 
        requestBody['file'], // Caminho do arquivo no dispositivo
        contentType: MediaType('image', 'jpeg'), // Exemplo de tipo de mídia
      );
      request.files.add(file);
    } else {
      throw Exception('Arquivo não encontrado!');
    }

    // Enviar o request e obter a resposta
    var response = await request.send();

    // A resposta de um `MultipartRequest` é um stream, então precisamos esperar que ela seja convertida em uma resposta
    var resp = await http.Response.fromStream(response);

    return resp;
  }

  // Lista os itens do portfólio para um prestador
  Future<http.Response> listarPortfolio(int prestadorId) async {
    var url = '$baseUrl/prestador/$prestadorId';
    var response = await http.get(Uri.parse(url));
    return response;
  }

  // Remove um item do portfólio pelo ID do item
  Future<http.Response> removerPortfolioItem(int portfolioId) async {
    var url = '$baseUrl/$portfolioId';
    var response = await http.delete(Uri.parse(url));
    return response;
  }
}
